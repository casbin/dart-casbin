# [1.4.0](https://github.com/casbin/dart-casbin/compare/v1.3.0...v1.4.0) (2025-11-18)


### Features

* fix CI publish step failing on Dart SDK version mismatch ([#75](https://github.com/casbin/dart-casbin/issues/75)) ([ecf8801](https://github.com/casbin/dart-casbin/commit/ecf88019f02d077140f5dc07e1248c310e20560c))

# [1.3.0](https://github.com/casbin/dart-casbin/compare/v1.2.0...v1.3.0) (2025-11-18)


### Features

* add dart analyze to CI workflow and fix code formats ([#73](https://github.com/casbin/dart-casbin/issues/73)) ([5ea7487](https://github.com/casbin/dart-casbin/commit/5ea7487941ef66e872f4143c3c2bdf2ca6f8e066))

# [1.2.0](https://github.com/casbin/dart-casbin/compare/v1.1.0...v1.2.0) (2025-11-18)


### Features

* fix CI: update SDK constraint to >=3.0.0 for lints compatibility ([#71](https://github.com/casbin/dart-casbin/issues/71)) ([71feb0f](https://github.com/casbin/dart-casbin/commit/71feb0f0d0bf3e73433d9ea4020166f0a6d18d58))

# [1.1.0](https://github.com/casbin/dart-casbin/compare/v1.0.0...v1.1.0) (2025-11-18)


### Features

* fix CI publish failure: remove unnecessary set literals and update SDK constraint ([#69](https://github.com/casbin/dart-casbin/issues/69)) ([3e045a5](https://github.com/casbin/dart-casbin/commit/3e045a56c8320d8bde50dab94f130e264fde57f9))

# [1.0.0](https://github.com/casbin/dart-casbin/compare/v0.2.0...v1.0.0) (2025-11-18)


### Features

* Publish 1.0.0 stable release ([#66](https://github.com/casbin/dart-casbin/issues/66)) ([a0a2742](https://github.com/casbin/dart-casbin/commit/a0a27429b14580df27f986a21c2babf76262c1ef))


### BREAKING CHANGES

* Promoting to 1.0.0 stable release

# [0.2.0](https://github.com/casbin/dart-casbin/compare/v0.1.0...v0.2.0) (2025-11-18)


### Bug Fixes

* fix broken links ([#56](https://github.com/casbin/dart-casbin/issues/56)) ([9c72f3f](https://github.com/casbin/dart-casbin/commit/9c72f3f5839d8cfbb456543a81891dc8c8556137))


### Features

* fix CI failure: replace deprecated cedx/setup-dart with dart-lang/setup-dart ([#65](https://github.com/casbin/dart-casbin/issues/65)) ([c1fb01b](https://github.com/casbin/dart-casbin/commit/c1fb01bbe61e056130952b6cbf3ed57cca9339d1))
* fix CI workflow stuck in queue due to deprecated ubuntu-20.04 runners ([7a2096a](https://github.com/casbin/dart-casbin/commit/7a2096ae87fb9ee85263d53363c9eff07d80fa4a))

# [0.1.0](https://github.com/casbin/dart-casbin/compare/v0.0.1...v0.1.0) (2021-08-20)


### Bug Fixes

* better error texts in defaultRoleManager ([59b525f](https://github.com/casbin/dart-casbin/commit/59b525f92ac56e99e711986f3db06aa542f34164))
* fix return of enforce method ([0b154ac](https://github.com/casbin/dart-casbin/commit/0b154acca4a63c450ccd4d9871094f8398ed2bf3))
* fixed assertion issue ([480a05e](https://github.com/casbin/dart-casbin/commit/480a05ebf1209411a0a7c517b44beddf85c4fd99))
* fixed exceptions to be more specific ([2ef8b36](https://github.com/casbin/dart-casbin/commit/2ef8b36f496dfb000caf31fcb10ac99f76cd9c00))
* fixed suggested changes ([8f9048b](https://github.com/casbin/dart-casbin/commit/8f9048b4b1eab8d4c503763eb38fcef1a8236fe4))


### Features

* added classes and methods to load model from CONF file ([411d7bf](https://github.com/casbin/dart-casbin/commit/411d7bf7af9ed87466319be86ef516d4b180315c))
* added github actions for analysing code and running test on PR and pushes ([66cf631](https://github.com/casbin/dart-casbin/commit/66cf6315c8b006a805066a05cbb11e17c9adeede))
* added license text in all dart files ([c4135fe](https://github.com/casbin/dart-casbin/commit/c4135fe6054652411cc926f2e0dce3fbccfd3091))
* added license text to new files ([a9e6ee9](https://github.com/casbin/dart-casbin/commit/a9e6ee9b42c5a977175e9392d09ef5a32477ffef))
* added missing methods to enforcer apis ([858f8d7](https://github.com/casbin/dart-casbin/commit/858f8d7586b972eab542ce9c655782db5b1f0af0))
* added missing methods to model module ([106b363](https://github.com/casbin/dart-casbin/commit/106b3638b142de2d072d79e6f0c7b3dab46a8028))
* added more methods to enforcer ([664af28](https://github.com/casbin/dart-casbin/commit/664af280490518f44b370698cadfe4ed3e0006ec))
* added required methods to enforcer apis ([8867283](https://github.com/casbin/dart-casbin/commit/88672837cca47d706f53ebc7bdcbf8963f2f2f06))
* added support for abac and added tests ([6ea535d](https://github.com/casbin/dart-casbin/commit/6ea535d0fe104a4b63de2f8031b5364c04b81507))
* added tests for enforcer and management api ([596d604](https://github.com/casbin/dart-casbin/commit/596d6049643ed13dcda9ba6057911c3a6ad85995))
* added tests for logger ([b5333c4](https://github.com/casbin/dart-casbin/commit/b5333c4d40d3835ae4b532fe2ddfc26a0df8a2d3))
* added tests for matcher functions ([6e27cd8](https://github.com/casbin/dart-casbin/commit/6e27cd8edaf8fd34fe9be0f8ade3f344ec80e9a2))
* added tests for matcher functions ([39b4285](https://github.com/casbin/dart-casbin/commit/39b42851ce9d90626fe734dbdc1758c00cf4e8c4))
* exported required files ([bdd612a](https://github.com/casbin/dart-casbin/commit/bdd612aa6ae879c51b4160a9fbfe680c97e908b8))
* fixed small issue and added tests ([bdfaccc](https://github.com/casbin/dart-casbin/commit/bdfaccc00571f37906145b501b800453901d669b))
* Implement config interface ([cb57ee0](https://github.com/casbin/dart-casbin/commit/cb57ee063152e2a42a83c6e53d94856444735283))
* implemented enforce to create minimum working prototype ([2eb8d01](https://github.com/casbin/dart-casbin/commit/2eb8d01962c9e11065156720801e9069626153dd))
* implemented logger ([9af6435](https://github.com/casbin/dart-casbin/commit/9af6435470234233e227b86166f7e8c35213b3da))
* implemented matcher functions - part 1 ([ccb2e1b](https://github.com/casbin/dart-casbin/commit/ccb2e1ba97be14505e49953ed6779adcef90932a))
* implemented methods for enforcer, coreEnforcer and added tests ([6354ab5](https://github.com/casbin/dart-casbin/commit/6354ab592c755613e6c99a70adad8ac091593468))
* implemented missing methods to file adapter ([e9c4568](https://github.com/casbin/dart-casbin/commit/e9c4568645cf05c9872da562c44724f49ad79ff2))
* implemented missing parts of persist module ([4682653](https://github.com/casbin/dart-casbin/commit/46826536c57bcac3fd212e10e7794421e60d136f))
* implemented proper functioning enforce method and added tests for rbac ([#28](https://github.com/casbin/dart-casbin/issues/28)) ([17b498c](https://github.com/casbin/dart-casbin/commit/17b498c7dd94dc10bbbf439099349e44719f5925))
* implemented remaining matcher functions ([316947d](https://github.com/casbin/dart-casbin/commit/316947d5a99611c0e4e4d66d80c3c42fd4ca7443))
* prepared for new release ([#48](https://github.com/casbin/dart-casbin/issues/48)) ([eee526a](https://github.com/casbin/dart-casbin/commit/eee526a7d367510b4a1c75a18f2b561fa6fee25d))
* updated lint rules to prefer relative imports ([438a9fb](https://github.com/casbin/dart-casbin/commit/438a9fb4fa82b284b3d865b38accf7ca8d00d547))
* updated workflow to automate github and pub.dev release ([#47](https://github.com/casbin/dart-casbin/issues/47)) ([e5692df](https://github.com/casbin/dart-casbin/commit/e5692dfe0d7c533596ddb701bfbdcd7fc30fc66f))

## 0.1.0

- All basic features are ready for use.

## 0.0.1

- Initial version.
