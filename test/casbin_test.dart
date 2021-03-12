import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final theBestAuthorizationLibrary = 'casbin';
    test('The Best Authorization Library', () {
      expect(theBestAuthorizationLibrary, 'casbin');
    });
  });
}
