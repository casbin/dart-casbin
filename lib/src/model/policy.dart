import 'dart:collection';
import 'package:casbin/src/rbac/role_manager.dart';
import 'package:casbin/src/model/assertion.dart';

class Policy {
  HashMap<String, HashMap<String, Assertion>> model;

  /// Initializes the roles in RBAC.
  ///
  /// [rm] is the role manager.
  void buildRoleLinks(RoleManager rm) {
    if (model.containsKey('g')) {
      for (var ast in model['g'].values) {
        ast.buildRoleLinks(rm);
      }
    }
  }

  /// Prints the policy to log.
  void printPolicy() {}

  /// Saves the policy to the text and returns the text.
  String savePolicyToText() {}

  /// Clears all current policy.
  void clearPolicy() {}

  /// Returns all rules in a policy.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  List<List<String>> getPolicy(String sec, String ptype) {}

  /// Returns the filtered policy rules of section [sec] and policy type [ptype].
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [fieldIndex] is the policy rule's start index to be matched.
  /// [fieldValues] are the field values to be matched, value "" means not to match this field.
  List<List<String>> getFilteredPolicy(
      String sec, String ptype, int fieldIndex, List<String> fieldValues) {}

  /// Returns whether a model has the specified policy rule.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [rule] is the policy rule.
  bool hasPolicy(String sec, String ptype, List<String> rule) {}

  /// Adds a policy rule to the model.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [rule] is the policy rule.
  bool addPolicy(String sec, String ptype, List<String> rule) {}

  /// Removes a policy rule from the model.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [rule] is the policy rule.
  bool removePolicy(String sec, String ptype, List<String> rule) {}

  /// Removes policy rules based on field filters from the model.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [fieldIndex] is the policy rule's start index to be matched.
  /// [fieldValues] are the field values to be matched, value "" means not to match this field.
  bool removeFilteredPolicy(
      String sec, String ptype, int fieldIndex, List<String> fieldValues) {}

  /// Returns all values for a field for all rules in a policy, duplicated values are removed.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [fieldIndex] is the policy rule's index.
  List<String> getValuesForFieldInPolicy(
      String sec, String ptype, int fieldIndex) {}
}
