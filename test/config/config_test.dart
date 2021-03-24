import 'package:casbin/src/config/config.dart';
import 'package:test/test.dart';

final config = Config.newConfig('test/config/test.ini');

void main() {
  group('default key tests', () {
    test('debug should be true', () {
      expect(config.get('debug'), equals('true'));
    });

    test('url should be act.wiki', () {
      expect(config.get('url'), equals('act.wiki'));
    });
  });

  group('redis test', () {
    test('redis.key should be "push1,push2"', () {
      expect(config.get('redis::redis.key'), equals('push1,push2'));
    });
  });

  group('mysql::key tests', () {
    test('mysql.dev.host must be "127.0.0.1"', () {
      expect(config.get('mysql::mysql.dev.host'), equals('127.0.0.1'));
    });

    test('mysql.dev.user must be "root"', () {
      expect(config.get('mysql::mysql.dev.user'), equals('root'));
    });

    test('mysql.dev.pass must be "123456"', () {
      expect(config.get('mysql::mysql.dev.pass'), equals('123456'));
    });

    test('mysql.dev.db must be "test"', () {
      expect(config.get('mysql::mysql.dev.db'), equals('test'));
    });

    test('config.get("mysql::mysql.master.host") should be equal to 10.0.0.1',
        () {
      expect(config.get('mysql::mysql.master.host'), equals('10.0.0.1'));
    });

    test('config.get("mysql::mysql.master.user") should be equal to root', () {
      expect(config.get('mysql::mysql.master.user'), equals('root'));
    });

    test('config.get("mysql::mysql.master.pass") should be equal to root', () {
      expect(config.get('mysql::mysql.master.pass'), equals('89dds)2\$'));
    });

    test('config.get("mysql::mysql.master.db") should be equal to root', () {
      expect(config.get('mysql::mysql.master.db'), equals('act'));
    });
  });

  group('math::key tests', () {
    test('math.i64 must be "64"', () {
      expect(config.get('math::math.i64'), equals('64'));
    });

    test('math.f64 must be "64.1"', () {
      expect(config.get('math::math.f64'), equals('64.1'));
    });
  });

  group('other::key tests', () {
    test('other.name must be "ATC自动化测试^-^&(\$"', () {
      expect(config.get('other::name'), equals('ATC自动化测试^-^&(\$'));
    });

    test('other.key1 must be "test key"', () {
      expect(config.get('other::key1'), equals('test key'));
    });
  });

  group('multi-line test', () {
    test(
        'config.get("multi1::name") should be equal to r.sub==p.sub&&r.obj==p.obj',
        () {
      expect(config.get('multi1::name'), equals('r.sub==p.sub&&r.obj==p.obj'));
    });

    test(
        'config.get("multi2::name") should be equal to r.sub==p.sub&&r.obj==p.obj',
        () {
      expect(config.get('multi2::name'), equals('r.sub==p.sub&&r.obj==p.obj'));
    });

    test(
        'config.get("multi3::name") should be equal to r.sub==p.sub&&r.obj==p.obj',
        () {
      expect(config.get('multi3::name'), equals('r.sub==p.sub&&r.obj==p.obj'));
    });

    test(
        'config.get("multi4::name") should be equal to r.sub==p.sub&&r.obj==p.obj',
        () {
      expect(config.get('multi4::name'), equals(''));
    });

    test(
        'config.get("multi5::name") should be equal to r.sub==p.sub&&r.obj==p.obj',
        () {
      expect(config.get('multi5::name'), equals('r.sub==p.sub&&r.obj==p.obj'));
    });

    test('config.get("<any undefined key>") should be equal to empty string',
        () {
      expect(config.get('multi6::name'), equals(''));
    });
  });
}
