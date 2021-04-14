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
  Future<void> loadPolicy(Model model);

  /// Saves all policy rules to the storage.
  Future<void> savePolicy(Model model);

  /// Adds a policy rule to the storage.
  /// This is part of the Auto-Save feature.
  Future<void> addPolicy(String sec, String ptype, List<String> rule);

  /// Removes a policy rule from the storage.
  /// This is part of the Auto-Save feature.
  Future<void> removePolicy(String sec, String ptype, List<String> rule);

  /// Removes policy rules that match the filter from the storage.
  /// This is part of the Auto-Save feature.
  Future<void> removeFilteredPolicy(
    String sec,
    String ptype,
    int fieldIndex,
    List<String> fieldValues,
  );
}
