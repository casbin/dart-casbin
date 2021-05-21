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

import '../rbac/default_role_manager.dart';
import '../rbac/role_manager.dart';

/// Assertion represents an expression in a section of the model.
/// For example: r = sub, obj, act
class Assertion {
  String key;
  String value;
  List<String> tokens;
  List<List<String>> policy;
  RoleManager rm;

  Assertion()
      : key = '',
        value = '',
        tokens = [],
        policy = [],
        rm = DefaultRoleManager(10);

  void buildRoleLinks(RoleManager rm) {
    this.rm = rm;
    var count = 0;

    for (var i = 0; i < value.length; i++) {
      if (value[i] == '_') {
        count++;
      }
    }

    for (var rule in policy) {
      if (count < 2) {
        throw ArgumentError(
            'the number of \"_\" in role definition should be at least 2');
      }

      if (rule.length < count) {
        throw ArgumentError(
            'grouping policy elements do not meet role definition');
      }

      if (count == 2) {
        rm.addLink(rule.elementAt(0), rule.elementAt(1));
      } else if (count == 3) {
        rm.addLink(rule.elementAt(0), rule.elementAt(1), rule.elementAt(2));
      } else if (count == 4) {
        //rm.addLink(rule.elementAt(0), rule.elementAt(1), rule.elementAt(2), rule.elementAt(3));
      }
    }

    // todo(KNawm): Log "Role links for: " + key
    rm.printRoles();
  }
}
