import 'package:test/test.dart';

import 'package:casbin/src/enforcer.dart';

import '../utils/test_utils.dart';

void main() {
  final modelPath = 'examples\\basic_model.conf';
  final policyFile = 'examples\\basic_policy.csv';
  group('Test enforcing with basic model', () {
    final e = Enforcer.fromModelPathAndPolicyFile(modelPath, policyFile);

    testEnforce('test 1', e, 'alice', 'data1', 'read', true);
    testEnforce('test 2', e, 'alice', 'data1', 'write', false);
    testEnforce('test 3', e, 'alice', 'data2', 'read', false);
    testEnforce('test 4', e, 'alice', 'data2', 'write', false);
    testEnforce('test 5', e, 'bob', 'data1', 'read', false);
    testEnforce('test 6', e, 'bob', 'data1', 'write', false);
    testEnforce('test 7', e, 'bob', 'data2', 'read', false);
    testEnforce('test 8', e, 'bob', 'data2', 'write', true);
  });

  group('Test enforcing with basic model with no policy', () {
    final e = Enforcer(modelPath);

    testEnforce('test 1', e, 'alice', 'data1', 'read', false);
    testEnforce('test 2', e, 'alice', 'data1', 'write', false);
    testEnforce('test 3', e, 'alice', 'data2', 'read', false);
    testEnforce('test 4', e, 'alice', 'data2', 'write', false);
    testEnforce('test 5', e, 'bob', 'data1', 'read', false);
    testEnforce('test 6', e, 'bob', 'data1', 'write', false);
    testEnforce('test 7', e, 'bob', 'data2', 'read', false);
    testEnforce('test 8', e, 'bob', 'data2', 'write', false);
  });
}
