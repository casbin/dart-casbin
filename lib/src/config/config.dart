import 'dart:collection';
import 'dart:io';

class Config {
  static final DEFAULT_SECTION = 'default';
  static final DEFAULT_COMMENT = '#';
  static final DEFAULT_COMMENT_SEM = ';';

  // todo(KNawm): Implement synchronization lock

  // Section:key=value
  HashMap<String, Map<String, String>> data = HashMap();

  /// Create an empty configuration representation from file.
  ///
  /// [confName] is the path of the model file.
  static Config newConfig(String confName) {
    var c = Config();
    c.parse(confName);
    return c;
  }

  /// newConfigFromText create an empty configuration representation from text.
  ///
  /// [text] is the model text.
  static Config newConfigFromText(String text) {
    //TODO: Implement after parseBuffer is implemented.
    return Config();
  }

  /// Adds a new section->key:value to the configuration.
  bool addConfig(String section, String option, String value) {
    //TODO: Implement this properly
    return true;
  }

  void parse(String fname) {}

  void parseBuffer(File file) {}

  bool getBool(String key) {
    //TODO: Test after implementation of get method
    return get(key) != '';
  }

  int getInt(String key) {
    //TODO: Test after implementation of get method
    return int.parse(get(key));
  }

  double getFloat(String key) {
    //TODO: Test after implementation of get method
    return double.parse(get(key));
  }

  String getString(String key) {
    //TODO: Test after implementation of get method
    return get(key);
  }

  List<String> getStrings(String key) {
    //TODO: Test after implementation of get method
    return get(key).split(',');
  }

  void set(String key, String value) {}

  String get(String key) {
    //TODO: Implement properly
    return '';
  }
}
