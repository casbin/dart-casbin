enum Effect { Allow, Indeterminate, Deny }

class Effector {
  static bool mergeEffects(
      String expr, List<Effect> effects, List<num> results) {
    bool result = false;
    if (expr == "some(where (p_eft == allow))") {
      result = false;
      effects.forEach((Effect eft) {
        if (eft == Effect.Allow) {
          result = true;
        }
      });
    } else if (expr == "!some(where (p_eft == deny))") {
      result = true;
      effects.forEach((Effect eft) {
        if (eft == Effect.Deny) {
          result = false;
        }
      });
    } else if (expr ==
        "some(where (p_eft == allow)) && !some(where (p_eft == deny))") {
      result = false;
      effects.forEach((Effect eft) {
        if (eft == Effect.Allow) {
          result = true;
        } else if (eft == Effect.Deny) {
          result = false;
        }
      });
    } else if (expr == "priority(p_eft) || deny") {
      result = false;
      effects.forEach((Effect eft) {
        if (eft != Effect.Indeterminate) {
          if (eft == Effect.Allow) {
            result = true;
          } else {
            result = false;
          }
        }
      });
    } else {
      return false;
    }

    return result;
  }
}
