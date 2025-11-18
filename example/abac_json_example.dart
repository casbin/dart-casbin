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

import 'package:casbin/casbin.dart';
import 'dart:convert';

/// This example demonstrates ABAC (Attribute-Based Access Control) 
/// using JSON strings as subjects.
///
/// This is particularly useful for Flutter/Dart applications where
/// you want to pass user attributes as JSON without creating 
/// custom classes that implement AbacClass.
void main() {
  print('=== ABAC with JSON Strings Example ===\n');

  // Define the model with ABAC support
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

  // Create an enforcer
  final enforcer = Enforcer.initWithModelAndAdapter(model);

  // Add policies with attribute-based conditions
  print('Adding policies...');
  enforcer.addPolicy([
    '{"age": 18}',
    '/data1',
    'read',
    'r.sub.age >= 18 && r.sub.age < 60'
  ]);
  
  enforcer.addPolicy([
    '{"role": "admin"}',
    '/admin',
    'write',
    'r.sub.role == "admin" && r.sub.age >= 21'
  ]);
  
  print('Policies added.\n');

  // Test Case 1: Valid age for /data1
  print('--- Test Case 1: User with age 25 accessing /data1 ---');
  String user1 = jsonEncode({"age": 25});
  bool result1 = enforcer.enforce([user1, '/data1', 'read']);
  print('User: $user1');
  print('Resource: /data1, Action: read');
  print('Result: ${result1 ? "✅ Access Granted" : "❌ Access Denied"}\n');

  // Test Case 2: Age below minimum
  print('--- Test Case 2: User with age 16 accessing /data1 ---');
  String user2 = jsonEncode({"age": 16});
  bool result2 = enforcer.enforce([user2, '/data1', 'read']);
  print('User: $user2');
  print('Resource: /data1, Action: read');
  print('Result: ${result2 ? "✅ Access Granted" : "❌ Access Denied"}\n');

  // Test Case 3: Age above maximum
  print('--- Test Case 3: User with age 65 accessing /data1 ---');
  String user3 = jsonEncode({"age": 65});
  bool result3 = enforcer.enforce([user3, '/data1', 'read']);
  print('User: $user3');
  print('Resource: /data1, Action: read');
  print('Result: ${result3 ? "✅ Access Granted" : "❌ Access Denied"}\n');

  // Test Case 4: Admin with sufficient age
  print('--- Test Case 4: Admin with age 25 accessing /admin ---');
  String admin1 = jsonEncode({"role": "admin", "age": 25});
  bool result4 = enforcer.enforce([admin1, '/admin', 'write']);
  print('User: $admin1');
  print('Resource: /admin, Action: write');
  print('Result: ${result4 ? "✅ Access Granted" : "❌ Access Denied"}\n');

  // Test Case 5: Admin with insufficient age
  print('--- Test Case 5: Admin with age 20 accessing /admin ---');
  String admin2 = jsonEncode({"role": "admin", "age": 20});
  bool result5 = enforcer.enforce([admin2, '/admin', 'write']);
  print('User: $admin2');
  print('Resource: /admin, Action: write');
  print('Result: ${result5 ? "✅ Access Granted" : "❌ Access Denied"}\n');

  // Test Case 6: Non-admin user
  print('--- Test Case 6: Regular user accessing /admin ---');
  String user4 = jsonEncode({"role": "user", "age": 25});
  bool result6 = enforcer.enforce([user4, '/admin', 'write']);
  print('User: $user4');
  print('Resource: /admin, Action: write');
  print('Result: ${result6 ? "✅ Access Granted" : "❌ Access Denied"}\n');

  print('=== Example Complete ===');
}
