final evalReg = RegExp(r'\beval\(([^),]*)\)');

bool hasEvalFn(String s) {
  return evalReg.hasMatch(s);
}

List<String> getEvalValue(String s) {
  final submatch = evalReg.allMatches(s);
  final rules = <String>[];

  if (submatch.isEmpty) {
    return [];
  }
  for (var rule in submatch) {
    var startingIndex = rule.group(0)!.indexOf('(');
    var endingIndex = rule.group(0)!.indexOf(')');
    if (endingIndex == -1) {
      endingIndex = rule.group(0)!.length;
    }

    rules.add(rule.group(0)!.substring(startingIndex + 1, endingIndex));
  }
  return rules;
}

String replaceEval(String s, String rule) {
  return s.replaceAll(evalReg, '(' + rule + ')');
}

String arrayToString(List<String> s) {
  return s.join(', ');
}
