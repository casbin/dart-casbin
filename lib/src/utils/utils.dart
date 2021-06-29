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

final evalReg = RegExp(r'\beval\(([^),]*)\)');

bool hasEvalFn(String s) {
  return evalReg.hasMatch(s);
}

List<String> getEvalValue(String s) {
  final submatch = evalReg.allMatches(s);
  final rules = <String>[];

  if (submatch.isEmpty) {
    return [];
  }
  for (var rule in submatch) {
    var startingIndex = rule.group(0)!.indexOf('(');
    var endingIndex = rule.group(0)!.indexOf(')');
    if (endingIndex == -1) {
      endingIndex = rule.group(0)!.length;
    }

    rules.add(rule.group(0)!.substring(startingIndex + 1, endingIndex));
  }
  return rules;
}

String replaceEval(String s, String rule) {
  return s.replaceAll(evalReg, '(' + rule + ')');
}

String arrayToString(List<String> s) {
  return s.join(', ');
}

/// splitCommaDelimited splits a comma-delimited string into a string array. It assumes that any
/// number of whitespace might exist before or after the comma and that tokens do not include
/// whitespace as part of their value.
///
/// [s] the comma-delimited string.
/// return the array with the string tokens.

List<String>? splitCommaDelimited(String? s) {
  if (s == null) {
    return null;
  }
  return s.trim().split('\\s///,\\s///');
}
