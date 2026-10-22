import 'package:agradiance_mobile_kits/src/extensions/null_extension.dart';
import 'package:material_ui/material_ui.dart';

class CustomStackPlaceholderWidget extends StatelessWidget {
  const CustomStackPlaceholderWidget({
    super.key,
    this.child,
    this.topWidget,
    this.hideTop = false,
    this.hideChild = false,
    this.enableChild = true,
    this.childOpacity = 1,
    this.alignment = AlignmentDirectional.center,
  });

  final Widget? topWidget;
  final Widget? child;
  final bool hideTop;
  final bool hideChild;
  final bool enableChild;
  final double childOpacity;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignment,
      children: [
        IgnorePointer(
          ignoring: !enableChild,
          child: Visibility(
            visible: !hideChild,
            child: Opacity(opacity: childOpacity, child: child),
          ),
        ),
        if (topWidget.isNotNull)
          Visibility(visible: !hideTop, child: topWidget!),
      ],
    );
  }
}
