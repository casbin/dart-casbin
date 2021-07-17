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
import 'package:casbin/src/utils/builtin_operators.dart';
import 'package:casbin/src/utils/utils.dart' as utils;
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

void testGetPolicy(
  String title,
  Enforcer e,
  List<List<String>> res,
  bool r,
) {
  var myRes = e.getPolicy();

  test(title, () {
    expect(utils.array2DEquals(myRes, res), equals(r));
  });
}

void testRegexMatch(
  String title,
  String key1,
  String key2,
  bool res,
) {
  test(title, () {
    expect(regexMatch(key1, key2), res);
  });
}

void testKeyMatch(
  String title,
  String key1,
  String key2,
  bool res,
) {
  test(title, () {
    expect(keyMatch(key1, key2), res);
  });
}

void testKeyMatch2(
  String title,
  String key1,
  String key2,
  bool res,
) {
  test(title, () {
    expect(keyMatch2(key1, key2), res);
  });
}

void testKeyMatch3(
  String title,
  String key1,
  String key2,
  bool res,
) {
  test(title, () {
    expect(keyMatch3(key1, key2), res);
  });
}

void testKeyMatch4(
  String title,
  String key1,
  String key2,
  bool res,
) {
  test(title, () {
    expect(keyMatch4(key1, key2), res);
  });
}

void testKeyGet(
  String title,
  String key1,
  String key2,
  String res,
) {
  test(title, () {
    expect(keyGetFunc(key1, key2), equals(res));
  });
}

void testKeyGet2(
  String title,
  String key1,
  String key2,
  String pathVar,
  String res,
) {
  test(title, () {
    expect(keyGet2Func(key1, key2, pathVar), equals(res));
  });
}

void testAllMatch(
  String title,
  String key1,
  String key2,
  bool res,
) {
  test(title, () {
    expect(allMatch(key1, key2), equals(res));
  });
}

void testGlobMatch(
  String title,
  String key1,
  String key2,
  bool res,
) {
  test(title, () {
    expect(globMatch(key1, key2), equals(res));
  });
}
