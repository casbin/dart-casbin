import 'package:casbin/casbin.dart';
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
