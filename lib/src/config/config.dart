import 'dart:io';
import 'dart:convert';

/// This class reads the .conf file to generate model.
class Config {
  final String DEFAULT_SECTION = "default";
  final String DEFAULT_COMMENT = "#";
  final String DEFAULT_COMMENT_SEM = ';';
  final String DEFAULT_MULTILINE_SEPARATOR = '\\';

  Map<String, Map<String, String>> data;

  /// Initialises a empty config
  Config() {
    data = new Map();
  }

  /// Intialises Config object from file
  Config.fromFile(String confName) {
    data = new Map();
    parse(confName);
  }

  /// Initialises Config object from String object.
  Config.fromText(String text) {
    data = new Map();
    parseBuffer(text);
  }

  /// Adds value to a section.
  addConfig(String section, String option, String value) {
    if (section == "") section = DEFAULT_SECTION;
    if (data[section] == null) data[section] = new Map();
    data[section][option] = value;
  }

  parse(String fName) {
    File fFile = new File(fName);
    String text = fFile.readAsStringSync();

    parseBuffer(text);
  }

  parseBuffer(String buf) {
    String section = "";
    String temp = "";
    LineSplitter ls = new LineSplitter();
    bool canWrite = false;

    List<String> buffer = ls.convert(buf);

    buffer.forEach((String line) {
      if (canWrite) {
        write(section, temp);
        temp = "";
        canWrite = false;
      }

      line = line.trim();

      if (line.startsWith(DEFAULT_COMMENT_SEM) ||
          line.startsWith(DEFAULT_COMMENT))
        return;
      else if (line.startsWith("[") && line.endsWith("]")) {
        section = line.substring(1, line.length - 1);
      } else if (line.endsWith(DEFAULT_MULTILINE_SEPARATOR))
        temp += line.substring(0, line.length - 2);
      else {
        temp += line;
        canWrite = true;
      }
    });

    write(section, temp);
  }

  write(String section, String b) {
    if (b == "") return;
    List<String> optionVal = new List<String>();
    int index = 0;

    while(index < b.length) {
      if(b[index] == "=") break;
      index++;
    }   

    optionVal.add(b.substring(0, index)); 
    optionVal.add(b.substring(index+1, b.length));

    String option = optionVal[0].trim();
    String value = optionVal[1].trim();

    addConfig(section, option, value);
  }

  /// Sets the config data specified by the key value.
  set(String key, String value) {
    String section;
    String option;

    List<String> keys = key.split("::");
    if (keys.length >= 2) {
      section = keys[0];
      option = keys[1];
    } else
      option = keys[0];

    addConfig(section, option, value);
  }

  get(String key) {
    String section;
    String option;

    List<String> keys = key.split("::");
    if (keys.length >= 2) {
      section = keys[0];
      option = keys[1];
    } else
      option = keys[0];

    String value = data[section][option];

    return value;
  }
}
