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
