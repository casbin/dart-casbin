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
import 'package:casbin/src/log/default_logger.dart';
import 'package:casbin/src/model/model.dart';
import 'package:casbin/src/rbac/default_role_manager.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';

void main() {
  group('test enableLog', () {
    test('default enabled value must be false', () {
      final logger = DefaultLogger();

      expect(logger.isEnabled(), false);
    });

    test('set enable to true', () {
      final logger = DefaultLogger();
      logger.enableLog(true);

      expect(logger.isEnabled(), true);
    });

    test('set enable to false', () {
      final logger = DefaultLogger();
      logger.enableLog(false);

      expect(logger.isEnabled(), false);
    });
  });
  group('test logging functionalities', () {
    final logger = DefaultLogger();
    logger.enableLog(true);

    test('test logPrint', () {
      expect(() => logger.logPrint('hello'), prints('hello\n'));
    });

    group('test logModel', () {
      final model = Model();
      model.addDef('r', 'r', 'sub, obj, act');
      model.addDef('p', 'p', 'sub, obj, act');
      model.addDef('e', 'e', 'some(where (p.eft == allow))');
      model.addDef('m', 'm',
          'r.sub == p.sub && keyMatch(r.obj, p.obj) && regexMatch(r.act, p.act)');

      testLogModel('test 1', logger, model, 'Model:');
      testLogModel(
          'test 2', logger, model, 'e.e: some(where (p_eft == allow))');
      testLogModel('test 3', logger, model, 'p.p: sub, obj, act');
      testLogModel('test 4', logger, model, 'r.r: sub, obj, act');
      testLogModel('test 5', logger, model,
          'm.m: r_sub == p_sub && keyMatch(r_obj, p_obj) && regexMatch(r_act, p_act)');
    });
    group('test logPolicy', () {
      final enf = Enforcer.initWithFile(
        'casbin_examples/basic_model.conf',
        'casbin_examples/basic_policy.csv',
      );

      testLogPolicy('test 1', logger, enf.model, 'Policy:');
      testLogPolicy('test 2', logger, enf.model, 'p: sub, obj, act:');
      testLogPolicy('test 3', logger, enf.model, '[alice, data1, read]');
      testLogPolicy('test 4', logger, enf.model, '[bob, data2, write]');
    });

    group('test logRole', () {
      final enf = Enforcer.initWithFile(
        'casbin_examples/rbac_with_domains_model.conf',
        'casbin_examples/rbac_with_domains_policy.csv',
      );
      final rm = enf.rm as DefaultRoleManager;

      testLogRole('test 1', logger, rm, 'Roles:');
      testLogRole('test 2', logger, rm, 'alice < [admin]');
      testLogRole('test 3', logger, rm, 'admin < []');
      testLogRole('test 4', logger, rm, 'bob < [admin]');
      testLogRole('test 5', logger, rm, 'admin < []');
    });
  });
}
