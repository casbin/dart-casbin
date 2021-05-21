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

import 'effect.dart';

/// Interface for Casbin effectors.
abstract class Effector {
  /// Merges all matching results collected by the enforcer into a single decision
  /// and returns the final effect.
  ///
  /// [expr] is the expression of __policy_effect__.
  /// [effects] are the effects of all matched rules.
  /// [results] is the matcher results of all matched rules.
  bool mergeEffects(String expr, List<Effect> effects, List<double> results);
}
