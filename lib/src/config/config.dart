// Copyright 2018-2021 The Casbin Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:collection';
import 'dart:io';

/// Defines the behavior of a Config implementation.
abstract class ConfigInterface {
  String getString(String key);

  List<String> getStrings(String key);

  bool getBool(String key);

  int getInt(String key);

  double getFloat(String key);

  void set(String key, String value);
}

class Config implements ConfigInterface {
  static final defaultSection = 'default';
  static final defaultComment = '#';
  static final defaultCommentSem = ';';
  static final defaultMultiLineSeparator = '\\';

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
      section = Config.defaultSection;
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
      var commentPos = element.indexOf(Config.defaultComment);

      if (commentPos > -1) {
        element = element.substring(0, commentPos);
      }

      commentPos = element.indexOf(Config.defaultCommentSem);
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
        if (line.contains(Config.defaultMultiLineSeparator)) {
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

  @override
  String getString(String key) {
    return get(key);
  }

  @override
  List<String> getStrings(String key) {
    return get(key).split(',');
  }

  @override
  bool getBool(String key) {
    return get(key).isNotEmpty;
  }

  @override
  int getInt(String key) {
    return int.parse(get(key));
  }

  @override
  double getFloat(String key) {
    return double.parse(get(key));
  }

  @override
  void set(String key, String value) {
    if (key.isEmpty) {
      throw Exception('key is empty');
    }

    var section = '';
    String option;

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
    String section;
    String option;

    final keys = key.toLowerCase().split('::');

    if (keys.length >= 2) {
      section = keys[0];
      option = keys[1];
    } else {
      section = Config.defaultSection;
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
