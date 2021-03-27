import 'dart:collection';
import 'dart:io';

class Config {
  static final DEFAULT_SECTION = 'default';
  static final DEFAULT_COMMENT = '#';
  static final DEFAULT_COMMENT_SEM = ';';
  static final DEFAULT_MULTI_LINE_SEPARATOR = '\\';

  // todo(KNawm): Implement synchronization lock

  // Section:key=value
  HashMap<String, HashMap<String, String>> data = HashMap();

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
    final config = Config();
    final buf = StringBuffer();

    buf.write(text);
    config.parseBuffer(buf);

    return config;
  }

  /// Adds a new section->key:value to the configuration.
  bool addConfig(String section, String option, String value) {
    if (section == '') {
      section = Config.DEFAULT_SECTION;
    }
    final hasKey = data.containsKey(section);

    if (!hasKey) {
      data[section] = HashMap();
    }

    final item = data[section];
    if (item != null) {
      item[option] = value;
      return item.containsKey(option);
    } else {
      return false;
    }
  }

  void parse(String path) {
    final buf = StringBuffer();
    buf.write(File(path).readAsStringSync());
    parseBuffer(buf);
  }

  void parseBuffer(StringBuffer buf) {
    final lines = buf.toString().split('\n');

    final linesCount = lines.length;
    var section = '';
    var currentLine = '';

    lines.asMap().forEach((index, element) {
      var commentPos = element.indexOf(Config.DEFAULT_COMMENT);

      if (commentPos > -1) {
        element = element.substring(0, commentPos);
      }

      commentPos = element.indexOf(Config.DEFAULT_COMMENT_SEM);
      if (commentPos > -1) {
        element = element.substring(0, commentPos);
      }

      final line = element.trim();
      if (line.isEmpty) {
        return;
      }

      final lineNumber = index + 1;

      if (line.startsWith('[') && line.endsWith(']')) {
        if (currentLine.isNotEmpty) {
          write(section, lineNumber - 1, currentLine);
          currentLine = '';
        }
        section = line.substring(1, line.length - 1);
      } else {
        var shouldWrite = false;
        if (line.contains(Config.DEFAULT_MULTI_LINE_SEPARATOR)) {
          currentLine += line.substring(0, line.length - 1).trim();
        } else {
          currentLine += line;
          shouldWrite = true;
        }
        if (shouldWrite || lineNumber == linesCount) {
          write(section, lineNumber, currentLine);
          currentLine = '';
        }
      }
    });
  }

  void write(String section, int lineNum, String line) {
    final equalIndex = line.indexOf('=');

    if (equalIndex == -1) {
      throw Exception('parse the content error : line $lineNum');
    }
    final key = line.substring(0, equalIndex);
    final value = line.substring(equalIndex + 1);

    addConfig(section, key.trim(), value.trim());
  }

  bool getBool(String key) {
    return get(key).isNotEmpty;
  }

  int getInt(String key) {
    return int.parse(get(key));
  }

  double getFloat(String key) {
    return double.parse(get(key));
  }

  String getString(String key) {
    return get(key);
  }

  List<String> getStrings(String key) {
    return get(key).split(',');
  }

  void set(String key, String value) {
    if (key.isEmpty) {
      throw Exception('key is empty');
    }

    var section = '';
    var option;

    final keys = key.toLowerCase().split('::');

    if (keys.length >= 2) {
      section = keys[0];
      option = keys[1];
    } else {
      option = keys[0];
    }

    addConfig(section, option, value);
  }

  String get(String key) {
    var section;
    var option;

    final keys = key.toLowerCase().split('::');

    if (keys.length >= 2) {
      section = keys[0];
      option = keys[1];
    } else {
      section = Config.DEFAULT_SECTION;
      option = keys[0];
    }

    final item = data[section];
    if (item != null) {
      return item[option] ?? '';
    } else {
      return '';
    }
  }
}
