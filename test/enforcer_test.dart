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

import 'package:test/test.dart';

import 'package:casbin/casbin.dart';
import 'package:casbin/src/model/model.dart';
import 'package:casbin/src/persist/file_adapter.dart';

import 'utils/test_utils.dart';

void main() {
  group('test enable enforce with false', () {
    var e = Enforcer('examples/basic_model.conf', 'examples/basic_policy.csv');

    e.enableEnforce(false);

    testEnforce('test 1', e, 'alice', 'data1', 'read', true);
    testEnforce('test 2', e, 'alice', 'data1', 'write', true);
    testEnforce('test 3', e, 'alice', 'data2', 'read', true);
    testEnforce('test 4', e, 'alice', 'data2', 'write', true);
    testEnforce('test 5', e, 'bob', 'data1', 'read', true);
    testEnforce('test 6', e, 'bob', 'data1', 'write', true);
    testEnforce('test 7', e, 'bob', 'data2', 'read', true);
    testEnforce('test 8', e, 'bob', 'data2', 'write', true);
  });

  group('test enable enforce with true', () {
    var e = Enforcer('examples/basic_model.conf', 'examples/basic_policy.csv');

    e.enableEnforce(true);

    testEnforce('test 1', e, 'alice', 'data1', 'read', true);
    testEnforce('test 2', e, 'alice', 'data1', 'write', false);
    testEnforce('test 3', e, 'alice', 'data2', 'read', false);
    testEnforce('test 4', e, 'alice', 'data2', 'write', false);
    testEnforce('test 5', e, 'bob', 'data1', 'read', false);
    testEnforce('test 6', e, 'bob', 'data1', 'write', false);
    testEnforce('test 7', e, 'bob', 'data2', 'read', false);
    testEnforce('test 8', e, 'bob', 'data2', 'write', true);
  });

  group('test enforcer initialization with adapter', () {
    var adapter = FileAdapter('examples/basic_policy.csv');
    var e =
        Enforcer.fromModelPathAndAdapter('examples/basic_model.conf', adapter);

    testEnforce('test 1', e, 'alice', 'data1', 'read', true);
    testEnforce('test 2', e, 'alice', 'data1', 'write', false);
    testEnforce('test 3', e, 'alice', 'data2', 'read', false);
    testEnforce('test 4', e, 'alice', 'data2', 'write', false);
    testEnforce('test 5', e, 'bob', 'data1', 'read', false);
    testEnforce('test 6', e, 'bob', 'data1', 'write', false);
    testEnforce('test 7', e, 'bob', 'data2', 'read', false);
    testEnforce('test 8', e, 'bob', 'data2', 'write', true);
  });

  group('test getModel and setModel', () {
    group('before setting model', () {
      var e =
          Enforcer('examples/basic_model.conf', 'examples/basic_policy.csv');
      // var e2 = Enforcer(
      //     'examples/basic_with_root_model.conf', 'examples/basic_policy.csv');

      testEnforce(
          'test before setting Model', e, 'root', 'data1', 'read', false);
    });

    group('after setting model', () {
      var e =
          Enforcer('examples/basic_model.conf', 'examples/basic_policy.csv');
      var e2 = Enforcer(
          'examples/basic_with_root_model.conf', 'examples/basic_policy.csv');
      e.setModel(e2.getModel());

      testEnforce('test after setting Model', e, 'root', 'data1', 'read', true);
    });
  });

  group('test getAdapter and setAdapter', () {
    group('before setting adapter', () {
      var e =
          Enforcer('examples/basic_model.conf', 'examples/basic_policy.csv');
      // var e2 = Enforcer(
      //     'examples/basic_model.conf', 'examples/basic_inverse_policy.csv');

      testEnforce('test 1', e, 'alice', 'data1', 'read', true);
      testEnforce('test 2', e, 'alice', 'data1', 'write', false);
    });

    group('after setting adapter', () {
      var e =
          Enforcer('examples/basic_model.conf', 'examples/basic_policy.csv');
      var e2 = Enforcer(
          'examples/basic_model.conf', 'examples/basic_inverse_policy.csv');
      var a2 = e2.getAdapter();
      e.setAdapter(a2);
      e.loadPolicy();

      testEnforce('test 1', e, 'alice', 'data1', 'read', false);
      testEnforce('test 2', e, 'alice', 'data1', 'write', true);
    });
  });

  group('test setAdapter from file', () {
    var e = Enforcer('examples/basic_model.conf');

    var a = FileAdapter('examples/basic_policy.csv');
    e.setAdapter(a);
    e.loadPolicy();

    testEnforce('test 1', e, 'alice', 'data1', 'read', true);
  });

  group('test enforce param validation', () {
    var e = Enforcer('examples/rbac_model.conf');
    test('must return false as there are 4 params instead of 3', () {
      assert(
          e.validateEnforce(['alice', 'data1', 'read', 'extra param']), false);
    });

    test('must return true', () {
      assert(e.validateEnforce(['alice', 'data1', 'read']), true);
    });
  });

  group('test RBAC Model In Memory Indeterminate', () {
    var m = Model();
    m.addDef('r', 'r', 'sub, obj, act');
    m.addDef('p', 'p', 'sub, obj, act');
    m.addDef('g', 'g', '_, _');
    m.addDef('e', 'e', 'some(where (p.eft == allow))');
    m.addDef('m', 'm', 'g(r.sub, p.sub) && r.obj == p.obj && r.act == p.act');

    var e = Enforcer.fromModelAndAdapter(m);

    e.addPermissionForUser('alice', ['data1', 'invalid']);

    testEnforce('test 1', e, 'alice', 'data1', 'read', false);
  });

  group('test RBAC Model In Memory', () {
    var m = Model();
    m.addDef('r', 'r', 'sub, obj, act');
    m.addDef('p', 'p', 'sub, obj, act');
    m.addDef('g', 'g', '_, _');
    m.addDef('e', 'e', 'some(where (p.eft == allow))');
    m.addDef('m', 'm', 'g(r.sub, p.sub) && r.obj == p.obj && r.act == p.act');

    var e = Enforcer.fromModelAndAdapter(m);

    e.addPermissionForUser('alice', ['data1', 'read']);
    e.addPermissionForUser('bob', ['data2', 'write']);
    e.addPermissionForUser('data2_admin', ['data2', 'read']);
    e.addPermissionForUser('data2_admin', ['data2', 'write']);
    // e.addRoleForUser('alice', 'data2_admin');

    testEnforce('test 1', e, 'alice', 'data1', 'read', true);
    testEnforce('test 2', e, 'alice', 'data1', 'write', false);
    testEnforce('test 3', e, 'alice', 'data2', 'read', false);
    testEnforce('test 4', e, 'alice', 'data2', 'write', false);
    testEnforce('test 5', e, 'bob', 'data1', 'read', false);
    testEnforce('test 6', e, 'bob', 'data1', 'write', false);
    testEnforce('test 7', e, 'bob', 'data2', 'read', false);
    testEnforce('test 8', e, 'bob', 'data2', 'write', true);
  });
}
