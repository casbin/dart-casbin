import 'package:casbin/src/rbac/default_role_manager.dart';

import '../utils/test_utils.dart';

void main() {
  var rm = DefaultRoleManager(3);
  rm.addLink('u1', 'g1');
  rm.addLink('u2', 'g1');
  rm.addLink('u3', 'g2');
  rm.addLink('u4', 'g2');
  rm.addLink('u4', 'g3');
  rm.addLink('g1', 'g3');

  // Current role inheritance tree:
  //             g3    g2
  //            /  \  /  \
  //          g1    u4    u3
  //         /  \
  //       u1    u2

  testRole('test 1', rm, 'u1', 'g1', true);
  testRole('test 2', rm, 'u1', 'g2', false);
  testRole('test 3', rm, 'u1', 'g3', true);
  testRole('test 4', rm, 'u2', 'g1', true);
  testRole('test 5', rm, 'u2', 'g2', false);
  testRole('test 6', rm, 'u2', 'g3', true);
  testRole('test 7', rm, 'u3', 'g1', false);
  testRole('test 8', rm, 'u3', 'g2', true);
  testRole('test 9', rm, 'u3', 'g3', false);
  testRole('test 10', rm, 'u4', 'g1', false);
  testRole('test 11', rm, 'u4', 'g2', true);
  testRole('test 12', rm, 'u4', 'g3', true);
}
