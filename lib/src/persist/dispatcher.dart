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

/// Dispatcher is the interface for dart-casbin dispatcher
library;

abstract class Dispatcher {
  /// AddPolicies adds policies rule to all instance.

  void addPolicies(String sec, String ptype, List<List<String>> rules);

  /// RemovePolicies removes policies rule from all instance.

  void removePolicies(String sec, String ptype, List<List<String>> rules);

  /// RemoveFilteredPolicy removes policy rules that match the filter from all instance.

  void removeFilteredPolicy(
      String sec, String ptype, int fieldIndex, List<String> fieldValues);

  /// ClearPolicy clears all current policy in all instances

  void clearPolicy();

  /// UpdatePolicy updates policy rule from all instance.

  void updatePolicy(
      String sec, String ptype, List<String> oldRule, List<String> newRule);
}
