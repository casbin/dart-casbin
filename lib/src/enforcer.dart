import 'package:casbin/src/core_enforcer.dart';
import 'package:casbin/src/persist/adapter.dart';

class Enforcer extends CoreEnforcer {
  /// Initializes an enforcer.
  ///
  /// [model] is a model or the path of the model file.
  /// [policyFile] is the path of the policy file.
  /// [adapter] is the adapter.
  /// [enableLog] whether to enable Casbin's log.
  Enforcer(var model, String policyFile, Adapter adapter, bool enableLog);
}
