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

abstract class RoleManager {
  /// Clears all stored data and resets the role manager to the initial state.
  void clear();

  /// Adds the inheritance link between two roles. role: name1 and role: name2.
  /// domain is a prefix to the roles.
  ///
  /// [name1] is the first role (or user).
  /// [name2] is the second role.
  /// [domain] is the domain the roles belong to.
  void addLink(String name1, String name2, [List<String> domain = const []]);

  /// Delete the inheritance link between two roles. role: name1 and role: name2.
  /// domain is a prefix to the roles.
  ///
  /// [name1] is the first role (or user).
  /// [name2] is the second role.
  /// [domain] is the domain the roles belong to.
  void deleteLink(String name1, String name2, [List<String> domain = const []]);

  /// Returns whether a link exists between two roles. role: name1 inherits role: name2.
  /// domain is a prefix to the roles.
  ///
  /// [name1] is the first role (or a user).
  /// [name2] is the second role.
  /// [domain] is the domain the roles belong to.
  bool hasLink(String name1, String name2, [List<String> domain = const []]);

  /// Returns the roles that a user inherits.
  /// domain is a prefix to the roles.
  ///
  /// [name] is the user (or a role).
  /// [domain] is the domain the roles belong to.
  List<String> getRoles(String name, [List<String> domain = const []]);

  /// Returns the users that inherits a role.
  ///
  /// [name] is the role.
  List<String> getUsers(String name, [List<String> domain = const []]);

  /// Prints all the roles to log.
  void printRoles();
}
