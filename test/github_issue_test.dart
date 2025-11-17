// Copyright 2018-2021 The Casbin Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// This test validates the exact scenario described in the GitHub issue
/// to ensure the fix works as expected for the user's use case.

import 'package:casbin/casbin.dart';
import 'package:test/test.dart';
import 'dart:convert';

void main() {
  test('GitHub issue scenario - ABAC with JSON should work exactly as described', () {
    // Exact model from the GitHub issue
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
    
    // Exact policy from the GitHub issue
    final policyLine = 'p, {"age": 18}, /data1, read, r.sub.age >= 18 && r.sub.age < 60';
    final parts = policyLine.split(',').map((e) => e.trim()).toList();
    
    // Remove the 'p' prefix and add the policy
    enforcer.addPolicy([parts[1], parts[2], parts[3], parts[4]]);
    
    // Test with age 25 (should be allowed)
    String subJson = jsonEncode({"age": 25});
    bool result = enforcer.enforce([subJson, '/data1', 'read']);
    
    expect(result, isTrue, reason: 'Age 25 should be allowed (18 <= 25 < 60)');
    
    // Test with age 18 (boundary, should be allowed)
    subJson = jsonEncode({"age": 18});
    result = enforcer.enforce([subJson, '/data1', 'read']);
    expect(result, isTrue, reason: 'Age 18 should be allowed (boundary condition)');
    
    // Test with age 17 (should be denied)
    subJson = jsonEncode({"age": 17});
    result = enforcer.enforce([subJson, '/data1', 'read']);
    expect(result, isFalse, reason: 'Age 17 should be denied (< 18)');
    
    // Test with age 60 (should be denied)
    subJson = jsonEncode({"age": 60});
    result = enforcer.enforce([subJson, '/data1', 'read']);
    expect(result, isFalse, reason: 'Age 60 should be denied (>= 60)');
    
    // Test with age 59 (boundary, should be allowed)
    subJson = jsonEncode({"age": 59});
    result = enforcer.enforce([subJson, '/data1', 'read']);
    expect(result, isTrue, reason: 'Age 59 should be allowed (18 <= 59 < 60)');
  });
}
