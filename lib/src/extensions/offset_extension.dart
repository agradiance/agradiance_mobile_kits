import 'package:material_ui/material_ui.dart';

extension OffsetExtension on Offset {
  Map<String, dynamic> toMap() {
    return {'dx': dx, 'dy': dy};
  }

  static Offset fromMap(Map<String, dynamic> map) {
    return Offset(
      double.tryParse("${(map['dx'] ?? 0)}")?.toDouble() ?? 0,
      double.tryParse("${(map['dy'] ?? 0)}")?.toDouble() ?? 0,
    );
  }
}
