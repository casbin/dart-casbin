import 'package:casbin/src/rbac/role.dart';
import 'package:casbin/src/rbac/role_manager.dart';

class DefaultRoleManager implements RoleManager {
  Map<String, Role> allRoles;
  int maxHierarchyLevel;

  /// DefaultRoleManager is the constructor for creating an instance of the
  /// default RoleManager implementation.
  ///
  /// [maxHierarchyLevel] the maximized allowed RBAC hierarchy level.
  DefaultRoleManager(int maxHierarchyLevel) {
    this.maxHierarchyLevel = maxHierarchyLevel ?? 10;
    allRoles = {};
  }

  bool hasRole(String name) {
    return allRoles.containsKey(name);
  }

  Role createRole(String name) {
    return allRoles.putIfAbsent(name, () => Role(name));
  }

  /// Clears all stored data and resets the role manager to the initial state.
  @override
  void clear() {
    allRoles.clear();
  }

  /// Adds the inheritance link between role: [name1] and role: [name2].
  ///
  /// aka role: [name1] inherits role: [name2].
  /// [domain] is a prefix to the roles.
  @override
  void addLink(String name1, String name2, [String domain]) {
    if (domain != null) {
      name1 = domain + '::' + name1;
      name2 = domain + '::' + name2;
    }

    var role1 = createRole(name1);
    var role2 = createRole(name2);
    role1.addRole(role2);
  }

  /// Deletes the inheritance link between role: name1 and role: name2.
  ///
  /// aka role: [name1] does not inherit role: [name2] any more.
  /// [domain] is a prefix to the roles.
  @override
  void deleteLink(String name1, String name2, [String domain]) {
    if (domain != null) {
      name1 = domain + '::' + name1;
      name2 = domain + '::' + name2;
    }

    if (!hasRole(name1) || !hasRole(name2)) {
      throw ArgumentError('error: name1 or name2 does not exist');
    }

    var role1 = createRole(name1);
    var role2 = createRole(name2);
    role1.deleteRole(role2);
  }

  /// Determines whether role: [name1] inherits role: [name2].
  /// [domain] is a prefix to the roles.
  @override
  bool hasLink(String name1, String name2, [String domain]) {
    if (domain != null) {
      name1 = domain + '::' + name1;
      name2 = domain + '::' + name2;
    }

    if (name1 == name2) {
      return true;
    }

    if (!hasRole(name1) || !hasRole(name2)) {
      return false;
    }

    final role1 = createRole(name1);
    return role1.hasRole(name2, maxHierarchyLevel);
  }

  /// Returns the roles that a subject inherits.
  /// [domain] is a prefix to the roles.
  @override
  List<String> getRoles(String name, [String domain]) {
    if (domain != null) {
      name = domain + '::' + name;
    }

    if (!hasRole(name)) {
      throw ArgumentError('error: name does not exist');
    }

    final roles = createRole(name).getRoles();

    for (var i = 0; i < roles.length; i++) {
      roles[i] = roles.elementAt(i).substring(domain.length + 2);
    }

    return roles;
  }

  /// Returns the users that inherits a subject.
  @override
  List<String> getUsers(String name) {
    if (!hasRole(name)) {
      throw ArgumentError('error: name does not exist');
    }

    var names;
    for (var role in allRoles.values) {
      if (role.hasDirectRole(name)) {
        names.add(role.name);
      }
    }

    return names;
  }

  /// Prints all the roles to log.
  @override
  void printRoles() {
    for (var role in allRoles.values) {
      // todo(KNawm): Print role.toString() to logger
    }
  }
}
