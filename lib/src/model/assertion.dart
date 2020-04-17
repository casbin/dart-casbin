import 'package:casbin/src/rbac/role_manager.dart';

/// Assertion represents an expression in a section of the model.
/// For example: r = sub, obj, act
class Assertion {
  String key;
  String value;
  List<String> tokens;
  List<List<String>> policy;
  RoleManager rm;

  void buildRoleLinks(RoleManager rm) {
    this.rm = rm;
    var count = 0;

    for (var i = 0; i < value.length; i++) {
      if (value[i] == '_') {
        count++;
      }
    }

    for (var rule in policy) {
      if (count < 2) {
        throw ArgumentError(
            'the number of \"_\" in role definition should be at least 2');
      }
      if (rule.length < count) {
        throw ArgumentError(
            'grouping policy elements do not meet role definition');
      }

      if (count == 2) {
        rm.addLink(rule.elementAt(0), rule.elementAt(1));
      } else if (count == 3) {
        rm.addLink(rule.elementAt(0), rule.elementAt(1), rule.elementAt(2));
      } else if (count == 4) {
        //rm.addLink(rule.elementAt(0), rule.elementAt(1), rule.elementAt(2), rule.elementAt(3));
      }
    }

    // todo(KNawm): Log "Role links for: " + key
    rm.printRoles();
  }
}
