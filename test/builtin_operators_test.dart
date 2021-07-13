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

import 'package:test/test.dart';

import 'utils/test_utils.dart';

void main() {
  group('test regexMatch', () {
    testRegexMatch('test 1', '/topic/create', '/topic/create', true);
    testRegexMatch('test 2', '/topic/create/123', '/topic/create', true);
    testRegexMatch('test 3', '/topic/delete', '/topic/create', false);
    testRegexMatch('test 4', '/topic/edit', '/topic/edit/[0-9]+', false);
    testRegexMatch('test 5', '/topic/edit/123', '/topic/edit/[0-9]+', true);
    testRegexMatch('test 6', '/topic/edit/abc', '/topic/edit/[0-9]+', false);
    testRegexMatch('test 7', '/foo/delete/123', '/topic/delete/[0-9]+', false);
    testRegexMatch('test 8', '/topic/delete/0', '/topic/delete/[0-9]+', true);
    testRegexMatch('test 9', '/topic/edit/123s', '/topic/delete/[0-9]+', false);
  });
  group('test keyMatch Function', () {
    testKeyMatch('test 1', '/foo', '/foo', true);
    testKeyMatch('test 2', '/foo', '/foo*', true);
    testKeyMatch('test 3', '/foo', '/foo/*', false);
    testKeyMatch('test 4', '/foo/bar', '/foo', false);
    testKeyMatch('test 5', '/foo/bar', '/foo*', true);
    testKeyMatch('test 6', '/foo/bar', '/foo/*', true);
    testKeyMatch('test 7', '/foobar', '/foo', false);
    testKeyMatch('test 8', '/foobar', '/foo*', true);
    testKeyMatch('test 9', '/foobar', '/foo/*', false);
  });

  group('test keyMatch2 Function', () {
    testKeyMatch2('test 1', '/foo', '/foo', true);
    testKeyMatch2('test 2', '/foo', '/foo*', true);
    testKeyMatch2('test 3', '/foo', '/foo/*', false);
    testKeyMatch2('test 4', '/foo/bar', '/foo', false);

    // different with KeyMatch.
    testKeyMatch2('test 5', '/foo/bar', '/foo*', false);
    testKeyMatch2('test 6', '/foo/bar', '/foo/*', true);
    testKeyMatch2('test 7', '/foobar', '/foo', false);

    // different with KeyMatch.
    testKeyMatch2('test 8', '/foobar', '/foo*', false);
    testKeyMatch2('test 9', '/foobar', '/foo/*', false);

    testKeyMatch2('test 10', '/', '/:resource', false);
    testKeyMatch2('test 11', '/resource1', '/:resource', true);
    testKeyMatch2('test 12', '/myid', '/:id/using/:resId', false);
    testKeyMatch2('test 13', '/myid/using/myresid', '/:id/using/:resId', true);

    testKeyMatch2('test 14', '/proxy/myid', '/proxy/:id/*', false);
    testKeyMatch2('test 15', '/proxy/myid/', '/proxy/:id/*', true);
    testKeyMatch2('test 16', '/proxy/myid/res', '/proxy/:id/*', true);
    testKeyMatch2('test 17', '/proxy/myid/res/res2', '/proxy/:id/*', true);
    testKeyMatch2('test 18', '/proxy/myid/res/res2/res3', '/proxy/:id/*', true);
    testKeyMatch2('test 19', '/proxy/', '/proxy/:id/*', false);

    testKeyMatch2('test 20', '/alice', '/:id', true);
    testKeyMatch2('test 21', '/alice/all', '/:id/all', true);
    testKeyMatch2('test 22', '/alice', '/:id/all', false);
    testKeyMatch2('test 23', '/alice/all', '/:id', false);

    testKeyMatch2('test 24', '/alice/all', '/:/all', false);
  });

  group('test keyMatch3 Function', () {
    {
      // keyMatch3() is similar with KeyMatch2(), except using "/proxy/{id}" instead of "/proxy/:id".
      testKeyMatch3('test 1', '/foo', '/foo', true);
      testKeyMatch3('test 2', '/foo', '/foo*', true);
      testKeyMatch3('test 3', '/foo', '/foo/*', false);
      testKeyMatch3('test 4', '/foo/bar', '/foo', false);
      testKeyMatch3('test 5', '/foo/bar', '/foo*', false);
      testKeyMatch3('test 6', '/foo/bar', '/foo/*', true);
      testKeyMatch3('test 7', '/foobar', '/foo', false);
      testKeyMatch3('test 8', '/foobar', '/foo*', false);
      testKeyMatch3('test 9', '/foobar', '/foo/*', false);

      testKeyMatch3('test 10', '/', '/{resource}', false);
      testKeyMatch3('test 11', '/resource1', '/{resource}', true);
      testKeyMatch3('test 12', '/myid', '/{id}/using/{resId}', false);
      testKeyMatch3(
          'test 13', '/myid/using/myresid', '/{id}/using/{resId}', true);

      testKeyMatch3('test 14', '/proxy/myid', '/proxy/{id}/*', false);
      testKeyMatch3('test 15', '/proxy/myid/', '/proxy/{id}/*', true);
      testKeyMatch3('test 16', '/proxy/myid/res', '/proxy/{id}/*', true);
      testKeyMatch3('test 17', '/proxy/myid/res/res2', '/proxy/{id}/*', true);
      testKeyMatch3(
          'test 18', '/proxy/myid/res/res2/res3', '/proxy/{id}/*', true);
      testKeyMatch3('test 19', '/proxy/', '/proxy/{id}/*', false);

      testKeyMatch3(
          'test 20', '/myid/using/myresid', '/{id/using/{resId}', false);
    }
  });

  group('test keyGetFunc', () {
    testKeyGet('test 1', '/foo', '/foo', '');
    testKeyGet('test 2', '/foo', '/foo*', '');
    testKeyGet('test 3', '/foo', '/foo/*', '');
    testKeyGet('test 4', '/foo/bar', '/foo', '');
    testKeyGet('test 5', '/foo/bar', '/foo*', '/bar');
    testKeyGet('test 6', '/foo/bar', '/foo/*', 'bar');
    testKeyGet('test 7', '/foobar', '/foo', '');
    testKeyGet('test 8', '/foobar', '/foo*', 'bar');
    testKeyGet('test 9', '/foobar', '/foo/*', '');
  });

  group('test keyGet2Func', () {
    {
      testKeyGet2('test 1', '/foo', '/foo', 'id', '');
      testKeyGet2('test 2', '/foo', '/foo*', 'id', '');
      testKeyGet2('test 3', '/foo', '/foo/*', 'id', '');
      testKeyGet2('test 4', '/foo/bar', '/foo', 'id', '');
      testKeyGet2(
          'test 5', '/foo/bar', '/foo*', 'id', ''); // different with KeyMatch.
      testKeyGet2('test 6', '/foo/bar', '/foo/*', 'id', '');
      testKeyGet2('test 7', '/foobar', '/foo', 'id', '');
      testKeyGet2(
          'test 8', '/foobar', '/foo*', 'id', ''); // different with KeyMatch.
      testKeyGet2('test 9', '/foobar', '/foo/*', 'id', '');

      testKeyGet2('test 10', '/', '/:resource', 'resource', '');
      testKeyGet2(
          'test 11', '/resource1', '/:resource', 'resource', 'resource1');
      testKeyGet2('test 12', '/myid', '/:id/using/:resId', 'id', '');
      testKeyGet2(
          'test 13', '/myid/using/myresid', '/:id/using/:resId', 'id', 'myid');
      testKeyGet2('test 14', '/myid/using/myresid', '/:id/using/:resId',
          'resId', 'myresid');

      testKeyGet2('test 15', '/proxy/myid', '/proxy/:id/*', 'id', '');
      testKeyGet2('test 16', '/proxy/myid/', '/proxy/:id/*', 'id', 'myid');
      testKeyGet2('test 17', '/proxy/myid/res', '/proxy/:id/*', 'id', 'myid');
      testKeyGet2(
          'test 18', '/proxy/myid/res/res2', '/proxy/:id/*', 'id', 'myid');
      testKeyGet2(
          'test 19', '/proxy/myid/res/res2/res3', '/proxy/:id/*', 'id', 'myid');
      testKeyGet2('test 20', '/proxy/myid/res/res2/res3', '/proxy/:id/res/*',
          'id', 'myid');
      testKeyGet2('test 21', '/proxy/', '/proxy/:id/*', 'id', '');

      testKeyGet2('test 22', '/alice', '/:id', 'id', 'alice');
      testKeyGet2('test 23', '/alice/all', '/:id/all', 'id', 'alice');
      testKeyGet2('test 24', '/alice', '/:id/all', 'id', '');
      testKeyGet2('test 25', '/alice/all', '/:id', 'id', '');

      testKeyGet2('test 26', '/alice/all', '/:/all', '', '');
    }
  });

  group('test keyMatch4', () {
    testKeyMatch4(
      'test 1',
      '/parent/123/child/123',
      '/parent/{id}/child/{id}',
      true,
    );
    testKeyMatch4(
      'test 2',
      '/parent/123/child/456',
      '/parent/{id}/child/{id}',
      false,
    );

    testKeyMatch4(
      'test 3',
      '/parent/123/child/123',
      '/parent/{id}/child/{another_id}',
      true,
    );
    testKeyMatch4(
      'test 4',
      '/parent/123/child/456',
      '/parent/{id}/child/{another_id}',
      true,
    );

    testKeyMatch4(
      'test 5',
      '/parent/123/child/123/book/123',
      '/parent/{id}/child/{id}/book/{id}',
      true,
    );
    testKeyMatch4(
      'test 6',
      '/parent/123/child/123/book/456',
      '/parent/{id}/child/{id}/book/{id}',
      false,
    );
    testKeyMatch4(
      'test 7',
      '/parent/123/child/456/book/123',
      '/parent/{id}/child/{id}/book/{id}',
      false,
    );
    testKeyMatch4(
      'test 8',
      '/parent/123/child/456/book/',
      '/parent/{id}/child/{id}/book/{id}',
      false,
    );
    testKeyMatch4(
      'test 9',
      '/parent/123/child/456',
      '/parent/{id}/child/{id}/book/{id}',
      false,
    );

    testKeyMatch4(
      'test 10',
      '/parent/123/child/123',
      '/parent/{i/d}/child/{i/d}',
      false,
    );
  });

  group('test allMatch', () {
    testAllMatch('test 1', '*', '/foo', true);
    testAllMatch('test 2', '/foo/*', '/foo', false);
    testAllMatch('test 3', '/foo', '/foo', true);
    testAllMatch('test 4', '/foo/bar', '/foo/*', false);
  });

  group('test globMatch', () {
    testGlobMatch('test 1', '/foo', '/foo', true);
    testGlobMatch('test 2', '/foo', '/foo*', true);
    testGlobMatch('test 3', '/foo', '/foo/*', false);
    testGlobMatch('test 4', '/foo/bar', '/foo', false);
    testGlobMatch('test 5', '/foo/bar', '/foo*', false);
    testGlobMatch('test 6', '/foo/bar', '/foo/*', true);
    testGlobMatch('test 7', '/foobar', '/foo', false);
    testGlobMatch('test 8', '/foobar', '/foo*', true);
    testGlobMatch('test 9', '/foobar', '/foo/*', false);

    testGlobMatch('test 10', '/foo', '*/foo', true);
    testGlobMatch('test 11', '/foo', '*/foo*', true);
    testGlobMatch('test 12', '/foo', '*/foo/*', false);
    testGlobMatch('test 13', '/foo/bar', '*/foo', false);
    testGlobMatch('test 14', '/foo/bar', '*/foo*', false);
    testGlobMatch('test 15', '/foo/bar', '*/foo/*', true);
    testGlobMatch('test 16', '/foobar', '*/foo', false);
    testGlobMatch('test 17', '/foobar', '*/foo*', true);
    testGlobMatch('test 18', '/foobar', '*/foo/*', false);

    testGlobMatch('test 19', '/prefix/foo', '*/foo', false);
    testGlobMatch('test 20', '/prefix/foo', '*/foo*', false);
    testGlobMatch('test 21', '/prefix/foo', '*/foo/*', false);
    testGlobMatch('test 22', '/prefix/foo/bar', '*/foo', false);
    testGlobMatch('test 23', '/prefix/foo/bar', '*/foo*', false);
    testGlobMatch('test 24', '/prefix/foo/bar', '*/foo/*', false);
    testGlobMatch('test 25', '/prefix/foobar', '*/foo', false);
    testGlobMatch('test 26', '/prefix/foobar', '*/foo*', false);
    testGlobMatch('test 27', '/prefix/foobar', '*/foo/*', false);

    testGlobMatch('test 28', '/prefix/subprefix/foo', '*/foo', false);
    testGlobMatch('test 29', '/prefix/subprefix/foo', '*/foo*', false);
    testGlobMatch('test 30', '/prefix/subprefix/foo', '*/foo/*', false);
    testGlobMatch('test 31', '/prefix/subprefix/foo/bar', '*/foo', false);
    testGlobMatch('test 32', '/prefix/subprefix/foo/bar', '*/foo*', false);
    testGlobMatch('test 33', '/prefix/subprefix/foo/bar', '*/foo/*', false);
    testGlobMatch('test 34', '/prefix/subprefix/foobar', '*/foo', false);
    testGlobMatch('test 35', '/prefix/subprefix/foobar', '*/foo*', false);
    testGlobMatch('test 36', '/prefix/subprefix/foobar', '*/foo/*', false);
  });
}
