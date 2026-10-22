import 'package:agradiance_mobile_kits/src/extensions/offset_extension.dart';
import 'package:material_ui/material_ui.dart';

class OffsetUtils {
  static Offset fromMap(Map<String, dynamic> map) {
    return OffsetExtension.fromMap(map);
  }

  static Map<String, dynamic> toMap(Offset offset) {
    return offset.toMap();
  }
}
