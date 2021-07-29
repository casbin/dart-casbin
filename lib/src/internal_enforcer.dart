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

import 'core_enforcer.dart';
import 'log/log_util.dart';
import 'model/model.dart';
import 'persist/batch_adapter.dart';
import 'persist/file_adapter.dart';
import 'persist/updatableAdapter.dart';

/// InternalEnforcer = CoreEnforcer + Internal API.
class InternalEnforcer extends CoreEnforcer {
  /// addPolicy adds a rule to the current policy.
  bool addPolicyInternal(String sec, String ptype, List<String> rule) {
    if (model.hasPolicy(sec, ptype, rule)) {
      return false;
    }

    if ((adapter.runtimeType == FileAdapter &&
            (adapter as FileAdapter).filePath.isNotEmpty) &&
        autoSave) {
      try {
        adapter.addPolicy(sec, ptype, rule);
      } on UnsupportedError {
        logger.logPrint('Method not implemented');
      } catch (e) {
        logger.logPrint('An exception occurred: ${e.toString()}');
        return false;
      }
    }

    var res = model.addPolicy(sec, ptype, rule);

    if (sec == 'g' && res) {
      var rules = <List<String>>[];
      rules.add(rule);
      buildIncrementalRoleLinks(PolicyOperations.PolicyAdd, ptype, rules);
    }

    if (watcher != null && autoNotifyWatcher) {
      watcher!.update();
    }
    return true;
  }

  /// addPolicies adds multiple rules to the current policy.

  bool addPoliciesInternal(String sec, String ptype, List<List<String>> rules) {
    if (model.hasPolicies(sec, ptype, rules)) {
      return false;
    }

    if ((adapter.runtimeType == FileAdapter &&
            (adapter as FileAdapter).filePath.isNotEmpty) &&
        autoSave) {
      try {
        if (adapter.runtimeType == BatchAdapter) {
          (adapter as BatchAdapter).addPolicies(sec, ptype, rules);
        } else {
          throw UnsupportedError(
              'cannot to save policy, the adapter does not implement the BatchAdapter');
        }
      } on UnsupportedError {
        logger.logPrint('Method not implemented');
      } catch (e) {
        logger.logPrint('An exception occurred: ${e.toString()}');
        return false;
      }
    }

    var res = model.addPolicies(sec, ptype, rules);

    if (sec == 'g' && res) {
      buildIncrementalRoleLinks(PolicyOperations.PolicyAdd, ptype, rules);
    }

    if (watcher != null && autoNotifyWatcher) {
      watcher!.update();
    }
    return true;
  }

  /// buildIncrementalRoleLinks provides incremental build the role inheritance relations.
  /// [op] Policy operations.
  /// [ptype] policy type.
  /// [rules] the rules.

  void buildIncrementalRoleLinks(
    PolicyOperations op,
    String ptype,
    List<List<String>> rules,
  ) {
    model.buildIncrementalRoleLinks(rm, op, 'g', ptype, rules);
  }

  /// updatePolicy updates an authorization rule from the current policy.
  ///
  /// [sec]     the section, "p" or "g".
  /// [ptype]   the policy type, "p", "p2", .. or "g", "g2", ..
  /// [oldRule] the old rule.
  /// [newRule] the new rule.
  ///  returns whether the action succeeds or not.

  bool updatePolicyInternal(
    String sec,
    String ptype,
    List<String> oldRule,
    List<String> newRule,
  ) {
    if (dispatcher != null && autoNotifyDispatcher) {
      dispatcher!.updatePolicy(sec, ptype, oldRule, newRule);
      return true;
    }

    if ((adapter.runtimeType == FileAdapter &&
            (adapter as FileAdapter).filePath.isNotEmpty) &&
        autoSave) {
      try {
        (adapter as UpdatabelAdapter)
            .updatePolicy(sec, ptype, oldRule, newRule);
      } on UnsupportedError {
        logger.logPrint('Method not implemented');
      } catch (e) {
        logger.logPrint('An exception occurred: ${e.toString()}');
        return false;
      }
    }

    var ruleUpdated = model.updatePolicy(sec, ptype, oldRule, newRule);

    if (!ruleUpdated) {
      return false;
    }

    if ('g' == sec) {
      try {
        // remove the old rule
        var oldRules = <List<String>>[];
        oldRules.add(oldRule);
        buildIncrementalRoleLinks(
            PolicyOperations.PolicyRemove, ptype, oldRules);
      } catch (e) {
        logger.logPrint('An exception occurred:' + e.toString());
        return false;
      }

      try {
        // add the new rule
        var newRules = <List<String>>[];
        newRules.add(newRule);
        buildIncrementalRoleLinks(PolicyOperations.PolicyAdd, ptype, newRules);
      } catch (e) {
        logger.logPrint('An exception occurred:' + e.toString());
        return false;
      }
    }

    if (watcher != null && autoNotifyWatcher) {
      try {
        watcher!.update();
      } catch (e) {
        logger.logPrint('An exception occurred:' + e.toString());
        return false;
      }
    }

    return true;
  }

  /// removePolicy removes a rule from the current policy.

  bool removePolicyInternal(String sec, String ptype, List<String> rule) {
    if (!model.hasPolicy(sec, ptype, rule)) {
      return false;
    }

    if ((adapter.runtimeType == FileAdapter &&
            (adapter as FileAdapter).filePath.isNotEmpty) &&
        autoSave) {
      try {
        adapter.removePolicy(sec, ptype, rule);
      } on UnsupportedError {
        logger.logPrint('Method not implemented');
      } catch (e) {
        logger.logPrint('An exception occurred: ${e.toString()}');
        return false;
      }
    }

    var ruleRemoved = model.removePolicy(sec, ptype, rule);

    if (!ruleRemoved) {
      return false;
    }

    if (sec == 'g') {
      var rules = <List<String>>[];
      rules.add(rule);
      buildIncrementalRoleLinks(PolicyOperations.PolicyRemove, ptype, rules);
    }
    if (watcher != null && autoNotifyWatcher) {
      watcher!.update();
    }

    return true;
  }

  /// removePoliciesInternal removes rules from the current policy.
  bool removePoliciesInternal(
      String sec, String ptype, List<List<String>> rules) {
    if (model.hasPolicies(sec, ptype, rules)) {
      return false;
    }

    if ((adapter.runtimeType == FileAdapter &&
            (adapter as FileAdapter).filePath.isNotEmpty) &&
        autoSave) {
      try {
        if (adapter.runtimeType == BatchAdapter) {
          (adapter as BatchAdapter).removePolicies(sec, ptype, rules);
        }
      } on UnsupportedError {
        logger.logPrint('Method not implemented');
      } catch (e) {
        logger.logPrint('An exception occurred: ${e.toString()}');
        return false;
      }

      var rulesRemoveed = model.removePolicies(sec, ptype, rules);

      if (!rulesRemoveed) {
        return false;
      }

      if (sec == 'g') {
        buildIncrementalRoleLinks(PolicyOperations.PolicyRemove, ptype, rules);
      }
      if (watcher != null && autoNotifyWatcher) {
        watcher!.update();
      }
    }
    return true;
  }

  /// removeFilteredPolicyInternal removes rules based on field filters from the current policy.
  bool removeFilteredPolicyInternal(
    String sec,
    String ptype,
    int fieldIndex,
    List<String> fieldValues,
  ) {
    if (fieldValues.isEmpty) {
      logger.logPrint('Invalid fieldValues parameter');
      return false;
    }

    if ((adapter.runtimeType == FileAdapter &&
            (adapter as FileAdapter).filePath.isNotEmpty) &&
        autoSave) {
      try {
        adapter.removeFilteredPolicy(sec, ptype, fieldIndex, fieldValues);
      } on UnsupportedError {
        logger.logPrint('Method not implemented');
      } catch (e) {
        logger.logPrint('An exception occurred: ${e.toString()}');
        return false;
      }
    }

    var effects = model.removeFilteredPolicyReturnsEffects(
        sec, ptype, fieldIndex, fieldValues);

    var ruleRemoved = effects.isNotEmpty;

    if (!ruleRemoved) {
      return false;
    }

    if (sec == 'g') {
      buildIncrementalRoleLinks(PolicyOperations.PolicyRemove, ptype, effects);
    }

    if (watcher != null && autoNotifyWatcher) {
      watcher!.update();
    }

    return true;
  }

  int getDomainIndex(String ptype) {
    var ast = model.model['p']![ptype];
    var pattern = '${ptype}_dom';
    var index = ast!.tokens.length;
    for (var i = 0; i < ast.tokens.length; i++) {
      if (ast.tokens[i] == pattern) {
        index = i;
        break;
      }
    }
    return index;
  }
}
