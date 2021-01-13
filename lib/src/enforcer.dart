import 'package:casbin/src/core_enforcer.dart';
import 'package:casbin/src/model/function_map.dart';
import 'package:casbin/src/persist/adapter.dart';
import 'package:casbin/src/persist/file_adapter.dart';

import 'model/model.dart';
import 'model/model.dart';
import 'persist/adapter.dart';

class Enforcer extends CoreEnforcer {
  /// Initializes an enforcer.
  ///
  /// [model] is a model or the path of the model file.
  /// [policyFile] is the path of the policy file.
  /// [adapter] is the adapter.
  /// [enableLog] whether to enable Casbin's log.
  Enforcer(
      {String modelPath,
      Model model,
      String policyFile,
      Adapter adapter,
      bool enableLog})
      : super(
          model: model,
          modelPath: modelPath,
        );

  Enforcer.fromModelPathAndPolicyFile(String modelPath, String policyFile) {
    this.modelPath = modelPath;
    final fileAdapter = FileAdapter(policyFile);
    Enforcer.fromModelPathAndAdapter(modelPath, fileAdapter);
  }

  Enforcer.fromModelPathAndAdapter(String modelPath, Adapter adapter) {
    this.modelPath = modelPath;
    final model = Model();
    model.loadModel(modelPath);
    Enforcer.fromModelAndAdapter(model, adapter);
  }

  Enforcer.fromModelAndAdapter(Model model, Adapter adapter) {
    this.model = model;
    fm = FunctionMap.loadFunctionMap();
    if (adapter != null) {
      loadPolicy();
    }
  }

  Model newModel(List<String> text) => Model();
}
