import 'package:collection/collection.dart';
import 'package:material_ui/material_ui.dart';

extension TextAlignExtension on TextAlign {
  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  static TextAlign fromMap(Map<String, dynamic> map) {
    return TextAlign.values.firstWhereOrNull(
          (element) => element.name == map["name"],
        ) ??
        TextAlign.center;
  }
}
