import 'dart:collection';

import '../model/assertion.dart';
import '../rbac/domain_roles.dart';

/// Logger is the logging interface implementation.
abstract class Logger {
  /// enableLog controls whether print the message.
  void enableLog(bool enable);

  /// isEnabled returns if logger is enabled.
  bool isEnabled();

  /// prints log info
  void logPrint(String message);

  /// logModel log info related to model.
  void logModel(HashMap<String, HashMap<String, Assertion>> model);

  /// logRole log info related to role.
  void logRole(Map<String, DomainRoles> allDomains);

  /// logPolicy log info related to policy.
  void logPolicy(HashMap<String, HashMap<String, Assertion>> model);
}
