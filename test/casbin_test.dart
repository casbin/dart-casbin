import 'package:casbin/casbin.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {

    setUp(() {
      awesome = Awesome();
    });

    test('First Test', () {
      expect(awesome.isAwesome, isTrue);
    });
  });
}

void testEnforce(Enforcer e, String sub, Object obj, String act, bool res) {
  assert(res, e.enforce(sub, obj, act));
}