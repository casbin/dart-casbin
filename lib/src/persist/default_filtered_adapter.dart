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

import '../exception/casbin_adapter_exception.dart';
import '../model/model.dart';
import 'adapter.dart';
import 'file_adapter.dart';
import 'filtered_adapter.dart';
import 'helper.dart';

/// the filter class.
/// Enforcer only accept this filter currently.

class Filter {
  List<String> p;
  List<String> g;

  Filter(this.p, this.g);
}

/// DefaultFilteredAdapter is the _filtered file adapter for Casbin.
/// It can load policy from file or save policy to file and
/// supports loading of _filtered policies.

class DefaultFilteredAdapter implements FilteredAdapter {
  Adapter adapter;
  bool _filtered = true;
  String filepath;

  DefaultFilteredAdapter(this.filepath)
      : adapter = FileAdapter(filepath);

  /// loadFilteredPolicy loads only policy rules that match the filter.
  /// [model] the model.
  /// [filter] the filter used to specify which type of policy should be loaded.
  /// throws [CasbinAdapterException] if the file path or the type of the filter is incorrect.
  @override
  void loadFilteredPolicy(Model model, dynamic filter) {
    if (filepath.isEmpty) {
      throw CasbinAdapterException(
          'Invalid file path, file path cannot be empty.');
    }
    if (filter == null) {
      adapter.loadPolicy(model);
      _filtered = false;
      return;
    }
    if (!(filter.runtimeType == Filter)) {
      throw CasbinAdapterException('Invalid filter type.');
    }
    try {
      loadFilteredPolicyFile(model, filter, Helper.loadPolicyLine);
      _filtered = true;
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace);
    }
  }

  /// loadFilteredPolicyFile loads only policy rules that match the filter from file.

  void loadFilteredPolicyFile(
    Model model,
    Filter filter,
    void Function(Model, String) handler,
  ) {
    try {
      var f = File(filepath);
      var lines = f.readAsLinesSync();
      for (var line in lines) {
        line = line.trim();
        if (filterLine(line, filter)) {
          continue;
        }
        handler(model, line);
      }
    } on IOException {
      throw CasbinAdapterException('Load policy file error');
    }
  }

  /// match the line.

  bool filterLine(String line, Filter? filter) {
    if (filter == null) {
      return false;
    }
    var p = line.split(',');
    if (p.isEmpty) {
      return true;
    }
    var filterSlice = <String>[];
    switch (p[0].trim()) {
      case 'p':
        filterSlice = filter.p;
        break;
      case 'g':
        filterSlice = filter.g;
        break;
    }
    return filterWords(p, filterSlice);
  }

  /// match the words in the specific line.

  bool filterWords(List<String> line, List<String> filter) {
    if (line.length < filter.length + 1) {
      return true;
    }
    var skipLine = false;
    var i = 0;
    for (var s in filter) {
      i++;
      if (s.isNotEmpty && s.trim() != line[i].trim()) {
        skipLine = true;
        break;
      }
    }
    return skipLine;
  }

  /// return true if have any filter roles.

  @override
  bool isFiltered() {
    return _filtered;
  }

  /// loadPolicy loads all policy rules from the storage.

  @override
  void loadPolicy(Model model) {
    adapter.loadPolicy(model);
    _filtered = false;
  }

  /// savePolicy saves all policy rules to the storage.

  @override
  void savePolicy(Model model) {
    adapter.savePolicy(model);
  }

  /// addPolicy adds a policy rule to the storage.

  @override
  void addPolicy(String sec, String ptype, List<String> rule) {
    adapter.addPolicy(sec, ptype, rule);
  }

  /// removePolicy removes a policy rule from the storage.

  @override
  void removePolicy(String sec, String ptype, List<String> rule) {
    adapter.removePolicy(sec, ptype, rule);
  }

  /// removeFilteredPolicy removes policy rules that match the filter from the storage.

  @override
  void removeFilteredPolicy(
      String sec, String ptype, int fieldIndex, List<String> fieldValues) {
    adapter.removeFilteredPolicy(sec, ptype, fieldIndex, fieldValues);
  }
}
