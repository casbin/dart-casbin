import 'dart:collection';
import 'dart:io';

class Config {
  static final DEFAULT_SECTION = 'default';
  static final DEFAULT_COMMENT = '#';
  static final DEFAULT_COMMENT_SEM = ';';

  // todo(KNawm): Implement synchronization lock

  // Section:key=value
  HashMap<String, Map<String, String>> data;

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
  static Config newConfigFromText(String text) {}

  /// Adds a new section->key:value to the configuration.
  bool addConfig(String section, String option, String value) {}

  void parse(String fname) {}

  void parseBuffer(File file) {}

  bool getBool(String key) {}

  int getInt(String key) {}

  double getFloat(String key) {}

  String getString(String key) {}

  List<String> getStrings(String key) {}

  void set(String key, String value) {}

  String get(String key) {}
}
