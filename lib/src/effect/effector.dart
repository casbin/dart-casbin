import 'effect.dart';

/// Interface for Casbin effectors.
abstract class Effector {
  /// Merges all matching results collected by the enforcer into a single decision
  /// and returns the final effect.
  ///
  /// [expr] is the expression of __policy_effect__.
  /// [effects] are the effects of all matched rules.
  /// [results] is the matcher results of all matched rules.
  bool mergeEffects(String expr, List<Effect> effects, List<double> results);
}
