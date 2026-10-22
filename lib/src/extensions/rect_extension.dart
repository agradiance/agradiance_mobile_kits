import 'package:material_ui/material_ui.dart';

extension RectExtension on Rect {
  Map<String, dynamic> toMap() {
    return {"left": left, "top": top, "right": right, "bottom": bottom};
  }
}
