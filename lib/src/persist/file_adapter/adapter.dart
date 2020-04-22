import 'package:casbindart/src/persist/adapter.dart';

/// This class reads policy from CSV
class FileAdapter extends Adapter {
  String filePath;

  FileAdapter(this.filePath);

  void loadPolicy() {
    if (this.filePath == "") return;
    return super.loadPolicyLine("");
  }

  @override
  void addPolicy(String sec, String ptype, List<String> rule) {
    // TODO: implement addPolicy
  }

  @override
  void removeFilteredPolicy(String sec, String ptype, int fieldIndex, List<String> fieldValues) {
    // TODO: implement removeFilteredPolicy
  }

  @override
  void removePolicy(String sec, String ptype, List<String> rule) {
    // TODO: implement removePolicy
  }

  @override
  void savePolicy() {
    // TODO: implement savePolicy
  }
  
}
