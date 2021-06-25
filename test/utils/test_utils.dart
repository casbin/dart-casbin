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
