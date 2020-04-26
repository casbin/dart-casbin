import 'package:casbin/src/model/model.dart';

/// Interface for Casbin adapters.
abstract class Adapter {
  /// Loads all policy rules from the storage.
  ///
  /// [model] is the model.
  void loadPolicy(Model model);

  /// Saves all policy rules to the storage.
  ///
  /// [model] is the model.
  void savePolicy(Model model);

  /// addPolicy adds a policy rule to the storage.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [rule] is the rule, like (sub, obj, act).
  /// This is part of the Auto-Save feature.
  void addPolicy(String sec, String ptype, List<String> rule);

  /// removePolicy removes a policy rule from the storage.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [rule] is the rule, like (sub, obj, act).
  /// This is part of the Auto-Save feature.
  void removePolicy(String sec, String ptype, List<String> rule);

  /// removeFilteredPolicy removes policy rules that match the filter from the storage.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [fieldIndex] is the policy rule's start index to be matched.
  /// [fieldValues] is the field values to be matched, value '' means not to match this field.
  /// This is part of the Auto-Save feature.
  void removeFilteredPolicy(
      String sec, String ptype, int fieldIndex, List<String> fieldValues);
}
