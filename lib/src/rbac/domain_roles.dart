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

import 'role.dart';

typedef MatchingFunc = bool Function(String arg1, String arg2);

V loadOrDefault<K, V>(Map<K, V> map, K key, V value) {
  final read = map[key];
  if (read == null) {
    map[key] = value;
    return value;
  }
  return read;
}

class DomainRoles {
  var roles = <String, Role>{};

  bool hasRole(String name, MatchingFunc? matchingFunc) {
    var ok = false;
    if (matchingFunc == null) {
      return roles.containsKey(name);
    } else {
      roles.forEach((key, value) {
        if (matchingFunc(key, name)) {
          ok = true;
        }
      });
    }
    return ok;
  }

  Role createRole(String name, MatchingFunc? matchingFunc) {
    var role = loadOrDefault(roles, name, Role(name));
    if (matchingFunc != null) {
      roles.forEach((key, value) {
        if (matchingFunc(name, key) && name != key) {
          final role1 = loadOrDefault(roles, key, Role(key));
          role.addRole(role1);
        }
      });
    }
    return role;
  }

  Role getOrCreate(final String name) {
    return roles.putIfAbsent(name, () => Role(name));
  }
}
