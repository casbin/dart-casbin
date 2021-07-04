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

import 'internal_enforcer.dart';
import 'model/assertion.dart';
import 'utils/utils.dart' as utils;

/// ManagementEnforcer = InternalEnforcer + Management API.

class ManagementEnforcer extends InternalEnforcer {
  /// getAllSubjects gets the list of subjects that show up in the current policy.
  ///
  /// returns all the subjects in "p" policy rules. It actually collects the
  /// 0-index elements of "p" policy rules. So make sure your subject
  /// is the 0-index element, like (sub, obj, act). Duplicates are removed.

  List<String> getAllSubjects() {
    return getAllNamedSubjects('p');
  }

  /// GetAllNamedSubjects gets the list of subjects that show up in the currentnamed policy.
  ///
  /// [ptype] the policy type, can be "p", "p2", "p3", ..
  /// return all the subjects in policy rules of the ptype type. It actually
  /// collects the 0-index elements of the policy rules. So make sure
  /// your subject is the 0-index element, like (sub, obj, act).
  /// Duplicates are removed.

  List<String> getAllNamedSubjects(String ptype) {
    return model.getValuesForFieldInPolicy('p', ptype, 0);
  }

  /// getAllObjects gets the list of objects that show up in the current policy.
  ///
  /// return all the objects in "p" policy rules. It actually collects the
  ///         1-index elements of "p" policy rules. So make sure your object
  ///         is the 1-index element, like (sub, obj, act).
  ///         Duplicates are removed.

  List<String> getAllObjects() {
    return getAllNamedObjects('p');
  }

  /// getAllNamedObjects gets the list of objects that show up in the current named policy.
  ///
  /// [ptype] the policy type, can be "p", "p2", "p3", ..
  /// return all the objects in policy rules of the ptype type. It actually
  /// collects the 1-index elements of the policy rules. So make sure
  /// your object is the 1-index element, like (sub, obj, act).
  /// Duplicates are removed.

  List<String> getAllNamedObjects(String ptype) {
    return model.getValuesForFieldInPolicy('p', ptype, 1);
  }

  /// getAllActions gets the list of actions that show up in the current policy.
  ///
  /// @return all the actions in "p" policy rules. It actually collects
  ///         the 2-index elements of "p" policy rules. So make sure your action
  ///         is the 2-index element, like (sub, obj, act).
  ///         Duplicates are removed.

  List<String> getAllActions() {
    return getAllNamedActions('p');
  }

  /// GetAllNamedActions gets the list of actions that show up in the current named policy.
  ///
  /// [ptype] the policy type, can be "p", "p2", "p3", ..
  /// return all the actions in policy rules of the ptype type. It actually
  /// collects the 2-index elements of the policy rules. So make sure
  /// your action is the 2-index element, like (sub, obj, act).
  /// Duplicates are removed.

  List<String> getAllNamedActions(String ptype) {
    return model.getValuesForFieldInPolicy('p', ptype, 2);
  }

  /// getAllRoles gets the list of roles that show up in the current policy.
  ///
  /// return all the roles in "g" policy rules. It actually collects
  /// the 1-index elements of "g" policy rules. So make sure your
  /// role is the 1-index element, like (sub, role).
  /// Duplicates are removed.

  List<String> getAllRoles() {
    return getAllNamedRoles('g');
  }

  /// getAllNamedRoles gets the list of roles that show up in the current named policy.
  ///
  /// [param] ptype the policy type, can be "g", "g2", "g3", ..
  /// return all the subjects in policy rules of the ptype type. It actually
  /// collects the 0-index elements of the policy rules. So make
  /// sure your subject is the 0-index element, like (sub, obj, act).
  /// Duplicates are removed.

  List<String> getAllNamedRoles(String ptype) {
    return model.getValuesForFieldInPolicy('g', ptype, 1);
  }

  /// getPolicy gets all the authorization rules in the policy.
  ///
  /// return all the "p" policy rules.

  List<List<String>> getPolicy() {
    return getNamedPolicy('p');
  }

  /// getFilteredPolicy gets all the authorization rules in the policy, field filters can be specified.
  ///
  /// [fieldIndex] the policy rule's start index to be matched.
  /// [fieldValues] the field values to be matched, value ""
  /// means not to match this field.
  /// return the filtered "p" policy rules.

  List<List<String>> getFilteredPolicy(
      int fieldIndex, List<String> fieldValues) {
    return getFilteredNamedPolicy('p', fieldIndex, fieldValues);
  }

  /// getNamedPolicy gets all the authorization rules in the named policy.
  ///
  /// [ptype] the policy type, can be "p", "p2", "p3", ..
  /// return the "p" policy rules of the specified ptype.

  List<List<String>> getNamedPolicy(String ptype) {
    return model.getPolicy('p', ptype);
  }

  /// getFilteredNamedPolicy gets all the authorization rules in the named policy, field filters can be specified.
  ///
  /// [ptype] the policy type, can be "p", "p2", "p3", ..
  /// [fieldIndex] the policy rule's start index to be matched.
  /// [fieldValues] the field values to be matched, value ""
  /// means not to match this field.
  /// return the filtered "p" policy rules of the specified ptype.

  List<List<String>> getFilteredNamedPolicy(
      String ptype, int fieldIndex, List<String> fieldValues) {
    return model.getFilteredPolicy('p', ptype, fieldIndex, fieldValues);
  }

  /// getGroupingPolicy gets all the role inheritance rules in the policy.
  ///
  /// return all the "g" policy rules.

  List<List<String>> getGroupingPolicy() {
    return getNamedGroupingPolicy('g');
  }

  /// getFilteredGroupingPolicy gets all the role inheritance rules in the policy, field filters can be specified.
  ///
  /// [fieldIndex] the policy rule's start index to be matched.
  /// [fieldValues] the field values to be matched, value ""
  /// means not to match this field.
  /// return the filtered "g" policy rules.

  List<List<String>> getFilteredGroupingPolicy(
      int fieldIndex, dynamic fieldValues) {
    return getFilteredNamedGroupingPolicy('g', fieldIndex, fieldValues);
  }

  /// getNamedGroupingPolicy gets all the role inheritance rules in the policy.
  ///
  /// [ptype] the policy type, can be "g", "g2", "g3", ..
  /// return the "g" policy rules of the specified ptype.

  List<List<String>> getNamedGroupingPolicy(String ptype) {
    return model.getPolicy('g', ptype);
  }

  /// getFilteredNamedGroupingPolicy gets all the role inheritance rules in the policy, field filters can be specified.
  ///
  /// [ptype] the policy type, can be "g", "g2", "g3", ..
  /// [fieldIndex] the policy rule's start index to be matched.
  /// [fieldValues] the field values to be matched, value ""
  /// means not to match this field.
  /// return the filtered "g" policy rules of the specified ptype.

  List<List<String>> getFilteredNamedGroupingPolicy(
      String ptype, int fieldIndex, List<String> fieldValues) {
    return model.getFilteredPolicy('g', ptype, fieldIndex, fieldValues);
  }

  /// hasPolicy determines whether an authorization rule exists.
  ///
  /// [params] the "p" policy rule, ptype "p" is implicitly used.
  /// return whether the rule exists.

  bool hasPolicy(List<String> params) {
    return hasNamedPolicy('p', params);
  }

  /// hasNamedPolicy determines whether a named authorization rule exists.
  ///
  /// [ptype] the policy type, can be "p", "p2", "p3", ..
  /// [params] the "p" policy rule.
  /// return whether the rule exists.

  bool hasNamedPolicy(String ptype, List<String> params) {
    return model.hasPolicy('p', ptype, params);
  }

  /// addPolicy adds an authorization rule to the current policy.
  /// If the rule already exists, the function returns false and the rule will not be added.
  /// Otherwise the function returns true by adding the new rule.
  ///
  /// [params] the "p" policy rule, ptype "p" is implicitly used.
  /// return succeeds or not.

  bool addPolicy(List<String> params) {
    return addNamedPolicy('p', params);
  }

  //TODO: implement later
  /// updatePolicy update an authorization rule to the current policy.
  ///
  /// [params1]  the old rule.
  /// [params2] the new rule.
  /// returns succeeds or not.

  //  bool updatePolicy(List<String> params1, List<String> params2) {
  //     return updateNamedPolicy('p', params1, params2);
  // }

  /// addPolicy adds an authorization rule to the current policy.
  /// If the rule already exists, the function returns false and the rule will not be added.
  /// Otherwise the function returns true by adding the new rule.
  ///
  /// [params] the "p" policy rule, ptype "p" is implicitly used.
  /// return succeeds or not.

  bool addPolicyList(List<String> params) {
    return addPolicy(params);
  }

  /// AddNamedPolicy adds an authorization rule to the current named policy.
  /// If the rule already exists, the function returns false and the rule will not be added.
  /// Otherwise the function returns true by adding the new rule.
  ///
  /// [ptype] the policy type, can be "p", "p2", "p3", ..
  /// [params] the "p" policy rule.
  /// return succeeds or not.

  bool addNamedPolicy(String ptype, List<String> params) {
    return addPolicyInternal('p', ptype, params);
  }

  //TODO: implement after implementing in InternalEnforcer
  /// updateNamedPolicy updates an authorization rule to the current named policy.
  ///
  /// [ptype] the policy type, can be "p", "p2", "p3", ..
  /// [params1]  the old rule.
  /// [params2] the new rule.
  /// return succeeds or not.

  //  bool updateNamedPolicy(String ptype, List<String> params1, List<String> params2) {
  //     return updatePolicy('p', ptype, params1, params2);
  // }

  /// removePolicy removes an authorization rule from the current policy.
  ///
  /// [params] the "p" policy rule, ptype "p" is implicitly used.
  /// return succeeds or not.

  bool removePolicy(List<String> params) {
    return removeNamedPolicy('p', params);
  }

  //TODO: implement later
  /// removeFilteredPolicy removes an authorization rule from the current policy, field filters can be specified.
  ///
  /// [fieldIndex] the policy rule's start index to be matched.
  /// [fieldValues] the field values to be matched, value ""
  ///                    means not to match this field.
  /// return succeeds or not.

  //  bool removeFilteredPolicy(int fieldIndex, dynamic fieldValues) {
  //     return removeFilteredNamedPolicy('p', fieldIndex, fieldValues);
  // }

  /// removeNamedPolicy removes an authorization rule from the current named policy.
  ///
  /// [ptype] the policy type, can be "p", "p2", "p3", ..
  /// [params] the "p" policy rule.
  /// return succeeds or not.

  bool removeNamedPolicy(String ptype, List<String> params) {
    return removePolicyInternal('p', ptype, params);
  }

  //TODO: implement later
  /// removeFilteredNamedPolicy removes an authorization rule from the current named policy, field filters can be specified.
  ///
  /// [ptype] the policy type, can be "p", "p2", "p3", ..
  /// [fieldIndex] the policy rule's start index to be matched.
  /// [fieldValues] the field values to be matched, value ""
  ///                    means not to match this field.
  /// return succeeds or not.

  //  bool removeFilteredNamedPolicy(String ptype, int fieldIndex, dynamic fieldValues) {
  //     return removeFilteredPolicy('p', ptype, fieldIndex, fieldValues);
  // }

  /// addGroupingPolicy adds a role inheritance rule to the current policy.
  /// If the rule already exists, the function returns false and the rule will not be added.
  /// Otherwise the function returns true by adding the new rule.
  ///
  /// [params] the "g" policy rule, ptype "g" is implicitly used.
  /// returns succeeds or not.

  bool addGroupingPolicy(List<String> params) {
    return addNamedGroupingPolicy('g', params);
  }

  /// addNamedGroupingPolicy adds a named role inheritance rule to the current policy.
  /// If the rule already exists, the function returns false and the rule will not be added.
  /// Otherwise the function returns true by adding the new rule.
  ///
  /// [ptype] the policy type, can be "g", "g2", "g3", ..
  /// [params] the "g" policy rule.
  /// return succeeds or not.

  bool addNamedGroupingPolicy(String ptype, List<String> params) {
    var ruleAdded = addPolicyInternal('g', ptype, params);

    return ruleAdded;
  }

  /// removeGroupingPolicy removes a role inheritance rule from the current policy.
  ///
  /// params the "g" policy rule, ptype "g" is implicitly used.
  /// succeeds or not.

  bool removeGroupingPolicy(List<String> params) {
    return removeNamedGroupingPolicy('g', params);
  }

  /// removeNamedGroupingPolicy removes a role inheritance rule from the current named policy.
  ///
  /// [ptype] the policy type, can be "g", "g2", "g3", ..
  /// [params] the "g" policy rule.
  /// return succeeds or not.

  bool removeNamedGroupingPolicy(String ptype, List<String> params) {
    var ruleRemoved = removePolicyInternal('g', ptype, params);

    return ruleRemoved;
  }

  /// getPermittedActions returns all valid actions to specific object for current subject.
  /// At present, the execution efficiency of this method is not high. Please avoid calling this method frequently.
  ///
  /// [sub] the subject(usually means user).
  /// [obj] the object(usually means resources).
  /// return all valid actions to specific object for current subject.

  Set<String> getPermittedActions(String sub, String obj) {
    var ast = model.model['p']?['p']; //"sub, obj, act, ..."
    List<List<String>> relations;
    if (model.model['g'] != null) {
      relations = model.model['g']!['g']!.policy;
    } else {
      relations = [];
    }

    var actIndex = utils.getElementIndex(ast, 'act');
    var objIndex = utils.getElementIndex(ast, 'obj');
    var subIndex = utils.getElementIndex(ast, 'sub');
    var eftIndex = utils.getElementIndex(ast, 'eft');

    var users = <String>{};
    users.add(sub);
    int size;
    do {
      size = users.length;
      for (var relation in relations) {
        if (users.contains(relation[0])) {
          users.add(relation[1]);
        }
      }
    } while (size != users.length);

    var policy = getPolicy();
    var actionSet = <String>{};
    for (var role in policy) {
      var isThisUser = false;
      for (var user in users) {
        if (role[subIndex] == user) {
          isThisUser = true;
          break;
        }
      }
      if (isThisUser && role[objIndex] == obj) {
        if (eftIndex == -1 || role[eftIndex].toLowerCase() == 'allow') {
          actionSet.add(role[actIndex]);
        }
      }
    }
    return actionSet;
  }
}
