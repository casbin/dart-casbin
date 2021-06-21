import 'package:casbin/casbin.dart';
import 'package:casbin/src/rbac/role_manager.dart';
import 'package:test/test.dart';

void testEnforce(
  String title,
  Enforcer e,
  String sub,
  String obj,
  String act,
  bool res,
) {
  test(title, () {
    expect(e.enforce([sub, obj, act]), equals(res));
  });
}

void testDomainEnforce(
  String title,
  Enforcer e,
  String sub,
  String domain,
  String obj,
  String act,
  bool res,
) {
  test(title, () {
    expect(e.enforce([sub, domain, obj, act]), equals(res));
  });
}

void testRole(
  String title,
  RoleManager rm,
  String name1,
  String name2,
  bool res,
) {
  test(title, () {
    expect(rm.hasLink(name1, name2), equals(res));
  });
}

void testDomainRole(
  String title,
  RoleManager rm,
  String name1,
  String name2,
  List<String> domain,
  bool res,
) {
  test(title, () {
    expect(rm.hasLink(name1, name2, domain), equals(res));
  });
}
