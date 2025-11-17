import 'package:casbin/casbin.dart';
import 'package:test/test.dart';
import 'dart:convert';

void main() {
  group('ABAC with JSON strings', () {
    test('should allow access when age is in valid range', () {
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
      
      // Test with JSON string - age 25 should be allowed
      String subJson = jsonEncode({"age": 25});
      bool result = enforcer.enforce([subJson, '/data1', 'read']);
      
      expect(result, isTrue);
    });
    
    test('should deny access when age is below minimum', () {
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
      
      // Test with JSON string - age 16 should be denied
      String subJson = jsonEncode({"age": 16});
      bool result = enforcer.enforce([subJson, '/data1', 'read']);
      
      expect(result, isFalse);
    });
    
    test('should deny access when age is above maximum', () {
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
      
      // Test with JSON string - age 65 should be denied
      String subJson = jsonEncode({"age": 65});
      bool result = enforcer.enforce([subJson, '/data1', 'read']);
      
      expect(result, isFalse);
    });
    
    test('should work with multiple attributes in JSON', () {
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
      
      // Add policy with multiple attribute checks
      enforcer.addPolicy(['{"age": 18, "role": "user"}', '/data1', 'read', 'r.sub.age >= 18 && r.sub.role == "admin"']);
      
      // Test with JSON string - should be allowed
      String subJson = jsonEncode({"age": 25, "role": "admin"});
      bool result = enforcer.enforce([subJson, '/data1', 'read']);
      
      expect(result, isTrue);
    });
    
    test('should deny with wrong role attribute', () {
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
      
      // Add policy with multiple attribute checks
      enforcer.addPolicy(['{"age": 18, "role": "user"}', '/data1', 'read', 'r.sub.age >= 18 && r.sub.role == "admin"']);
      
      // Test with JSON string - should be denied due to role mismatch
      String subJson = jsonEncode({"age": 25, "role": "user"});
      bool result = enforcer.enforce([subJson, '/data1', 'read']);
      
      expect(result, isFalse);
    });
    
    test('should work with boundary value at minimum', () {
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
      
      enforcer.addPolicy(['{"age": 18}', '/data1', 'read', 'r.sub.age >= 18 && r.sub.age < 60']);
      
      // Test with age exactly at minimum boundary
      String subJson = jsonEncode({"age": 18});
      bool result = enforcer.enforce([subJson, '/data1', 'read']);
      
      expect(result, isTrue);
    });
    
    test('should deny with boundary value at maximum', () {
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
      
      enforcer.addPolicy(['{"age": 18}', '/data1', 'read', 'r.sub.age >= 18 && r.sub.age < 60']);
      
      // Test with age exactly at maximum boundary (should be denied because < 60)
      String subJson = jsonEncode({"age": 60});
      bool result = enforcer.enforce([subJson, '/data1', 'read']);
      
      expect(result, isFalse);
    });
  });
  
  group('ABAC with AbacClass (existing functionality)', () {
    test('should still work with AbacClass objects', () {
      final model = Model()..loadModelFromText('''
[request_definition]
r = sub, obj, act

[policy_definition]
p = sub_rule, obj, act

[policy_effect]
e = some(where (p.eft == allow))

[matchers]
m = eval(p.sub_rule) && r.obj == p.obj && r.act == p.act
''');

      final enforcer = Enforcer.initWithModelAndAdapter(model);
      
      enforcer.addPolicy(['r.sub.Age > 18', '/data1', 'read']);
      
      // Test with AbacClass instance
      final subject = TestSubject(25, 'Alice');
      bool result = enforcer.enforce([subject, '/data1', 'read']);
      
      expect(result, isTrue);
    });
  });
}

// Test class that implements AbacClass
class TestSubject implements AbacClass {
  final int Age;
  final String Name;
  
  TestSubject(this.Age, this.Name);
  
  @override
  Map<String, dynamic> toMap() {
    return {'Age': Age, 'Name': Name};
  }
}
