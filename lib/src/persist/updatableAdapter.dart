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

import 'adapter.dart';

abstract class UpdatabelAdapter extends Adapter {
  /// UpdatePolicy updates a policy rule from storage.
  /// This is part of the Auto-Save feature.
  /// [sec] the section, "p" or "g".
  /// [ptype] the policy type, "p", "p2", .. or "g", "g2", ..
  /// [oldRule] the old rule.
  /// [newPolicy] the new policy.

  void updatePolicy(
    String sec,
    String ptype,
    List<String> oldRule,
    List<String> newPolicy,
  ) {}
}
