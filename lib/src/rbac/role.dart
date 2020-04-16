/// Represents the data structure for a role in RBAC.
class Role {
  String name;
  List<Role> roles;

  Role(String name) {
    this.name = name;
  }

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
    Role role;
    String names;

    for (var i = 0; i < roles.length; i++) {
      role = roles.elementAt(i);
      if (i == 0) {
        names = role.name;
      } else {
        name += ', ' + role.name;
      }
    }

    return name + ' < ' + names;
  }

  List<String> getRoles() {
    List<String> names;

    for (var role in roles) {
      names.add(role.name);
    }

    return names;
  }
}
