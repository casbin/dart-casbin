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

import 'package:casbin/src/enforcer.dart';
import 'package:casbin/src/utils/utils.dart' as utils;
import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  var e = Enforcer(
      'casbin_examples/rbac_model.conf', 'casbin_examples/rbac_policy.csv');

  test('test getAllSubjects', () {
    var allSubjects = e.getAllSubjects();

    expect(
      ListEquality().equals(allSubjects, ['alice', 'bob', 'data2_admin']),
      true,
    );
  });

  test('test getAllNamedSubjects', () {
    var allSubjects = e.getAllNamedSubjects('p');

    expect(
      ListEquality().equals(allSubjects, ['alice', 'bob', 'data2_admin']),
      true,
    );
  });

  test('test getAllObjects', () {
    var allObjects = e.getAllObjects();

    expect(
      ListEquality().equals(allObjects, ['data1', 'data2']),
      true,
    );
  });

  group('test getAllNamedObjects', () {
    test('for p', () {
      var allObjects = e.getAllNamedObjects('p');

      expect(
        ListEquality().equals(allObjects, ['data1', 'data2']),
        true,
      );
    });

    test('non existent p1', () {
      var allObjects = e.getAllNamedObjects('p1');

      expect(
        ListEquality().equals(allObjects, []),
        true,
      );
    });
  });

  test('test getAllActions', () {
    var allObjects = e.getAllActions();

    expect(
      ListEquality().equals(allObjects, ['read', 'write']),
      true,
    );
  });

  group('test getAllNamedActions', () {
    test('for p', () {
      var allObjects = e.getAllNamedActions('p');

      expect(
        ListEquality().equals(allObjects, ['read', 'write']),
        true,
      );
    });

    test('non existent p1', () {
      var allObjects = e.getAllNamedActions('p1');

      expect(
        ListEquality().equals(allObjects, []),
        true,
      );
    });
  });

  test('test getPolicy', () {
    var policy = e.getPolicy();

    expect(
      utils.array2DEquals(
        policy,
        [
          ['alice', 'data1', 'read'],
          ['bob', 'data2', 'write'],
          ['data2_admin', 'data2', 'read'],
          ['data2_admin', 'data2', 'write'],
        ],
      ),
      true,
    );
  });

  group('test getFilteredPolicy', () {
    test('for alice', () {
      var policy = e.getFilteredPolicy(0, ['alice']);

      expect(
        utils.array2DEquals(
          policy,
          [
            ['alice', 'data1', 'read'],
          ],
        ),
        true,
      );
    });

    test('for bob', () {
      var policy = e.getFilteredPolicy(0, ['bob']);

      expect(
        utils.array2DEquals(
          policy,
          [
            ['bob', 'data2', 'write'],
          ],
        ),
        true,
      );
    });
  });

  group('getNamedPolicy', () {
    test('for p', () {
      var namedPolicy = e.getNamedPolicy('p');
      expect(
          utils.array2DEquals(namedPolicy, [
            ['alice', 'data1', 'read'],
            ['bob', 'data2', 'write'],
            ['data2_admin', 'data2', 'read'],
            ['data2_admin', 'data2', 'write'],
          ]),
          true);
    });
  });

  test('test getFilteredNamedPolicy', () {
    var namedPolicy = e.getFilteredNamedPolicy('p', 0, ['bob']);
    expect(
        utils.array2DEquals(namedPolicy, [
          ['bob', 'data2', 'write'],
        ]),
        true);
  });
}
