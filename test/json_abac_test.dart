import 'package:casbin/casbin.dart';
import 'package:test/test.dart';
import 'dart:convert';

void main() {
  test('ABAC with JSON string should work', () {
    final model = Model()..loadModelFromText('''
[request_definition]
r = sub, obj, act

[policy_definition]
p = sub, obj, act, condition

[policy_effect]
e = some(where (p.eft == allow))

[matchers]
m = eval(p.condition) && r.obj == p.obj && r.act == p.act
''');

    final enforcer = Enforcer.initWithModelAndAdapter(model);
    
    // Add the policy from the issue
    enforcer.addPolicy(['{"age": 18}', '/data1', 'read', 'r.sub.age >= 18 && r.sub.age < 60']);
    
    // Test with JSON string (as the user tries to do)
    String subJson = jsonEncode({"age": 25});
    print("Testing with subject: $subJson");
    bool result = enforcer.enforce([subJson, '/data1', 'read']);
    print("Result: $result");
    
    expect(result, isTrue);
  });
}
