// Copyright 2018-2021 The Casbin Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:collection';

import '../config/config.dart';
import 'policy.dart';
import '../rbac/role_manager.dart';

import 'assertion.dart';

/// Model represents the whole access control model.
class Model extends Policy {
  static HashMap<String, String> sectionNameMap = HashMap.from({
    'r': 'request_definition',
    'p': 'policy_definition',
    'g': 'role_definition',
    'e': 'policy_effect',
    'm': 'matchers'
  });

  bool loadAssertion(Model model, Config cfg, String sec, String key) {
    var secName = sectionNameMap[sec];
    var value = cfg.getString(secName! + '::' + key);
    return model.addDef(sec, key, value);
  }

  /// Adds an assertion to the model.
  ///
  /// [sec] is the section, "p" or "g".
  /// [key] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [value] is the policy rule, separated by ", ".
  bool addDef(String sec, String key, String value) {
    var ast = Assertion();
    ast.key = key;
    ast.value = value;

    if (ast.value.isEmpty) {
      return false;
    }

    if (sec == 'r' || sec == 'p') {
      final tokens = value.split(',').map((e) => e.trim()).toList();
      for (var i = 0; i < tokens.length; i++) {
        tokens[i] = key + '_' + tokens[i];
      }
      ast.tokens = tokens;
    } else if (sec == 'm') {
      final regEx = RegExp('/\"(.*?)\"/g');
      final str = regEx.allMatches(value).toList();

      for (var i in str) {
        value = value.replaceAll(i.toString(), '\$<$i>');
      }

      value = escapeAssertion(value);

      for (var i in str) {
        value = value.replaceAll('\$<$i>', i.toString());
      }
      ast.value = value;
    } else {
      ast.value = escapeAssertion(value);
    }

    final nodeMap = model[sec];

    if (nodeMap != null) {
      nodeMap[key] = ast;
    } else {
      final astMap = HashMap<String, Assertion>();
      astMap[key] = ast;
      model[sec] = astMap;
    }

    return true;
  }

  String getKeySuffix(int i) {
    if (i == 1) {
      return '';
    }

    return i.toString();
  }

  void loadSection(Model model, Config cfg, String sec) {
    var i = 1;
    while (true) {
      if (!loadAssertion(model, cfg, sec, sec + getKeySuffix(i))) {
        break;
      } else {
        i++;
      }
    }
  }

  /// Helper function for loadModel
  void loadSections(Config cfg) {
    loadSection(this, cfg, 'r');
    loadSection(this, cfg, 'p');
    loadSection(this, cfg, 'e');
    loadSection(this, cfg, 'm');
    loadSection(this, cfg, 'g');
  }

  /// Loads the model from model CONF file.
  ///
  /// [path] is the path of the model file.
  void loadModel(String path) {
    final cfg = Config.newConfig(path);

    loadSections(cfg);
  }

  /// Loads the model from the text.
  ///
  /// [text] is the model text.
  void loadModelFromText(String text) {}

  /// Saves the section to the text and returns the section text.
  String saveSectionToText(String sec) => '';

  /// Saves the model to the text and returns the model text.
  String saveModelToText() => '';

  /// Prints the model to the log.
  void printModel() {}

  @override
  void buildRoleLinks(RoleManager rm) {}

  /// Prints the policy to log.
  @override
  void printPolicy() {}

  /// Prints the policy to log.
  @override
  void clearPolicy() {}

  /// Gets all rules in a policy.
  @override
  List<List<String>> getPolicy(String sec, String ptype) => [];

  /// Gets rules based on field filters from a policy.
  @override
  List<List<String>> getFilteredPolicy(
          String sec, String ptype, int fieldIndex, List<String> fieldValues) =>
      [];

  /// Determines whether a model has the specified policy rule.
  @override
  bool hasPolicy(String sec, String ptype, List<String> rule) => true;

  /// Adds a policy rule to the model.
  @override
  bool addPolicy(String sec, String ptype, List<String> rule) => true;

  /// Removes a policy rule from the model.
  @override
  bool removePolicy(String sec, String ptype, List<String> rule) => true;

  /// Removes policy rules based on field filters from the model.
  @override
  bool removeFilteredPolicy(
          String sec, String ptype, int fieldIndex, List<String> fieldValues) =>
      true;

  /// Gets all values for a field for all rules in a policy, duplicated values are removed.
  @override
  List<String> getValuesForFieldInPolicy(
          String sec, String ptype, int fieldIndex) =>
      [];
}

/// escapeAssertion escapes the dots in the assertion, because the
/// expression evaluation doesn't support such variable names.
String escapeAssertion(String s) {
  s = s.replaceAll(RegExp(r'r\.'), 'r_');
  s = s.replaceAll(RegExp(r'p\.'), 'p_');
  return s;
}
