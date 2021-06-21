import '../rbac/role_manager.dart';

dynamic generateGFunction(RoleManager? rm) {
  final memorized = <String, bool>{};

  bool func(String name1, String name2, [String? domain]) {
    final key = name1 + name2 + (domain ?? '');
    var value = memorized[key];

    if (value != null) {
      return value;
    }

    if (rm == null) {
      value = name1 == name2;
    } else if (domain == null) {
      value = rm.hasLink(name1, name2);
    } else {
      value = rm.hasLink(name1, name2, [domain]);
    }
    memorized[key] = value;
    return value;
  }

  return func;
}
