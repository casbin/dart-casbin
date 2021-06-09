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

/// Represents the data structure for a role in RBAC.
class Role {
  String name;
  List<Role> roles;

  Role(this.name) : roles = <Role>[];

  void addRole(Role role) {
    for (var r in roles) {
      if (r.name == role.name) {
        return;
      }
    }

    roles.add(role);
  }

  void deleteRole(Role role) {
    roles.removeWhere((element) => element == role);
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
