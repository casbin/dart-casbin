import '../rbac/role_manager.dart';

dynamic generateGFunction(RoleManager? rm) {
  final memorized = <String, bool>{};

  bool func(List? args) {
    final key = args.toString();
    var value = memorized[key];

    if (value != null) {
      return value;
    }

    final name1 = args?[0] ?? '';
    final name2 = args?[1] ?? '';

    if (rm == null) {
      value = name1 == name2;
    } else if (args!.length == 2) {
      value = rm.hasLink(name1, name2);
    } else {
      final domain = args[2];
      value = rm.hasLink(name1, name2, [domain]);
    }
    memorized[key] = value;
    return value;
  }

  return func;
}
