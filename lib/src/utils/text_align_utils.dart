import 'package:agradiance_mobile_kits/src/extensions/text_align_extension.dart';
import 'package:material_ui/material_ui.dart';

class TextAlignUtils {
  static TextAlign fromMap(Map<String, dynamic> map) {
    return TextAlignExtension.fromMap(map);
  }

  static Map<String, dynamic> toMap(TextAlign textAlign) {
    return textAlign.toMap();
  }
}
