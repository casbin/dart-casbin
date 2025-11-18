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

import 'package:collection/collection.dart';

import '../log/log_util.dart' as logutil;
import '../rbac/role_manager.dart';
import '../utils/utils.dart' as utils;
import 'assertion.dart';
import 'model.dart';

class Policy {
  HashMap<String, HashMap<String, Assertion>> model = HashMap();

  /// Initializes the roles in RBAC.
  ///
  /// [rm] is the role manager.
  void buildRoleLinks(RoleManager rm) {
    if (model.containsKey('g')) {
      for (var ast in model['g']!.values) {
        ast.buildRoleLinks(rm);
      }
    }
  }

  /// Saves the policy to the text and returns the text.
  String savePolicyToText() {
    final res = StringBuffer();

    if (model.containsKey('p')) {
      for (var entry in model['p']!.entries) {
        var key = entry.key;
        var ast = entry.value;
        for (var rule in ast.policy) {
          res.write('$key, ${rule.join(', ')}\n');
        }
      }
    }

    if (model.containsKey('g')) {
      for (var entry in model['g']!.entries) {
        var key = entry.key;
        var ast = entry.value;
        for (var rule in ast.policy) {
          res.write('$key, ${rule.join(', ')}\n');
        }
      }
    }

    return res.toString();
  }

  /// Prints the policy to log.
  void printPolicy() {
    var logger = logutil.getLogger();

    logger.logPolicy(model);
  }

  /// Clears all current policy.
  void clearPolicy() {
    if (model.containsKey('p')) {
      for (var ast in model['p']!.values) {
        ast.policy = <List<String>>[];
      }
    }

    if (model.containsKey('g')) {
      for (var ast in model['g']!.values) {
        ast.policy = <List<String>>[];
      }
    }
  }

  /// Returns all rules in a policy.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  List<List<String>> getPolicy(String sec, String ptype) {
    if (model[sec]?[ptype]?.policy == null) {
      throw Exception('$sec or $ptype do not exist in the policy');
    }
    return model[sec]![ptype]!.policy;
  }

  /// Returns the filtered policy rules of section [sec] and policy type [ptype].
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [fieldIndex] is the policy rule's start index to be matched.
  /// [fieldValues] are the field values to be matched, value "" means not to match this field.
  List<List<String>> getFilteredPolicy(
    String sec,
    String ptype,
    int fieldIndex,
    List<String> fieldValues,
  ) {
    var res = <List<String>>[];

    for (var rule in model[sec]![ptype]!.policy) {
      var matched = true;
      for (var i = 0; i < fieldValues.length; i++) {
        var fieldValue = fieldValues[i];
        if (fieldValue != '' && rule[fieldIndex + i] != fieldValue) {
          matched = false;
          break;
        }
      }

      if (matched) {
        res.add(rule);
      }
    }

    return res;
  }

  /// Returns whether a model has the specified policy rule.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [rule] is the policy rule.
  bool hasPolicy(String sec, String ptype, List<String> rule) {
    for (var r in model[sec]![ptype]!.policy) {
      if (ListEquality().equals(rule, r)) {
        return true;
      }
    }

    return false;
  }

  /// Adds a policy rule to the model.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [rule] is the policy rule.
  bool addPolicy(String sec, String ptype, List<String> rule) {
    if (!hasPolicy(sec, ptype, rule)) {
      model[sec]![ptype]!.policy.add(rule);
      return true;
    }
    return false;
  }

  ///
  /// addPolicies adds policy rules to the model.
  /// [sec] the section, "p" or "g".
  /// [ptype] the policy type, "p", "p2", .. or "g", "g2", ..
  /// [rules] the policy rules.
  bool addPolicies(String sec, String ptype, List<List<String>> rules) {
    var size = model[sec]![ptype]!.policy.length;
    for (var rule in rules) {
      if (!hasPolicy(sec, ptype, rule)) {
        model[sec]![ptype]!.policy.add(rule);
      }
    }
    return size < model[sec]![ptype]!.policy.length;
  }

  ///
  ///UpdatePolicy updates a policy rule from the model.
  ///
  /// [sec] the section, "p" or "g".
  /// [ptype] the policy type, "p", "p2", .. or "g", "g2", ..
  /// [oldRule] the old rule.
  /// [newRule] the new rule.
  bool updatePolicy(
      String sec, String ptype, List<String> oldRule, List<String> newRule) {
    if (!hasPolicy(sec, ptype, oldRule)) {
      return false;
    }
    model[sec]![ptype]!.policy.remove(oldRule);
    model[sec]![ptype]!.policy.add(newRule);
    return true;
  }

  /// Removes a policy rule from the model.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [rule] is the policy rule.
  bool removePolicy(String sec, String ptype, List<String> rule) {
    for (var i = 0; i < model[sec]![ptype]!.policy.length; i++) {
      var r = model[sec]![ptype]!.policy[i];
      if (ListEquality().equals(rule, r)) {
        if (model[sec]?[ptype]?.policy.removeAt(i) != null) {
          return true;
        }
      }
    }
    return false;
  }

  /// removePolicies removes rules from the current policy.
  /// [sec] the section, "p" or "g".
  /// [ptype] the policy type, "p", "p2", .. or "g", "g2", ..
  /// [rules] the policy rules.
  /// [succeeds] or not.
  bool removePolicies(String sec, String ptype, List<List<String>> rules) {
    var size = model[sec]![ptype]!.policy.length;
    for (var rule in rules) {
      for (var i = 0; i < model[sec]![ptype]!.policy.length; i++) {
        var r = model[sec]![ptype]!.policy[i];
        if (ListEquality().equals(rule, r)) {
          model[sec]![ptype]!.policy.removeAt(i);
        }
      }
    }
    return size > model[sec]![ptype]!.policy.length;
  }

  /// Removes policy rules based on field filters from the model.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [fieldIndex] is the policy rule's start index to be matched.
  /// [fieldValues] are the field values to be matched, value "" means not to match this field.
  /// [return] succeeds(effects.size() &gt; 0) or not.
  List<List<String>> removeFilteredPolicyReturnsEffects(
      String sec, String ptype, int fieldIndex, List<String> fieldValues) {
    var tmp = <List<String>>[];
    var effects = <List<String>>[];
    var firstIndex = -1;

    for (var rule in model[sec]![ptype]!.policy) {
      var matched = true;
      for (var i = 0; i < fieldValues.length; i++) {
        var fieldValue = fieldValues[i];
        if (fieldValue != '' && rule[fieldIndex + i] != fieldValue) {
          matched = false;
          break;
        }
      }

      if (matched) {
        if (firstIndex == -1) {
          firstIndex = model[sec]![ptype]!.policy.indexOf(rule);
        }
        effects.add(rule);
      } else {
        tmp.add(rule);
      }
    }

    if (firstIndex != -1) {
      model[sec]![ptype]!.policy = tmp;
    }

    return effects;
  }

  /// Removes policy rules based on field filters from the model.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [fieldIndex] is the policy rule's start index to be matched.
  /// [fieldValues] are the field values to be matched, value "" means not to match this field.
  bool removeFilteredPolicy(
      String sec, String ptype, int fieldIndex, List<String> fieldValues) {
    return removeFilteredPolicyReturnsEffects(
            sec, ptype, fieldIndex, fieldValues)
        .isNotEmpty;
  }

  /// Returns all values for a field for all rules in a policy, duplicated values are removed.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [fieldIndex] is the policy rule's index.
  List<String> getValuesForFieldInPolicy(
      String sec, String ptype, int fieldIndex) {
    var values = <String>[];

    for (var rule in model[sec]?[ptype]?.policy ?? []) {
      values.add(rule[fieldIndex]);
    }

    values = utils.arrayRemoveDuplicates(values);

    return values;
  }

  void buildIncrementalRoleLinks(RoleManager rm, PolicyOperations op,
      String sec, String ptype, List<List<String>> rules) {
    if (sec == 'g') {
      model[sec]?[ptype]?.buildIncrementalRoleLinks(rm, op, rules);
    }
  }

  bool hasPolicies(String sec, String ptype, List<List<String>> rules) {
    for (var rule in rules) {
      if (hasPolicy(sec, ptype, rule)) {
        return true;
      }
    }
    return false;
  }
}
