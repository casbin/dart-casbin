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

import 'package:expressions/expressions.dart';

import 'effect/default_effector.dart';
import 'effect/effect.dart';
import 'effect/effector.dart';
import 'model/function_map.dart';
import 'model/model.dart';
import 'persist/adapter.dart';
import 'persist/file_adapter.dart';
import 'rbac/default_role_manager.dart';
import 'rbac/role_manager.dart';

/// Defines the core functionality of an enforcer.
class CoreEnforcer {
  String modelPath;
  Model model;
  FunctionMap fm;
  Effector eft;

  Adapter adapter;
  //Watcher watcher;
  RoleManager rm;

  bool enabled;
  bool autoSave;
  bool autoBuildRoleLinks;

  CoreEnforcer()
      : modelPath = '',
        model = Model(),
        eft = DefaultEffector(),
        rm = DefaultRoleManager(10),
        adapter = FileAdapter(''),
        enabled = true,
        autoSave = true,
        autoBuildRoleLinks = true,
        fm = FunctionMap.loadFunctionMap();

  void initialize() {
    rm = DefaultRoleManager(10);
    eft = DefaultEffector();

    enabled = true;
    autoSave = true;
    autoBuildRoleLinks = true;
  }

  /// Creates a model.
  ///
  /// [model] is the model path or the model text.
  static Model newModel([String model = '']) {
    var m = Model();

    if (model == 'path') {
      // todo(KNawm): Check if it's a model file.
      m.loadModel(model);
    } else if (model == 'text') {
      // todo(KNawm): Check if it's a model text.
      m.loadModelFromText(model);
    }

    return m;
  }

  /// Reloads the model from the model CONF file.
  /// Because the policy is attached to a model, so the policy is invalidated
  /// and needs to be reloaded by calling loadPolicy().
  void loadModel() {
    model = newModel();
    model.loadModel(modelPath);
    model.printModel();
    //fm = FunctionMap.loadFunctionMap();
  }

  /// Returns the current model.
  Model? getModel() {
    return model;
  }

  /// setModel sets the current model.
  ///
  /// [model] is the model.
  void setModel(Model model) {
    this.model = model;
    //fm = FunctionMap.loadFunctionMap();
  }

  /// Returns the current adapter.
  //Adapter getAdapter() {}

  /// Sets the current adapter.
  ///
  /// [adapter] is the adapter.
  //void setAdapter(Adapter adapter) {}

  /// Sets the current watcher.
  ///
  /// [watcher] is the watcher.
  //void setWatcher(Watcher watcher) {}

  /// Sets the current role manager.
  ///
  /// [rm] is the role manager.
  void setRoleManager(RoleManager rm) {
    this.rm = rm;
  }

  /// Sets the current effector.
  ///
  /// [eft] is the effector.
  void setEffector(Effector eft) {
    this.eft = eft;
  }

  /// Clears all policy.
  void clearPolicy() {
    model.clearPolicy();
  }

  /// Reloads the policy from file/database.
  void loadPolicy() {
    model.clearPolicy();
    adapter.loadPolicy(model);

    model.printPolicy();
    if (autoBuildRoleLinks) {
      buildRoleLinks();
    }
  }

  /// Reloads a filtered policy from file/database.
  ///
  /// [filter] is the filter used to specify which type of policy should be loaded.
  void loadFilteredPolicy(var filter) {
    throw UnimplementedError();
  }

  /// Returns if the loaded policy has been filtered.
  bool isFiltered() {
    return false;
  }

  /// Saves the current policy (usually after changed with Casbin API) back to file/database.
  void savePolicy() {
    // TODO(KNawm): Implement
  }

  /// Changes the enforcing state of Casbin, when Casbin is disabled, all access will be allowed by the enforce() function.
  ///
  /// [enable] whether to enable the enforcer.
  void enableEnforce(bool enable) {
    enabled = enable;
  }

  /// Changes whether to print Casbin log to the standard output.
  ///
  /// [enable] whether to enable Casbin's log.
  void enableLog(bool enable) {
    // TODO(KNawm): Implement logger
  }

  /// Controls whether to save a policy rule automatically to the adapter when it is added or removed.
  ///
  /// [autoSave] whether to enable the AutoSave feature.
  void enableAutoSave(bool autoSave) {
    this.autoSave = autoSave;
  }

  /// Controls whether to save a policy rule automatically to the adapter when it is added or removed.
  ///
  /// [autoBuildRoleLinks] whether to automatically build the role links.
  void enableAutoBuildRoleLinks(bool autoBuildRoleLinks) {
    this.autoBuildRoleLinks = autoBuildRoleLinks;
  }

  /// Manually rebuild the role inheritance relations.
  void buildRoleLinks() {
    rm.clear();
    model.buildRoleLinks(rm);
  }

  /// Returns whether a "subject" can access a "object" with the operation "action", input parameters are usually: [sub, obj, act].
  ///
  /// [rvals] the request that needs to be mediated.
  bool enforce(List<String> rvals) {
    if (!enabled) {
      return true;
    }

    var functions = <String, dynamic>{};
    fm.functionMap.forEach((key, value) {
      functions[key] = value;
    });

    //TODO: handle generating GFunctions

    final expString = model.model['m']!['m']!.value;
    if (expString.isEmpty) {
      throw Exception('Unable to find matchers in model');
    }

    final effectExpr = model.model['e']!['e']!.value;
    if (effectExpr.isEmpty) {
      throw Exception('Unable to find policy_effect in model');
    }

    final p = model.model['p']!['p'];
    final policyLen = p!.policy.length;

    final rTokens = model.model['r']!['r']!.tokens;
    final rTokensLen = rTokens.length;

    //TODO: implement hasEval function
    final hasEval = false;
    Expression? expression;

    List<Effect> policyEffects;
    List<double> matcherResults;

    if (policyLen != 0) {
      policyEffects = List<Effect>.filled(policyLen, Effect.Indeterminate);
      matcherResults = List<double>.filled(policyLen, 0);
      for (var i = 0; i < policyLen; i++) {
        final params = <String, dynamic>{};

        if (rTokens.length != rvals.length) {
          throw Exception(
              'invalid request size: expected $rTokensLen, got ${rvals.length}, rvals: $rvals');
        }

        for (var j = 0; j < rTokensLen; j++) {
          params[rTokens[j]] = rvals[j];
        }

        for (var j = 0; j < p.tokens.length; j++) {
          params[p.tokens[j]] = p.policy[i][j];
        }

        if (hasEval) {
          //TODO: implement this.
        } else {
          expression ??= Expression.parse(expString);
        }

        final context = {...params, ...functions};

        final evaluator = const ExpressionEvaluator();
        final result = evaluator.eval(expression!, context);

        if (result.runtimeType == bool) {
          if (!result) {
            policyEffects[i] = Effect.Indeterminate;
            continue;
          }
        } else if (result.runtimeType == int) {
          if (result == 0) {
            policyEffects[i] = Effect.Indeterminate;
            continue;
          } else {
            matcherResults[i] = result;
          }
        } else {
          throw Exception('matcher result should be boolean or number');
        }

        if (params['p_eft'] != null) {
          String eft = params['p_eft'];
          if (eft == 'allow') {
            policyEffects[i] = Effect.Allow;
          } else if (eft == 'deny') {
            policyEffects[i] = Effect.Deny;
          } else {
            policyEffects[i] = Effect.Indeterminate;
          }
        } else {
          policyEffects[i] = Effect.Allow;
        }
      }
    } else {
      if (hasEval && model.model['p']!['p']!.policy.isEmpty) {
        throw Exception(
            'please make sure rule exists in policy when using eval() in matcher');
      }

      final params = <String, dynamic>{};

      policyEffects = <Effect>[Effect.Indeterminate];
      matcherResults = <double>[0];

      for (var j = 0; j < rTokensLen; j++) {
        params[rTokens[j]] = rvals[j];
      }

      for (var j = 0; j < p.tokens.length; j++) {
        params[p.tokens[j]] = '';
      }

      final context = {...params, ...functions};
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(expression!, context);

      policyEffects[0] = result ? Effect.Allow : Effect.Indeterminate;
    }

    final result = eft.mergeEffects(
        model.model['e']!['e']!.value, policyEffects, matcherResults);

    return result;
  }

  bool validateEnforce(List<String> rvals) {
    return _validateEnforceSection('r', rvals);
  }

  bool _validateEnforceSection(String section, List<String> rvals) {
    throw UnimplementedError();
  }
}
