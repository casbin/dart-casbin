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

// InternalEnforcer = CoreEnforcer + Internal API.

import 'core_enforcer.dart';
import 'model/model.dart';
import 'persist/file_adapter.dart';

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
        //TODO: change after log printing is implemented
        print('Method not implemented');
      } catch (e) {
        //TODO: change after log printing is implemented
        print('An exception occurred: ${e.toString()}');
        return false;
      }
    }

    model.addPolicy(sec, ptype, rule);

    if (sec == 'g') {
      var rules = <List<String>>[];
      rules.add(rule);
      buildIncrementalRoleLinks(PolicyOperations.PolicyAdd, ptype, rules);
    }

    //TODO: implement after implementing watcher

    return true;
  }

  //TODO: implement after implementing batchAdapter
  // bool addPoliciesInternal(String sec, String ptype, List<List<String>> rules) {}

  /// buildIncrementalRoleLinks provides incremental build the role inheritance relations.
  /// [op] Policy operations.
  /// [ptype] policy type.
  /// [rules] the rules.
  void buildIncrementalRoleLinks(
      PolicyOperations op, String ptype, List<List<String>> rules) {
    model.buildIncrementalRoleLinks(rm, op, 'g', ptype, rules);
  }

  /// removePolicy removes a rule from the current policy.
  bool removePolicyInternal(String sec, String ptype, List<String> rule) {
    if ((adapter.runtimeType == FileAdapter &&
            (adapter as FileAdapter).filePath.isNotEmpty) &&
        autoSave) {
      try {
        adapter.removePolicy(sec, ptype, rule);
      } on UnsupportedError {
        print('Method not implemented');
      } catch (e) {
        print('An exception occurred: ${e.toString()}');
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
    //TODO: implement after implementing watcher

    return true;
  }

  //TODO: implement later
  /// updatePolicy updates an authorization rule from the current policy.
  ///
  /// [sec]     the section, "p" or "g".
  /// [ptype]   the policy type, "p", "p2", .. or "g", "g2", ..
  /// [oldRule] the old rule.
  /// [newRule] the new rule.
  ///  returns whether the action succeeds or not.
  // bool updatePolicy(
  //     String sec, String ptype, List<String> oldRule, List<String> newRule) {}

  /// removePolicies removes rules from the current policy.
  // bool removePolicies(String sec, String ptype, List<List<String>> rules) {}

  /// removeFilteredPolicy removes rules based on field filters from the current policy.
  // bool removeFilteredPolicy(String sec, String ptype, int fieldIndex, dynamic fieldValues) {}
}
