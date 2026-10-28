import 'package:elegant_theme/elegant_theme.dart';
import 'package:material_ui/material_ui.dart';

class ThemeDialogWidget extends StatefulWidget {
  const ThemeDialogWidget({super.key});

  static Future<T?> showThemeDialogOf<T>(BuildContext context) {
    final themes = context.elegantTheme.themes;
    if (themes != null) {
      return showModalBottomSheet<T>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => const ThemeDialogWidget(),
      );
    }
    return Future.value();
  }

  @override
  State<ThemeDialogWidget> createState() => _ThemeDialogWidgetState();
}

class _ThemeDialogWidgetState extends State<ThemeDialogWidget> {
  List<ElegantThemeData>? get _themes => context.elegantTheme.themes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final brightness = theme.brightness;
    final themes = _themes ?? const <ElegantThemeData>[];

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 12, 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.palette_rounded,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Theme",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: "Close",
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Light or dark
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: SegmentedButton<Brightness>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: Brightness.light,
                  icon: Icon(Icons.light_mode_rounded),
                  label: Text("Light"),
                ),
                ButtonSegment(
                  value: Brightness.dark,
                  icon: Icon(Icons.dark_mode_rounded),
                  label: Text("Dark"),
                ),
              ],
              selected: {brightness},
              onSelectionChanged: (selection) {
                setState(() {
                  if (selection.first == Brightness.dark) {
                    context.switchToDarkThemeMode();
                  } else {
                    context.switchToLightThemeMode();
                  }
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Text(
              "COLOUR THEME",
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),

          // Theme swatches
          Flexible(
            child: themes.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      "No themes available",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          mainAxisExtent: 78,
                        ),
                    itemCount: themes.length,
                    itemBuilder: (context, index) {
                      final item = themes[index];
                      // Preview the theme in the mode that is showing now.
                      final preview =
                          (brightness == Brightness.dark
                                  ? item.dark
                                  : item.light)
                              .colorScheme;
                      final selected =
                          preview.primary == scheme.primary &&
                          preview.secondary == scheme.secondary;

                      return _ThemeSwatch(
                        name: item.name,
                        colors: [
                          preview.primary,
                          preview.secondary,
                          preview.tertiary,
                        ],
                        selected: selected,
                        onTap: () => setState(
                          () => context.setThemeByIndex(index: index),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ThemeSwatch extends StatelessWidget {
  const _ThemeSwatch({
    required this.name,
    required this.colors,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final List<Color> colors;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: selected
          ? scheme.primaryContainer.withValues(alpha: 0.5)
          : scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected
              ? scheme.primary
              : scheme.outlineVariant.withValues(alpha: 0.6),
          width: selected ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  // These colours are the theme being previewed, not this screen's own.
                  for (final color in colors)
                    Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: scheme.outlineVariant),
                      ),
                    ),
                  const Spacer(),
                  if (selected)
                    Icon(
                      Icons.check_circle_rounded,
                      size: 20,
                      color: scheme.primary,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
