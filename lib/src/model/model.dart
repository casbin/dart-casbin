import 'dart:collection';
import 'package:casbin/src/config/config.dart';
import '../rbac/role_manager.dart';
import 'policy.dart';

/// Model represents the whole access control model.
class Model extends Policy {
  static HashMap<String, String> sectionNameMap = HashMap.from({
    'r': 'request_definition',
    'p': 'policy_definition',
    'g': 'role_definition',
    'e': 'policy_effect',
    'm': 'matchers'
  });

  bool loadAssertion(Model model, Config cfg, String sec, String key) => true;

  /// Adds an assertion to the model.
  ///
  /// [sec] is the section, "p" or "g".
  /// [key] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [value] is the policy rule, separated by ", ".
  bool addDef(String sec, String key, String value) => true;

  String getKeySuffix(int i) => '';

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
  String saveSectionToText(String sec) => '';

  /// Saves the model to the text and returns the model text.
  String saveModelToText() => '';

  /// Prints the model to the log.
  void printModel() {}

  @override
  void buildRoleLinks(RoleManager rm) {}

  /// printPolicy prints the policy to log.
  @override
  void printPolicy() {}

  /// printPolicy prints the policy to log.
  @override
  void clearPolicy() {}

  /// getPolicy gets all rules in a policy.
  @override
  List<List<String>> getPolicy(String sec, String ptype) => [];

  /// getFilteredPolicy gets rules based on field filters from a policy.
  @override
  List<List<String>> getFilteredPolicy(
          String sec, String ptype, int fieldIndex, List<String> fieldValues) =>
      [];

  /// hasPolicy determines whether a model has the specified policy rule.
  @override
  bool hasPolicy(String sec, String ptype, List<String> rule) => true;

  /// addPolicy adds a policy rule to the model.
  @override
  bool addPolicy(String sec, String ptype, List<String> rule) => true;

  /// removePolicy removes a policy rule from the model.
  @override
  bool removePolicy(String sec, String ptype, List<String> rule) => true;

  /// removeFilteredPolicy removes policy rules based on field filters from the model.
  @override
  bool removeFilteredPolicy(
          String sec, String ptype, int fieldIndex, List<String> fieldValues) =>
      true;

  /// getValuesForFieldInPolicy gets all values for a field for all rules in a policy, duplicated values are removed.
  @override
  List<String> getValuesForFieldInPolicy(
          String sec, String ptype, int fieldIndex) =>
      [];
}
