import 'dart:collection';

import 'package:casbin/src/config/config.dart';
import 'package:casbin/src/model/assertion.dart';
import 'package:casbin/src/model/policy.dart';

/// Model represents the whole access control model.
class Model extends Policy {
  static HashMap<String, String> sectionNameMap = HashMap.from({
    'r': 'request_definition',
    'p': 'policy_definition',
    'g': 'role_definition',
    'e': 'policy_effect',
    'm': 'matchers'
  });

  bool loadAssertion(Model model, Config cfg, String sec, String key) {}

  /// Adds an assertion to the model.
  ///
  /// [sec] is the section, "p" or "g".
  /// [key] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [value] is the policy rule, separated by ", ".
  bool addDef(String sec, String key, String value) {}

  String getKeySuffix(int i) {}

  void loadSection(Model model, Config cfg, String sec) {}

  /// Loads the model from model CONF file.
  ///
  /// [path] is the path of the model file.
  void loadModel(String path) {}

  /// Loads the model from the text.
  ///
  /// [text] is the model text.
  void loadModelFromText(String text) {}

  /// Saves the section to the text and returns the section text.
  String saveSectionToText(String sec) {}

  /// Saves the model to the text and returns the model text.
  String saveModelToText() {}

  /// Prints the model to the log.
  void printModel() {}
}
