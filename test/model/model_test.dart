import 'package:test/test.dart';

import 'package:casbin/src/enforcer.dart';

import '../utils/test_utils.dart';

void main() {
  final basicModelPath = 'examples/basic_model.conf';
  final basicPolicyFile = 'examples/basic_policy.csv';
  final rbacModelPath = 'examples/rbac_model.conf';
  final rbacPolicyFile = 'examples/rbac_policy.csv';
  final rbacWithResourcesModel = 'examples/rbac_with_resource_roles_model.conf';
  final rbacWithResourcesPolicy =
      'examples/rbac_with_resource_roles_policy.csv';
  final rbacWithDomainsModel = 'examples/rbac_with_domains_model.conf';
  final rbacWithDomainsPolicy = 'examples/rbac_with_domains_policy.csv';
  final rbacWithDenyModel = 'examples/rbac_with_deny_model.conf';
  final rbacWithDenyPolicy = 'examples/rbac_with_deny_policy.csv';

  final rbacWithNotDenyModel = 'examples/rbac_with_not_deny_model.conf';

  group('Test enforcing with basic model', () {
    final e =
        Enforcer.fromModelPathAndPolicyFile(basicModelPath, basicPolicyFile);

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
    final e = Enforcer(basicModelPath);

    testEnforce('test 1', e, 'alice', 'data1', 'read', false);
    testEnforce('test 2', e, 'alice', 'data1', 'write', false);
    testEnforce('test 3', e, 'alice', 'data2', 'read', false);
    testEnforce('test 4', e, 'alice', 'data2', 'write', false);
    testEnforce('test 5', e, 'bob', 'data1', 'read', false);
    testEnforce('test 6', e, 'bob', 'data1', 'write', false);
    testEnforce('test 7', e, 'bob', 'data2', 'read', false);
    testEnforce('test 8', e, 'bob', 'data2', 'write', false);
  });

  group('Test enforcing with rbac model', () {
    final e = Enforcer(rbacModelPath, rbacPolicyFile);

    testEnforce('test 1', e, 'alice', 'data1', 'read', true);
    testEnforce('test 2', e, 'alice', 'data1', 'write', false);
    testEnforce('test 3', e, 'alice', 'data2', 'read', true);
    testEnforce('test 4', e, 'alice', 'data2', 'write', true);
    testEnforce('test 5', e, 'bob', 'data1', 'read', false);
    testEnforce('test 6', e, 'bob', 'data1', 'write', false);
    testEnforce('test 7', e, 'bob', 'data2', 'read', false);
    testEnforce('test 8', e, 'bob', 'data2', 'write', true);
  });

  group('Test enforcing with rbac model with Resource Roles', () {
    final e = Enforcer(rbacWithResourcesModel, rbacWithResourcesPolicy);

    testEnforce('test 1', e, 'alice', 'data1', 'read', true);
    testEnforce('test 2', e, 'alice', 'data1', 'write', true);
    testEnforce('test 3', e, 'alice', 'data2', 'read', false);
    testEnforce('test 4', e, 'alice', 'data2', 'write', true);
    testEnforce('test 5', e, 'bob', 'data1', 'read', false);
    testEnforce('test 6', e, 'bob', 'data1', 'write', false);
    testEnforce('test 7', e, 'bob', 'data2', 'read', false);
    testEnforce('test 8', e, 'bob', 'data2', 'write', true);
  });

  group('Test enforcing with rbac model with Domains', () {
    final e = Enforcer(rbacWithDomainsModel, rbacWithDomainsPolicy);

    testDomainEnforce('test 1', e, 'alice', 'domain1', 'data1', 'read', true);
    testDomainEnforce('test 2', e, 'alice', 'domain1', 'data1', 'write', true);
    testDomainEnforce('test 3', e, 'alice', 'domain1', 'data2', 'read', false);
    testDomainEnforce('test 4', e, 'alice', 'domain1', 'data2', 'write', false);
    testDomainEnforce('test 5', e, 'bob', 'domain2', 'data1', 'read', false);
    testDomainEnforce('test 6', e, 'bob', 'domain2', 'data1', 'write', false);
    testDomainEnforce('test 7', e, 'bob', 'domain2', 'data2', 'read', true);
    testDomainEnforce('test 8', e, 'bob', 'domain2', 'data2', 'write', true);
  });

  group('Test enforcing with rbac model with deny', () {
    final e = Enforcer(rbacWithDenyModel, rbacWithDenyPolicy);

    testEnforce('test 1', e, 'alice', 'data1', 'read', true);
    testEnforce('test 2', e, 'alice', 'data1', 'write', false);
    testEnforce('test 3', e, 'alice', 'data2', 'read', true);
    testEnforce('test 4', e, 'alice', 'data2', 'write', false);
    testEnforce('test 5', e, 'bob', 'data1', 'read', false);
    testEnforce('test 6', e, 'bob', 'data1', 'write', false);
    testEnforce('test 7', e, 'bob', 'data2', 'read', false);
    testEnforce('test 8', e, 'bob', 'data2', 'write', true);
  });

  group('Test enforcing with rbac model with deny', () {
    final e = Enforcer(rbacWithNotDenyModel, rbacWithDenyPolicy);

    testEnforce('test 1', e, 'bob', 'data2', 'false', true);
  });
}
