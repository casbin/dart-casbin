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

import 'dart:io';

import 'package:csv/csv.dart';

import '../model/model.dart';
import 'adapter.dart';

void loadPolicyLine(String line, Model model) {
  if (line.isEmpty || line.trimLeft()[0] == '#') {
    return;
  }

  final tokens = CsvToListConverter().convert(line).cast<List<String>>();

  if (tokens.isEmpty || tokens.first.isEmpty) {
    return;
  }

  final key = tokens[0][0];
  final sec = key.substring(0, 1);
  final item = model.model[sec];
  if (item == null) {
    return;
  }

  final policy = item[key];
  if (policy == null) {
    return;
  }

  policy.policy.add(tokens[0].sublist(1));
}

/// FileAdapter is the file adapter for Casbin.
/// It can load policy from file or save policy to file.
class FileAdapter implements Adapter {
  final String filePath;

  FileAdapter(this.filePath);

  @override
  Future<void> loadPolicy(Model model) async {
    final lines = await File(filePath).readAsLines();
    lines.forEach((l) => loadPolicyLine(l, model));
  }

  @override
  Future<void> savePolicy(Model model) async {
    final buffer = StringBuffer();

    final pList = model.model['p'];
    if (pList == null) {
      return;
    }
    for (var p in pList.entries) {
      for (var rule in p.value.policy) {
        buffer.write('${p.key},');
        buffer.writeln(rule.join(','));
      }
    }

    final gList = model.model['g'];
    if (gList == null) {
      return;
    }
    for (var g in gList.entries) {
      for (var rule in g.value.policy) {
        buffer.write('${g.key},');
        buffer.writeln(rule.join(','));
      }
    }

    await File(filePath).writeAsString(buffer.toString().trim());
    return;
  }

  @override
  Future<void> addPolicy(String sec, String ptype, List<String> rule) {
    throw UnimplementedError();
  }

  @override
  Future<void> removePolicy(String sec, String ptype, List<String> rule) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeFilteredPolicy(
    String sec,
    String ptype,
    int fieldIndex,
    List<String> fieldValues,
  ) {
    throw UnimplementedError();
  }
}
