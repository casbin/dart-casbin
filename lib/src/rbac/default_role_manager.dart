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

import '../log/log_util.dart' as logutil;
import 'domain_roles.dart';
import 'role.dart';
import 'role_manager.dart';

const defaultDomain = 'casbin::default';

class DefaultRoleManager implements RoleManager {
  Map<String, DomainRoles> allDomains;
  int maxHierarchyLevel;
  bool hasPattern;
  bool hasDomainPattern;
  MatchingFunc? matchingFunc;
  MatchingFunc? domainMatchingFunc;

  /// DefaultRoleManager is the constructor for creating an instance of the
  /// default RoleManager implementation.
  ///
  /// [maxHierarchyLevel] the maximized allowed RBAC hierarchy level.
  DefaultRoleManager(
    this.maxHierarchyLevel, [
    this.matchingFunc,
    this.domainMatchingFunc,
  ])  : allDomains = {},
        hasPattern = matchingFunc == null ? false : true,
        hasDomainPattern = domainMatchingFunc == null ? false : true;

  /// Clears all stored data and resets the role manager to the initial state.
  @override
  void clear() {
    allDomains.clear();
    allDomains[defaultDomain] = DomainRoles();
  }

  String domainName([List<String> domain = const []]) {
    return domain.isEmpty ? defaultDomain : domain[0];
  }

  DomainRoles getOrCreateDomainRoles(final String domain) {
    return allDomains.putIfAbsent(domain, () => DomainRoles());
  }

  void addMatchingFunc(dynamic name, MatchingFunc? func) {
    hasPattern = true;

    if (name.runtimeType == String || func != null) {
      matchingFunc = func;
    } else if (name.runtimeType == MatchingFunc) {
      matchingFunc = name;
    } else {
      throw ArgumentError(
          'error: name should be only 1 parameter and it must be either a matching function or a string');
    }
  }

  void addDomainMatchingFunc(MatchingFunc func) {
    hasDomainPattern = true;
    domainMatchingFunc = func;
  }

  Set<String> getPatternMatchedDomainNames(String domain) {
    final patternDomain = {domain};

    if (hasDomainPattern) {
      allDomains.forEach((key, value) {
        if (domainMatchingFunc!(domain, key)) {
          patternDomain.add(key);
        }
      });
    }
    return patternDomain;
  }

  DomainRoles generateTempRoles(String domain) {
    loadOrDefault(allDomains, domain, DomainRoles());

    final allRoles = DomainRoles();
    final patternDomain = getPatternMatchedDomainNames(domain);

    for (var domain in patternDomain) {
      final domainRoles = loadOrDefault(allDomains, domain, DomainRoles());
      for (var entry in domainRoles.roles.entries) {
        final role1 = allRoles.createRole(entry.value.name, matchingFunc);

        for (var element in entry.value.getRoles()) {
          role1.addRole(allRoles.createRole(element, matchingFunc));
        }
      }
    }

    return allRoles;
  }

  /// Adds the inheritance link between role: [name1] and role: [name2].
  ///
  /// aka role: [name1] inherits role: [name2].
  /// [domain] is a prefix to the roles.
  @override
  void addLink(String name1, String name2, [List<String> domain = const []]) {
    if (domain.isEmpty) {
      domain = [defaultDomain];
    } else if (domain.length > 1) {
      throw ArgumentError('error: domain should be only 1 parameter');
    }
    final allRoles = loadOrDefault(allDomains, domain[0], DomainRoles());

    final role1 = loadOrDefault(allRoles.roles, name1, Role(name1));
    final role2 = loadOrDefault(allRoles.roles, name2, Role(name2));

    role1.addRole(role2);
  }

  /// Deletes the inheritance link between role: name1 and role: name2.
  ///
  /// aka role: [name1] does not inherit role: [name2] any more.
  /// [domain] is a prefix to the roles.
  @override
  void deleteLink(String name1, String name2,
      [List<String> domain = const []]) {
    if (domain.isEmpty) {
      domain = [defaultDomain];
    } else if (domain.length > 1) {
      throw ArgumentError('error: domain should be only 1 parameter');
    }

    final allRoles = loadOrDefault(allDomains, domain[0], DomainRoles());

    if (!allRoles.roles.containsKey(name1) &&
        !allRoles.roles.containsKey(name2)) {
      throw ArgumentError('error: both name1 and name2 do not exist');
    } else if (!allRoles.roles.containsKey(name1) ||
        !allRoles.roles.containsKey(name2)) {
      final missingParam =
          (allRoles.roles.containsKey(name1)) ? 'name2' : 'name1';
      throw ArgumentError('error: $missingParam does not exist');
    }

    var role1 = loadOrDefault(allRoles.roles, name1, Role(name1));
    var role2 = loadOrDefault(allRoles.roles, name2, Role(name2));
    role1.deleteRole(role2);
  }

  /// Determines whether role: [name1] inherits role: [name2].
  /// [domain] is a prefix to the roles.
  @override
  bool hasLink(String name1, String name2, [List<String> domain = const []]) {
    if (domain.isEmpty) {
      domain = [defaultDomain];
    } else if (domain.length > 1) {
      throw ArgumentError('error: domain should be only 1 parameter');
    }

    if (name1 == name2) {
      return true;
    }

    var allRoles = DomainRoles();
    if (hasPattern || hasDomainPattern) {
      allRoles = generateTempRoles(domain[0]);
    } else {
      allRoles = loadOrDefault(allDomains, domain[0], DomainRoles());
    }

    if (!allRoles.hasRole(name1, matchingFunc) ||
        !allRoles.hasRole(name2, matchingFunc)) {
      return false;
    }

    final role1 = allRoles.createRole(name1, matchingFunc);
    return role1.hasRole(name2, maxHierarchyLevel);
  }

  /// Returns the roles that a subject inherits.
  /// [domain] is a prefix to the roles.
  @override
  List<String> getRoles(String name, [List<String> domain = const []]) {
    if (domain.isEmpty) {
      domain = [defaultDomain];
    } else if (domain.length > 1) {
      throw ArgumentError('error: domain should be only 1 parameter');
    }

    var allRoles = DomainRoles();

    if (hasPattern || hasDomainPattern) {
      allRoles = generateTempRoles(domain[0]);
    } else {
      allRoles = loadOrDefault(allDomains, domain[0], DomainRoles());
    }

    if (!allRoles.hasRole(name, matchingFunc)) {
      return [];
    }

    return allRoles.createRole(name, matchingFunc).getRoles();
  }

  /// Returns the users that inherits a subject.
  @override
  List<String> getUsers(String name, [List<String> domain = const []]) {
    if (domain.isEmpty) {
      domain = [defaultDomain];
    } else if (domain.length > 1) {
      throw ArgumentError('error: domain should be 1 parameter');
    }

    var allRoles = DomainRoles();
    if (hasPattern || hasDomainPattern) {
      allRoles = generateTempRoles(domain[0]);
    } else {
      allRoles = loadOrDefault(allDomains, domain[0], DomainRoles());
    }

    if (!allRoles.hasRole(name, matchingFunc)) {
      return [];
    }

    return allRoles.roles.values
        .where((e) => e.hasDirectRole(name))
        .map((e) => e.name)
        .toList();
  }

  /// Prints all the roles to log.
  @override
  void printRoles() {
    var logger = logutil.getLogger();
    logger.logRole(allDomains);
  }
}
