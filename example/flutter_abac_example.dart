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

/// This example demonstrates how to use ABAC with JSON strings in Flutter.
/// 
/// This approach allows you to pass user attributes directly as JSON without
/// creating custom classes, making it ideal for Flutter applications that
/// receive user data from APIs or other sources.
///
/// To use this in a Flutter app:
/// 1. Add casbin to your pubspec.yaml: `casbin: ^0.1.0`
/// 2. Import this code into your Flutter widget
/// 3. Call the checkAccess() method when you need to verify permissions
///
/// Example Flutter widget code:
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:casbin/casbin.dart';
/// import 'dart:convert';
///
/// class ABACScreen extends StatefulWidget {
///   @override
///   _ABACScreenState createState() => _ABACScreenState();
/// }
///
/// class _ABACScreenState extends State<ABACScreen> {
///   final TextEditingController ageController = TextEditingController();
///   String resultMessage = "";
///
///   Future<void> checkAccess() async {
///     int? age = int.tryParse(ageController.text);
///     if (age == null) {
///       setState(() {
///         resultMessage = "❌ Please enter a valid age.";
///       });
///       return;
///     }
///
///     // Create model
///     final model = Model()..loadModelFromText(getModel());
///     final enforcer = Enforcer.initWithModelAndAdapter(model);
///
///     // Add policy
///     enforcer.addPolicy([
///       '{"age": 18}',
///       '/data1',
///       'read',
///       'r.sub.age >= 18 && r.sub.age < 60'
///     ]);
///
///     try {
///       // Create JSON string with user attributes
///       String subJson = jsonEncode({"age": age});
///       
///       // Enforce the policy
///       bool result = enforcer.enforce([subJson, '/data1', 'read']);
///
///       setState(() {
///         resultMessage = result ? "✅ Access Granted" : "❌ Access Denied";
///       });
///     } catch (e) {
///       debugPrint("⚠️ Error: $e");
///       setState(() {
///         resultMessage = "⚠️ Error: ${e.toString()}";
///       });
///     }
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: Text("Casbin ABAC Demo")),
///       body: Padding(
///         padding: EdgeInsets.all(20),
///         child: Column(
///           mainAxisAlignment: MainAxisAlignment.center,
///           children: [
///             TextField(
///               controller: ageController,
///               keyboardType: TextInputType.number,
///               decoration: InputDecoration(
///                 labelText: "Age",
///                 border: OutlineInputBorder()
///               ),
///             ),
///             SizedBox(height: 20),
///             ElevatedButton(
///               onPressed: checkAccess,
///               child: Text("Check Access"),
///             ),
///             SizedBox(height: 20),
///             SelectableText(
///               resultMessage,
///               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
///             ),
///           ],
///         ),
///       ),
///     );
///   }
/// }
///
/// String getModel() {
///   return '''
/// [request_definition]
/// r = sub, obj, act
/// 
/// [policy_definition]
/// p = sub, obj, act, condition
/// 
/// [policy_effect]
/// e = some(where (p.eft == allow))
/// 
/// [matchers]
/// m = eval(p.condition) && r.obj == p.obj && r.act == p.act
/// ''';
/// }
/// ```
///
/// Key points:
/// - Use jsonEncode() to convert Dart maps to JSON strings
/// - Pass the JSON string directly to enforcer.enforce()
/// - The JSON attributes (like "age") can be accessed in policy conditions using dot notation (r.sub.age)
/// - No need to create custom classes that implement AbacClass
///
library abac_flutter_example;

import 'package:casbin/casbin.dart';
import 'dart:convert';

/// Simulates a Flutter app's access control check
void simulateFlutterAccessCheck(int userAge, String resource, String action) {
  print('\n--- Simulating Flutter Access Check ---');
  print('User Age: $userAge');
  print('Resource: $resource');
  print('Action: $action');

  // Create the model
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

  // Create enforcer
  final enforcer = Enforcer.initWithModelAndAdapter(model);

  // Add policy (this would typically come from a database or config file)
  enforcer.addPolicy([
    '{"age": 18}',
    '/data1',
    'read',
    'r.sub.age >= 18 && r.sub.age < 60'
  ]);

  // Create JSON string from user attributes
  // In a real Flutter app, this data might come from an API response
  String subJson = jsonEncode({"age": userAge});

  // Check access
  try {
    bool hasAccess = enforcer.enforce([subJson, resource, action]);
    print('Result: ${hasAccess ? "✅ Access Granted" : "❌ Access Denied"}');
  } catch (e) {
    print('⚠️ Error: $e');
  }
}

/// Example with multiple user attributes
void simulateComplexFlutterAccessCheck(
  String userName,
  int userAge,
  String userRole,
  String resource,
  String action,
) {
  print('\n--- Simulating Complex Flutter Access Check ---');
  print('User: $userName');
  print('Age: $userAge');
  print('Role: $userRole');
  print('Resource: $resource');
  print('Action: $action');

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

  // Add policies with multiple attribute conditions
  enforcer.addPolicy([
    '{"name": "user", "age": 18, "role": "user"}',
    '/admin',
    'write',
    'r.sub.role == "admin" && r.sub.age >= 21'
  ]);

  enforcer.addPolicy([
    '{"name": "user", "age": 18, "role": "user"}',
    '/data',
    'read',
    'r.sub.age >= 18'
  ]);

  // In a Flutter app, this data typically comes from user authentication
  String subJson = jsonEncode({
    "name": userName,
    "age": userAge,
    "role": userRole,
  });

  try {
    bool hasAccess = enforcer.enforce([subJson, resource, action]);
    print('Result: ${hasAccess ? "✅ Access Granted" : "❌ Access Denied"}');
  } catch (e) {
    print('⚠️ Error: $e');
  }
}

void main() {
  print('=== Flutter ABAC Examples with JSON Strings ===');

  // Simple examples
  simulateFlutterAccessCheck(25, '/data1', 'read');
  simulateFlutterAccessCheck(16, '/data1', 'read');
  simulateFlutterAccessCheck(65, '/data1', 'read');

  // Complex examples with multiple attributes
  simulateComplexFlutterAccessCheck('Alice', 25, 'admin', '/admin', 'write');
  simulateComplexFlutterAccessCheck('Bob', 20, 'admin', '/admin', 'write');
  simulateComplexFlutterAccessCheck('Charlie', 25, 'user', '/admin', 'write');
  simulateComplexFlutterAccessCheck('David', 19, 'user', '/data', 'read');

  print('\n=== Examples Complete ===');
  print('\nNote: This demonstrates the same functionality described in the GitHub issue.');
  print('Users can now pass JSON strings directly to Casbin without creating custom classes!');
}
