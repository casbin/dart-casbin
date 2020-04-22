abstract class Adapter {
  void loadPolicy();
  void savePolicy();
  void addPolicy(String sec, String ptype, List<String> rule);
  void removePolicy(String sec, String ptype, List<String> rule);
  void removeFilteredPolicy(String sec, String ptype, int fieldIndex, List<String> fieldValues);
  void loadPolicyLine(String line) {
    
  }
}