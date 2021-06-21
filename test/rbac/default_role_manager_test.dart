import 'package:casbin/src/rbac/default_role_manager.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';

void main() {
  group('test addLink in DefaultRoleManager', () {
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
  });

  group('test deleteLink in DefaultRoleManager', () {
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

    rm.deleteLink('g1', 'g3');
    rm.deleteLink('u4', 'g2');

    // Current role inheritance tree after deleting the links:
    //             g3    g2
    //               \     \
    //          g1    u4    u3
    //         /  \
    //       u1    u2

    testRole('test 1', rm, 'u1', 'g1', true);
    testRole('test 2', rm, 'u1', 'g2', false);
    testRole('test 3', rm, 'u1', 'g3', false);
    testRole('test 4', rm, 'u2', 'g1', true);
    testRole('test 5', rm, 'u2', 'g2', false);
    testRole('test 6', rm, 'u2', 'g3', false);
    testRole('test 7', rm, 'u3', 'g1', false);
    testRole('test 8', rm, 'u3', 'g2', true);
    testRole('test 9', rm, 'u3', 'g3', false);
    testRole('test 10', rm, 'u4', 'g1', false);
    testRole('test 11', rm, 'u4', 'g2', false);
    testRole('test 12', rm, 'u4', 'g3', true);
  });

  group('test addLink with domain', () {
    var rm = DefaultRoleManager(3);
    rm.addLink('u1', 'g1', ['domain1']);
    rm.addLink('u2', 'g1', ['domain1']);
    rm.addLink('u3', 'admin', ['domain2']);
    rm.addLink('u4', 'admin', ['domain2']);
    rm.addLink('u4', 'admin', ['domain1']);
    rm.addLink('g1', 'admin', ['domain1']);

    // Current role inheritance tree:
    //       domain1:admin    domain2:admin
    //            /       \  /       \
    //      domain1:g1     u4         u3
    //         /  \
    //       u1    u2

    testDomainRole('test 1', rm, 'u1', 'g1', ['domain1'], true);
    testDomainRole('test 2', rm, 'u1', 'g1', ['domain2'], false);
    testDomainRole('test 3', rm, 'u1', 'admin', ['domain1'], true);
    testDomainRole('test 4', rm, 'u1', 'admin', ['domain2'], false);

    testDomainRole('test 5', rm, 'u2', 'g1', ['domain1'], true);
    testDomainRole('test 6', rm, 'u2', 'g1', ['domain2'], false);
    testDomainRole('test 7', rm, 'u2', 'admin', ['domain1'], true);
    testDomainRole('test 8', rm, 'u2', 'admin', ['domain2'], false);

    testDomainRole('test 9', rm, 'u3', 'g1', ['domain1'], false);
    testDomainRole('test 10', rm, 'u3', 'g1', ['domain2'], false);
    testDomainRole('test 11', rm, 'u3', 'admin', ['domain1'], false);
    testDomainRole('test 12', rm, 'u3', 'admin', ['domain2'], true);

    testDomainRole('test 13', rm, 'u4', 'g1', ['domain1'], false);
    testDomainRole('test 14', rm, 'u4', 'g1', ['domain2'], false);
    testDomainRole('test 15', rm, 'u4', 'admin', ['domain1'], true);
    testDomainRole('test 16', rm, 'u4', 'admin', ['domain2'], true);
  });

  group('test deleteLink with domain', () {
    var rm = DefaultRoleManager(3);
    rm.addLink('u1', 'g1', ['domain1']);
    rm.addLink('u2', 'g1', ['domain1']);
    rm.addLink('u3', 'admin', ['domain2']);
    rm.addLink('u4', 'admin', ['domain2']);
    rm.addLink('u4', 'admin', ['domain1']);
    rm.addLink('g1', 'admin', ['domain1']);

    // Current role inheritance tree:
    //       domain1:admin    domain2:admin
    //            /       \  /       \
    //      domain1:g1     u4         u3
    //         /  \
    //       u1    u2

    rm.deleteLink('g1', 'admin', ['domain1']);
    rm.deleteLink('u4', 'admin', ['domain2']);

    // Current role inheritance tree after deleting the links:
    //       domain1:admin    domain2:admin
    //                    \          \
    //      domain1:g1     u4         u3
    //         /  \
    //       u1    u2

    testDomainRole('test 1', rm, 'u1', 'g1', ['domain1'], true);
    testDomainRole('test 2', rm, 'u1', 'g1', ['domain2'], false);
    testDomainRole('test 3', rm, 'u1', 'admin', ['domain1'], false);
    testDomainRole('test 4', rm, 'u1', 'admin', ['domain2'], false);

    testDomainRole('test 5', rm, 'u2', 'g1', ['domain1'], true);
    testDomainRole('test 6', rm, 'u2', 'g1', ['domain2'], false);
    testDomainRole('test 7', rm, 'u2', 'admin', ['domain1'], false);
    testDomainRole('test 8', rm, 'u2', 'admin', ['domain2'], false);

    testDomainRole('test 9', rm, 'u3', 'g1', ['domain1'], false);
    testDomainRole('test 10', rm, 'u3', 'g1', ['domain2'], false);
    testDomainRole('test 11', rm, 'u3', 'admin', ['domain1'], false);
    testDomainRole('test 12', rm, 'u3', 'admin', ['domain2'], true);

    testDomainRole('test 13', rm, 'u4', 'g1', ['domain1'], false);
    testDomainRole('test 14', rm, 'u4', 'g1', ['domain2'], false);
    testDomainRole('test 15', rm, 'u4', 'admin', ['domain1'], true);
    testDomainRole('test 16', rm, 'u4', 'admin', ['domain2'], false);
  });

  group('test clear in DefaultRoleManager', () {
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

    rm.clear();

    testRole('test 1', rm, 'u1', 'g1', false);
    testRole('test 2', rm, 'u1', 'g2', false);
    testRole('test 3', rm, 'u1', 'g3', false);
    testRole('test 4', rm, 'u2', 'g1', false);
    testRole('test 5', rm, 'u2', 'g2', false);
    testRole('test 6', rm, 'u2', 'g3', false);
    testRole('test 7', rm, 'u3', 'g1', false);
    testRole('test 8', rm, 'u3', 'g2', false);
    testRole('test 9', rm, 'u3', 'g3', false);
    testRole('test 10', rm, 'u4', 'g1', false);
    testRole('test 11', rm, 'u4', 'g2', false);
    testRole('test 12', rm, 'u4', 'g3', false);
  });
}
