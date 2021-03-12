/// Represents the data structure for a role in RBAC.
class Role {
  String name;
  List<Role> roles;

  Role(this.name) : roles = [];

  void addRole(Role role) {
    for (var r in roles) {
      if (r.name == role.name) {
        return;
      }
    }

    roles.add(role);
  }

  void deleteRole(Role role) {
    for (var r in roles) {
      if (r.name == role.name) {
        roles.remove(r);
      }
    }
  }

  bool hasRole(String name, int hierarchyLevel) {
    if (this.name == name) {
      return true;
    }

    if (hierarchyLevel <= 0) {
      return false;
    }

    for (var role in roles) {
      if (role.hasRole(name, hierarchyLevel - 1)) {
        return true;
      }
    }

    return false;
  }

  bool hasDirectRole(String name) {
    for (var role in roles) {
      if (role.name == name) {
        return true;
      }
    }

    return false;
  }

  @override
  String toString() {
    return name + roles.join(',');
  }

  List<String> getRoles() {
    return roles.map((r) => r.name).toList();
  }
}
