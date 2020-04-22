import 'package:casbin/src/effect/effect.dart';
import 'package:casbin/src/effect/effector.dart';

/// Default effector for Casbin.
class DefaultEffector implements Effector {
  @override
  bool mergeEffects(String expr, List<Effect> effects, List<double> results) {
    var result = false;
    if (expr == 'some(where (p_eft == allow))') {
      result = effects.any((eft) => eft == Effect.Allow);
    } else if (expr == '!some(where (p_eft == deny))') {
      result = !effects.any((eft) => eft == Effect.Deny);
    } else if (expr == 'some(where (p_eft == allow)) && !some(where (p_eft == deny))') {
      if (effects.any((eft) => eft == Effect.Deny)) {
        result = false;
      } else if (effects.any((eft) => eft == Effect.Allow)) {
        result = true;
      }
    } else if (expr == 'priority(p_eft) || deny') {
      for (var eft in effects) {
        if (eft != Effect.Indeterminate) {
          if (eft == Effect.Allow) {
            result = true;
          } else {
            result = false;
          }
          break;
        }
      }
    } else {
      throw UnsupportedError('unsupported effect');
    }

    return result;
  }
}
