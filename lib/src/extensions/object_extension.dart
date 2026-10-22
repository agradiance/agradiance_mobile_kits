import 'package:agradiance_mobile_kits/src/utils/general_utilities.dart';

extension RunTypeCompare on Object? {
  bool isTypeCovalentAndAssignable<T>(T? b) {
    return GeneralUtilities.isTypeCovalentAndAssignable(this, b);
  }
}
