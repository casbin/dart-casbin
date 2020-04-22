import 'package:test/test.dart';
import 'package:casbindart/src/config/config.dart';

void main() {
  test('Config Default Constructor', () {
    Config config = new Config();
    config.addConfig("", "r", "sub, obj, act");

    expect(config.get("default::r"), equals("sub, obj, act"));
  });

  test('Config from File Constructor', () {
    Config config = new Config.fromFile("examples/basic_model.conf");

    expect(config.get("policy_definition::p"), equals("sub, obj, act"));
    expect(config.get("matchers::m"),
        equals("r.sub == p.sub && r.obj == p.obj && r.act == p.act"));
  });

  test('Config from Text Constructor', () {
    Config config = new Config.fromText(''' [request_definition]
r = sub, obj, act
[policy_definition]
p = sub, obj, act
[policy_effect]
e = some(where (p.eft == allow))
[matchers]
m = r.sub == p.sub && r.obj == p.obj && r.act == p.act
''');

    expect(config.get("policy_definition::p"), equals("sub, obj, act"));
    expect(config.get("matchers::m"),
        equals("r.sub == p.sub && r.obj == p.obj && r.act == p.act"));
  });
}
