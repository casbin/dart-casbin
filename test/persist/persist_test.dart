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

import 'package:casbin/src/model/model.dart';
import 'package:casbin/src/persist/helper.dart';
import 'package:test/test.dart';

void main() {
  group('test Helper.loadPolicyLine', () {
    final m = Model();
    m.loadModelFromText('''

    [request_definition]
    r = sub, obj, act

    [policy_definition]
    p = sub, obj, act

    [policy_effect]
    e = some(where (p.eft == allow))

    [matchers]
    m = r.sub == p.sub && r.obj == p.obj && r.act == p.act

    ''');
    var testdata = [
      'p, admin, /, GET',
      '# test comment 1',
      '  # test comment 2',
      'p,    admin,  /,  POST',
      'p, admin, /,  PUT',
      'p,admin,/, DELETE',
      'p,   admin, / , PATCH',
    ];

    var expectedPolicy = [
      ['admin', '/', 'GET'],
      ['admin', '/', 'POST'],
      ['admin', '/', 'PUT'],
      ['admin', '/', 'DELETE'],
      ['admin', '/', 'PATCH'],
    ];

    testdata.forEach((line) {
      Helper.loadPolicyLine(m, line);
    });

    var ast = m.model['p']?['p'];

    test('test 1', () {
      expect(ast != null, true);
    });
    test('test 2', () {
      expect(ast?.policy.length == expectedPolicy.length, true);
    });

    test('test 3', () {
      expect(ast?.policy, equals(expectedPolicy));
    });
  });
}
