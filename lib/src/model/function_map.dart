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

import '../utils/builtin_operators.dart';

class FunctionMap {
  Map<String, Function> functionMap;

  FunctionMap() : functionMap = {};

  void addFunction(String name, Function function) {
    functionMap[name] = function;
  }

  static FunctionMap loadFunctionMap() {
    var fm = FunctionMap();
    fm.functionMap = <String, Function>{};

    fm.addFunction('keyMatch', keyMatch);
    fm.addFunction('keyMatch2', keyMatch2);
    fm.addFunction('keyMatch3', keyMatch3);
    fm.addFunction('keyMatch4', keyMatch4);
    fm.addFunction('keyGet', keyGetFunc);
    fm.addFunction('keyGet2', keyGet2Func);
    fm.addFunction('regexMatch', regexMatch);
    fm.addFunction('globMatch', globMatch);
    // fm.addFunction('ipMatch', ipMatchFunc());

    return fm;
  }
}
