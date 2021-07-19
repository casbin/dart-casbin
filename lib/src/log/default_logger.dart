import 'dart:collection';

import '../model/assertion.dart';
import '../rbac/domain_roles.dart';
import 'logger.dart';

class DefaultLogger implements Logger {
  bool _enable = false;
  @override
  void enableLog(bool enable) {
    _enable = enable;
  }

  @override
  bool isEnabled() {
    return _enable;
  }

  @override
  void logPrint(String message) {
    if (!_enable) {
      return;
    }
    print(message);
  }

  @override
  void logModel(HashMap<String, HashMap<String, Assertion>> model) {
    if (!_enable) {
      return;
    }

    print('Model:');
    for (var entry in model.entries) {
      for (var entry2 in entry.value.entries) {
        print('${entry.key}.${entry2.key}: ${entry2.value.value}');
      }
    }
  }

  @override
  void logPolicy(HashMap<String, HashMap<String, Assertion>> model) {
    if (!_enable) {
      return;
    }
    print('Policy:');
    if (model.containsKey('p')) {
      for (var entry in model['p']!.entries) {
        var key = entry.key;
        var ast = entry.value;
        print(key + ': ' + ast.value + ': ' + ast.policy.toString());
      }
    }

    if (model.containsKey('g')) {
      for (var entry in model['g']!.entries) {
        var key = entry.key;
        var ast = entry.value;
        print(key + ': ' + ast.value + ': ' + ast.policy.toString());
      }
    }
  }

  @override
  void logRole(Map<String, DomainRoles> allDomains) {
    if (!_enable) {
      return;
    }
    allDomains.forEach(
      (domain, roles) => roles.roles.forEach(
        (name, role) => print(
          role.toString(),
        ),
      ),
    );
  }
}
