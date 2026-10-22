import 'package:agradiance_mobile_kits/agradiance_mobile_kits.dart'
    show NumUtils;
import 'package:agradiance_mobile_kits/src/extensions/rect_extension.dart';
import 'package:material_ui/material_ui.dart' show Rect;

class RectUtils {
  static Rect fromMap(Map<String, dynamic> map) {
    final left = NumUtils.parseOrNullValue(map["left"])?.toDouble();
    final top = NumUtils.parseOrNullValue(map["top"])?.toDouble();
    final right = NumUtils.parseOrNullValue(map["right"])?.toDouble();
    final bottom = NumUtils.parseOrNullValue(map["bottom"])?.toDouble();
    if (left != null || top != null || right != null || bottom != null) {
      return Rect.fromLTRB(left ?? 0, top ?? 0, right ?? 0, bottom ?? 0);
    } else {
      return Rect.zero;
    }
  }

  static Map<String, dynamic> toMap(Rect rect) {
    return rect.toMap();
  }
}
