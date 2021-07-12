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

import '../rbac/role_manager.dart';

// regexMatch determines whether key1 matches the pattern of key2 in regular expression.
bool regexMatch(String key1, String key2) {
  return RegExp(key2).hasMatch(key1);
}

/// keyMatch determines whether [key1] matches the pattern of [key2] (similar to RESTful path),
/// [key2] can contain a *.
/// For example, '/foo/bar' matches '/foo/*'

bool keyMatch(String key1, String key2) {
  var i = key2.indexOf('*');
  if (i == -1) {
    return key1 == key2;
  }
  if (key1.length > i) {
    return key1.substring(0, i) == key2.substring(0, i);
  }
  return key1 == key2.substring(0, i);
}

/// keyMatch2 determines whether [key1] matches the pattern of [key2] (similar to RESTful path),
/// [key2] can contain a *.
/// For example, "/foo/bar" matches "/foo/*", "/resource1" matches "/:resource"

bool keyMatch2(String key1, String key2) {
  key2 = key2.replaceAll('/*', '/.*');

  final re = RegExp(':[^/]+');
  key2 = key2.replaceAll(re, '[^/]+');

  return regexMatch(key1, '^' + key2 + '\$');
}

/// keyMatch3 determines whether [key1] matches the pattern of [key2] (similar to RESTful path)
/// [key2] can contain a *
/// For example, "/foo/bar" matches "/foo/*", "/resource1" matches "/{resource}"

bool keyMatch3(String key1, String key2) {
  key2 = key2.replaceAll('/*', '/.*');

  var reg = RegExp('\{[^/]+\}');
  key2 = key2.replaceAll(reg, '[^/]+');

  return regexMatch(key1, '^' + key2 + '\$');
}

/// KeyGet returns the matched part. For example, "/foo/bar/foo" matches "/foo/*", "bar/foo" will been returned
///
/// [key1] the first argument.
/// [key2] the second argument.
/// return the matched part.

String keyGetFunc(String key1, String key2) {
  var index = key2.indexOf('*');
  if (index == -1) {
    return '';
  }
  if (key1.length > index) {
    if (key1.substring(0, index) == key2.substring(0, index)) {
      return key1.substring(index);
    }
  }
  return '';
}

/// KeyGet2 returns value matched pattern.For example, "/resource1" matches "/:resource",
/// if the pathVar == "resource", then "resource1" will be returned.
/// [key1] the first argument.
/// [key2] the second argument.
/// return the matched part.

String keyGet2Func(String key1, String key2, String pathVar) {
  key2 = key2.replaceAll('/*', '/.*');

  var regex = RegExp(':[^/]+');
  var keys = regex.allMatches(key2).toList();
  var keyList = <String>[];

  for (var i = 0; i < keys.length; i++) {
    keyList.add(keys[i].group(0)!);
  }

  key2 = key2.replaceAll(regex, '([^/]+)');
  key2 = '^' + key2 + '\$';

  var values = RegExp(key2).allMatches(key1).toList();
  var valueList = <String>[];

  for (var i = 0; i < values.length; i++) {
    for (var j = 0; j <= values[i].groupCount; j++) {
      valueList.add(values[i].group(j)!);
    }
  }

  if (valueList.isEmpty) {
    return '';
  }
  for (var i = 0; i < keyList.length; i++) {
    if (pathVar == keyList[i].substring(1)) {
      return valueList[i + 1];
    }
  }
  return '';
}

dynamic generateGFunction(RoleManager? rm) {
  final memorized = <String, bool>{};

  bool func(String name1, String name2, [String? domain]) {
    final key = name1 + name2 + (domain ?? '');
    var value = memorized[key];

    if (value != null) {
      return value;
    }

    if (rm == null) {
      value = name1 == name2;
    } else if (domain == null) {
      value = rm.hasLink(name1, name2);
    } else {
      value = rm.hasLink(name1, name2, [domain]);
    }
    memorized[key] = value;
    return value;
  }

  return func;
}
