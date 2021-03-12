import 'package:casbin/src/model/model.dart';
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
    // TODO: implement loadPolicy
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
}
