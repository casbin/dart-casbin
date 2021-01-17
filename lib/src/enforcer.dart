import 'package:casbin/src/core_enforcer.dart';
import 'package:casbin/src/model/function_map.dart';
import 'package:casbin/src/persist/adapter.dart';
import 'package:casbin/src/persist/file_adapter.dart';
import 'package:casbin/src/model/model.dart';

class Enforcer extends CoreEnforcer {
  /// Initializes an enforcer.
  ///
  /// [model] is a model or the path of the model file.
  /// [policyFile] is the path of the policy file.
  /// [adapter] is the adapter.
  /// [enableLog] whether to enable Casbin's log.
  Enforcer(
      {String modelPath, String policyFile, Adapter adapter, bool enableLog})
      : super(
          modelPath: modelPath,
        );

  Enforcer.fromModelPathAndPolicyFile(String modelPath, String policyFile) {
    modelPath = modelPath;
    final fileAdapter = FileAdapter(policyFile);
    Enforcer.fromModelPathAndAdapter(modelPath, fileAdapter);
  }

  Enforcer.fromModelPathAndAdapter(String modelPath, Adapter adapter) {
    modelPath = modelPath;
    final model = Model();
    model.loadModel(modelPath);
    Enforcer.fromModelAndAdapter(model, adapter);
  }

  Enforcer.fromModelAndAdapter(Model model, Adapter adapter) {
    model = model;
    fm = FunctionMap.loadFunctionMap();
    if (adapter != null) {
      loadPolicy();
    }
  }

  Model newModel(List<String> text) => Model();
}
