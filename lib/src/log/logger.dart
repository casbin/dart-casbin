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

import 'dart:collection';

import '../model/assertion.dart';
import '../rbac/domain_roles.dart';

/// Logger is the logging interface implementation.
abstract class Logger {
  /// enableLog controls whether print the message.
  void enableLog(bool enable);

  /// isEnabled returns if logger is enabled.
  bool isEnabled();

  /// prints log info
  void logPrint(String message);

  /// logModel log info related to model.
  void logModel(HashMap<String, HashMap<String, Assertion>> model);

  /// logRole log info related to role.
  void logRole(Map<String, DomainRoles> allDomains);

  /// logPolicy log info related to policy.
  void logPolicy(HashMap<String, HashMap<String, Assertion>> model);
}
