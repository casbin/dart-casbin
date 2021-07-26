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

import 'exception/casbin_name_unexistent.dart';
import 'management_enforcer.dart';
import 'model/function_map.dart';
import 'model/model.dart';
import 'persist/adapter.dart';
import 'persist/file_adapter.dart';

class Enforcer extends ManagementEnforcer {
  /// Initializes an enforcer.
  ///
  /// [model] is a model or the path of the model file.
  /// [policyFile] is the path of the policy file.
  /// [adapter] is the adapter.
  /// [enableLog] whether to enable Casbin's log.
  Enforcer([
    String modelPath = '',
    String policyFile = '',
  ]) {
    adapter = FileAdapter(policyFile);

    this.modelPath = modelPath;
    final model = Model();

    if (modelPath.isNotEmpty) model.loadModel(modelPath);

    this.model = model;
    fm = FunctionMap.loadFunctionMap();
    loadPolicy();
  }

  Enforcer._();

  factory Enforcer.fromModelPathAndPolicyFile(
    String modelPath,
    String policyFile,
  ) {
    final fileAdapter = FileAdapter(policyFile);
    return Enforcer.fromModelPathAndAdapter(modelPath, fileAdapter);
  }

  factory Enforcer.fromModelPathAndAdapter(
    String modelPath,
    Adapter adapter,
  ) {
    final model = Model();
    model.loadModel(modelPath);
    final enf = Enforcer.fromModelAndAdapter(model, adapter);
    enf.modelPath = modelPath;
    return enf;
  }

  factory Enforcer.fromModelAndAdapter(Model model, [Adapter? adapter]) {
    final _enforcer = Enforcer._();
    _enforcer.model = model;
    _enforcer.fm = FunctionMap.loadFunctionMap();

    if (adapter != null) {
      _enforcer.adapter = adapter;
      _enforcer.loadPolicy();
    }

    return _enforcer;
  }

  /// getRolesForUser gets the roles that a user has.
  ///
  /// [name] the user.
  /// return the roles that the user has.
  List<String> getRolesForUser(String name) {
    try {
      return model.model['g']!['g']!.rm.getRoles(name);
    } catch (e) {
      if (e.toString() == 'Null check operator used on a null value') {
        throw FormatException("model does not contain 'g' section");
      } else {
        rethrow;
      }
    }
  }

  /// getUsersForRole gets the users that has a role.
  ///
  /// [name] the role.
  /// return the users that has the role.
  List<String> getUsersForRole(String name) {
    try {
      return model.model['g']!['g']!.rm.getUsers(name);
    } catch (e) {
      if (e.toString() == 'Null check operator used on a null value') {
        throw FormatException("model does not contain 'g' section");
      } else {
        rethrow;
      }
    }
  }

  /// hasRoleForUser determines whether a user has a role.
  ///
  /// [name] the user.
  /// [role] the role.
  /// return whether the user has the role.
  bool hasRoleForUser(String name, String role) {
    var roles = getRolesForUser(name);

    return roles.any((element) => element == role);
  }

  /// addRoleForUser adds a role for a user.
  /// Returns false if the user already has the role (aka not affected).
  ///
  /// [user] the user.
  /// [role] the role.
  /// return succeeds or not.
  bool addRoleForUser(String user, String role) {
    return addGroupingPolicy([user, role]);
  }

  /// deleteRoleForUser deletes a role for a user.
  /// Returns false if the user does not have the role (aka not affected).
  ///
  /// [user] the user.
  /// [role] the role.
  /// return succeeds or not.
  bool deleteRoleForUser(String user, String role) {
    return removeGroupingPolicy([user, role]);
  }

  /// deleteRolesForUser deletes all roles for a user.
  /// Returns false if the user does not have any roles (aka not affected).
  ///
  /// [user] the user.
  /// return succeeds or not.

  bool deleteRolesForUser(String user) {
    return removeFilteredGroupingPolicy(0, [user]);
  }

  /// deleteUser deletes a user.
  /// Returns false if the user does not exist (aka not affected).
  ///
  /// [user] the user.
  /// return succeeds or not.

  bool deleteUser(String user) {
    return removeFilteredGroupingPolicy(0, [user]);
  }

  /// deleteRole deletes a role.
  ///
  /// [role] the role.

  void deleteRole(String role) {
    removeFilteredGroupingPolicy(1, [role]);
    removeFilteredPolicy(0, role);
  }

  /// deletePermission deletes a permission.
  /// Returns false if the permission does not exist (aka not affected).
  ///
  /// [permission] the permission, usually be (obj, act). It is actually the rule without the subject.
  /// return succeeds or not.

  bool deletePermission(List<String> permission) {
    return deletePermission(permission);
  }

  /// addPermissionForUser adds a permission for a user or role.
  /// Returns false if the user or role already has the permission (aka not affected).
  ///
  /// [user] the user.
  /// [permission] the permission, usually be (obj, act). It is actually the rule without the subject.
  /// return succeeds or not.
  bool addPermissionForUser(String user, List<String> permission) {
    var params = <String>[];

    params.add(user);
    params.addAll(permission);

    return addPolicy(params);
  }

  /// updatePermissionForUser updates a permission for a user or role.
  /// Returns false if the user or role already has the permission (aka not affected).
  ///
  /// [user] the user.
  /// [oldPermission] the old permission.
  /// [newPermission] the new permission.
  /// return succeeds or not.

  bool updatePermissionForUser(
      String user, List<String> oldPermission, List<String> newPermission) {
    var params1 = <String>[];
    var params2 = <String>[];

    params1.add(user);
    params2.add(user);

    params1.addAll(oldPermission);
    params2.addAll(newPermission);

    return updatePolicy(params1, params2);
  }

  /// deletePermissionForUser deletes a permission for a user or role.
  /// Returns false if the user or role does not have the permission (aka not affected).
  ///
  /// [user] the user.
  /// [permission] the permission, usually be (obj, act). It is actually the rule without the subject.
  /// return succeeds or not.

  bool deletePermissionForUser(String user, List<String> permission) {
    var params = <String>[];

    params.add(user);
    params.addAll(permission);

    return removePolicy(params);
  }

  /// deletePermissionsForUser deletes permissions for a user or role.
  /// Returns false if the user or role does not have any permissions (aka not affected).
  ///
  /// [user] the user.
  /// return succeeds or not.

  bool deletePermissionsForUser(String user) {
    return removeFilteredPolicy(0, user);
  }

  /// getPermissionsForUser gets permissions for a user or role.
  ///
  /// [user] the user.
  /// [domain] domain.
  /// return the permissions, a permission is usually like (obj, act). It is actually the rule without the subject.

  List<List<String>> getPermissionsForUser(String user, List<String> domain) {
    var permissions = <List<String>>[];
    for (var entry in model.model['p']!.entries) {
      var ptype = entry.key;
      var ast = entry.value;
      var args = List<String>.filled(ast.tokens.length, '');
      args[0] = user;

      if (domain.isNotEmpty) {
        var index = getDomainIndex(ptype);
        if (index < ast.tokens.length) {
          args[index] = domain[0];
        }
      }
      permissions.addAll(getFilteredPolicy(0, args));
    }

    return permissions;
  }

  /// hasPermissionForUser determines whether a user has a permission.
  ///
  /// [user] the user.
  /// [permission] the permission, usually be (obj, act). It is actually the rule without the subject.
  /// return whether the user has the permission.

  bool hasPermissionForUser(String user, List<String> permission) {
    var params = <String>[];

    params.add(user);
    params.addAll(permission);

    return hasPolicy(params);
  }

  /// getRolesForUserInDomain gets the roles that a user has inside a domain.
  ///
  /// [name] the user.
  /// [domain] the domain.
  /// return the roles that the user has in the domain.

  List<String> getRolesForUserInDomain(String name, String domain) {
    try {
      return model.model['g']!['g']!.rm.getRoles(name, [domain]);
    } on CasbinNameDoesNotExist {
      print('Role Manager does not exist');
    }
    return [];
  }

  /// getPermissionsForUserInDomain gets permissions for a user or role inside a domain.
  ///
  /// [user] the user.
  /// [domain] the domain.
  /// return the permissions, a permission is usually like (obj, act). It is actually the rule without the subject.

  List<List<String>> getPermissionsForUserInDomain(String user, String domain) {
    return getFilteredPolicy(0, [user, domain]);
  }

  /// addRoleForUserInDomain adds a role for a user inside a domain.
  /// Returns false if the user already has the role (aka not affected).
  ///
  /// [user] the user.
  /// [role] the role.
  /// [domain] the domain.
  /// return succeeds or not.

  bool addRoleForUserInDomain(String user, String role, String domain) {
    return addGroupingPolicy([user, role, domain]);
  }

  /// deleteRoleForUserInDomain deletes a role for a user inside a domain.
  /// Returns false if the user does not have the role (aka not affected).
  ///
  /// [user] the user.
  /// [role] the role.
  /// [domain] the domain.
  /// return succeeds or not.

  bool deleteRoleForUserInDomain(String user, String role, String domain) {
    return removeGroupingPolicy([user, role, domain]);
  }
}
