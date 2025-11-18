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
import '../utils/utils.dart';
import 'adapter.dart';
import 'helper.dart';

class FileAdapter implements Adapter {
  final String filePath;

  FileAdapter(this.filePath);

  @override
  void loadPolicy(Model model) {
    if (filePath.isNotEmpty) {
      try {
        var f = File(filePath);
        loadPolicyData(model, Helper.loadPolicyLine, f);
      } on IOException {
        throw FileSystemException('invalid file path for policy');
      }
    }
  }

  @override
  void savePolicy(Model model) {
    if (filePath.isEmpty) {
      throw FileSystemException('invalid file path, file path cannot be empty');
    }
    var result = '';

    final pList = model.model['p'];

    if (pList != null) {
      for (var n in pList.values) {
        for (var m in n.policy) {
          result += '${n.key}, ';
          result += arrayToString(m);
          result += '\n';
        }
      }
    }

    final gList = model.model['g'];

    if (gList != null) {
      for (var n in gList.values) {
        for (var m in n.policy) {
          result += '${n.key}, ';
          result += arrayToString(m);
          result += '\n';
        }
      }
    }

    savePolicyFile(result.trim());
  }

  void savePolicyFile(String text) {
    final file = File(filePath);
    file.writeAsStringSync(text);
  }

  void loadPolicyData(Model model, Function(Model, String) handler, File f) {
    try {
      var lines = f.readAsLinesSync();
      for (var line in lines) {
        handler(model, line.trim());
      }
    } catch (e) {
      throw FileSystemException('Policy load error: $e');
    }
  }

  @override
  void addPolicy(String sec, String ptype, List<String> rule) {
    throw UnsupportedError('not implemented');
  }

  @override
  void removeFilteredPolicy(
      String sec, String ptype, int fieldIndex, List<String> fieldValues) {
    throw UnsupportedError('not implemented');
  }

  @override
  void removePolicy(String sec, String ptype, List<String> rule) {
    throw UnsupportedError('not implemented');
  }
}
