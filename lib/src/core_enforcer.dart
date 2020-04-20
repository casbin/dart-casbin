import 'package:casbin/src/effect/default_effector.dart';
import 'package:casbin/src/effect/effector.dart';
import 'package:casbin/src/model/model.dart';
import 'package:casbin/src/rbac/default_role_manager.dart';
import 'package:casbin/src/rbac/role_manager.dart';

/// Defines the core functionality of an enforcer.
class CoreEnforcer {
  String modelPath;
  Model model;
  Effector _eft;

  RoleManager rm;

  bool _enabled;
  bool autoSave;
  bool autoBuildRoleLinks;

  void initialize() {
    rm = DefaultRoleManager(10);
    _eft = DefaultEffector();

    _enabled = true;
    autoSave = true;
    autoBuildRoleLinks = true;
  }

  /// Creates a model.
  ///
  /// [model] is the model path or the model text.
  static Model newModel([String model = '']) {
    final m = Model();

    if (model == 'path') {
      // todo(KNawm): Check if it's a model file.
      m.loadModel(model);
    } else if (model == 'text') {
      // todo(KNawm): Check if it's a model text.
      m.loadModelFromText(model);
    }

    return m;
  }

  /// Reloads the model from the model CONF file.
  /// Because the policy is attached to a model, so the policy is invalidated
  /// and needs to be reloaded by calling loadPolicy().
  void loadModel() {
    model = newModel();
    model.loadModel(modelPath);
    model.printModel();
  }

  /// Returns the current model.
  Model getModel() {
    return model;
  }

  /// setModel sets the current model.
  ///
  /// [model] is the model.
  void setModel(Model model) {}

  /// Returns the current adapter.
  //Adapter getAdapter() {}

  /// Sets the current adapter.
  ///
  /// [adapter] is the adapter.
  //void setAdapter(Adapter adapter) {}

  /// Sets the current watcher.
  ///
  /// [watcher] is the watcher.
  //void setWatcher(Watcher watcher) {}

  /// Sets the current role manager.
  ///
  /// [rm] is the role manager.
  void setRoleManager(RoleManager rm) {
    this.rm = rm;
  }

  /// Sets the current effector.
  ///
  /// [eft] is the effector.
  void setEffector(Effector eft) {
    _eft = eft;
  }

  /// Clears all policy.
  void clearPolicy() {
    model.clearPolicy();
  }

  /// Reloads the policy from file/database.
  void loadPolicy() {}

  /// Reloads a filtered policy from file/database.
  ///
  /// [filter] is the filter used to specify which type of policy should be loaded.
  void loadFilteredPolicy(Object filter) {}

  /// Returns if the loaded policy has been filtered.
  bool isFiltered() {
    return false;
  }

  /// Saves the current policy (usually after changed with Casbin API) back to file/database.
  void savePolicy() {}

  /// Changes the enforcing state of Casbin, when Casbin is disabled, all access will be allowed by the enforce() function.
  ///
  /// [enable] whether to enable the enforcer.
  void enableEnforce(bool enable) {}

  /// Changes whether to print Casbin log to the standard output.
  ///
  /// [enable] whether to enable Casbin's log.
  void enableLog(bool enable) {}

  /// Controls whether to save a policy rule automatically to the adapter when it is added or removed.
  ///
  /// [autoSave] whether to enable the AutoSave feature.
  void enableAutoSave(bool autoSave) {
    this.autoSave = autoSave;
  }

  /// Controls whether to save a policy rule automatically to the adapter when it is added or removed.
  ///
  /// [autoBuildRoleLinks] whether to automatically build the role links.
  void enableAutoBuildRoleLinks(bool autoBuildRoleLinks) {
    this.autoBuildRoleLinks = autoBuildRoleLinks;
  }

  /// Manually rebuild the role inheritance relations.
  void buildRoleLinks() {
    rm.clear();
    model.buildRoleLinks(rm);
  }

  /// Returns whether a "subject" can access a "object" with the operation "action", input parameters are usually: (sub, obj, act).
  ///
  /// [rvals] the request that needs to be mediated.
  bool enforce(List<String> rvals) {}

  bool validateEnforce(List<String> rvals) {
    return _validateEnforceSection("r", rvals);
  }

  bool _validateEnforceSection(String section, List<String> rvals) {}
}
