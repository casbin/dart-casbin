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
import 'effector.dart';

/// Default effector for Casbin.
class DefaultEffector implements Effector {
  @override
  bool mergeEffects(String expr, List<Effect> effects, List<double> results) {
    var result = false;
    if (expr == 'some(where (p_eft == allow))') {
      result = effects.any((eft) => eft == Effect.allow);
    } else if (expr == '!some(where (p_eft == deny))') {
      result = !effects.any((eft) => eft == Effect.deny);
    } else if (expr ==
        'some(where (p_eft == allow)) && !some(where (p_eft == deny))') {
      if (effects.any((eft) => eft == Effect.deny)) {
        result = false;
      } else if (effects.any((eft) => eft == Effect.allow)) {
        result = true;
      }
    } else if (expr == 'priority(p_eft) || deny') {
      for (var eft in effects) {
        if (eft != Effect.indeterminate) {
          if (eft == Effect.allow) {
            result = true;
          } else {
            result = false;
          }
          break;
        }
      }
    } else {
      throw UnsupportedError('unsupported effect');
    }

    return result;
  }
}
