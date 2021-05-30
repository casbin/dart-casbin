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

import '../model/model.dart';
import 'adapter.dart';

class FileAdapter implements Adapter {
  final String filePath;

  FileAdapter(this.filePath);

  @override
  void addPolicy(String sec, String ptype, List<String> rule) {
    // TODO: implement addPolicy
  }

  @override
  void loadPolicy(Model model) {
    if (filePath.isNotEmpty) {
      try {
        var f = File(filePath);
        loadPolicyData(model, loadPolicyLine, f);
      } on IOException {
        throw Exception('invalid file path for policy');
      }
    }
  }

  @override
  void removeFilteredPolicy(
      String sec, String ptype, int fieldIndex, List<String> fieldValues) {
    // TODO: implement removeFilteredPolicy
  }

  @override
  void removePolicy(String sec, String ptype, List<String> rule) {
    // TODO: implement removePolicy
  }

  @override
  void savePolicy(Model model) {
    // TODO: implement savePolicy
  }

  void loadPolicyData(Model model, Function(Model, String) handler, File f) {
    try {
      var lines = f.readAsLinesSync();
      lines.forEach((line) {
        handler(model, line.trim());
      });
    } catch (e) {
      throw Exception('Policy load error: $e');
    }
  }
}

void loadPolicyLine(Model model, String line) {
  if (line.isEmpty || line.startsWith('#')) {
    return;
  }

  line = line.replaceAll(RegExp(r' '), '');

  var tokens = line.split(',').toList();

  var key = tokens.first;
  var sec = key.substring(0, 1);
  model.model[sec]![key]!.policy.add(tokens.sublist(1));
}
