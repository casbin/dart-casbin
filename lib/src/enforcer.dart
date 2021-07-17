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
}
