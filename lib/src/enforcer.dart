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

import 'core_enforcer.dart';
import 'model/function_map.dart';
import 'persist/adapter.dart';
import 'persist/file_adapter.dart';
import 'model/model.dart';

class Enforcer extends CoreEnforcer {
  /// Initializes an enforcer.
  ///
  /// [model] is a model or the path of the model file.
  /// [policyFile] is the path of the policy file.
  /// [adapter] is the adapter.
  /// [enableLog] whether to enable Casbin's log.
  static final Enforcer _enforcer = Enforcer._();

  factory Enforcer._() => _enforcer;

  Enforcer(String modelPath, String policyFile, Adapter adapter, bool enableLog)
      : super(
          modelPath,
        );

  factory Enforcer.fromModelPathAndPolicyFile(
      String modelPath, String policyFile) {
    _enforcer.modelPath = modelPath;
    final fileAdapter = FileAdapter(policyFile);
    return Enforcer.fromModelPathAndAdapter(modelPath, fileAdapter);
  }

  factory Enforcer.fromModelPathAndAdapter(String modelPath, Adapter adapter) {
    _enforcer.modelPath = modelPath;
    final model = Model();
    model.loadModel(modelPath);
    return Enforcer.fromModelAndAdapter(model, adapter);
  }

  factory Enforcer.fromModelAndAdapter(Model model, Adapter? adapter) {
    _enforcer.model = model;
    _enforcer.fm = FunctionMap.loadFunctionMap();
    if (adapter != null) {
      _enforcer.loadPolicy();
    }
    return _enforcer;
  }

  Model newModel(List<String> text) => Model();
}
