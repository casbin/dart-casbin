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

import '../model/model.dart';

/// Interface for Casbin adapters.
abstract class Adapter {
  /// Loads all policy rules from the storage.
  ///
  /// [model] is the model.
  void loadPolicy(Model model);

  /// Saves all policy rules to the storage.
  ///
  /// [model] is the model.
  void savePolicy(Model model);

  /// addPolicy adds a policy rule to the storage.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [rule] is the rule, like (sub, obj, act).
  /// This is part of the Auto-Save feature.
  void addPolicy(String sec, String ptype, List<String> rule);

  /// removePolicy removes a policy rule from the storage.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [rule] is the rule, like (sub, obj, act).
  /// This is part of the Auto-Save feature.
  void removePolicy(String sec, String ptype, List<String> rule);

  /// removeFilteredPolicy removes policy rules that match the filter from the storage.
  ///
  /// [sec] is the section, "p" or "g".
  /// [ptype] is the policy type, "p", "p2", .. or "g", "g2", ..
  /// [fieldIndex] is the policy rule's start index to be matched.
  /// [fieldValues] is the field values to be matched, value '' means not to match this field.
  /// This is part of the Auto-Save feature.
  void removeFilteredPolicy(
      String sec, String ptype, int fieldIndex, List<String> fieldValues);
}
