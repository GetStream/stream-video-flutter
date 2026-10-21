import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';
import 'local_preview.dart';

/// The effects tab of a [StreamModalWindow]: a preview of the local
/// participant and the video effects on offer, under the label "Effects".
///
/// Takes the same arguments as [StreamEffectsSettings], except that the
/// effect in use comes from [selected], read each time the tab is shown. Add
/// it only where the device can apply effects.
class StreamEffectsSettingsTab extends StreamModalWindowTab {
  /// Creates the effects tab.
  ///
  /// [icon] and [label] replace the default icon and "Effects".
  StreamEffectsSettingsTab({
    required Call call,
    List<StreamVideoFilter>? filters,
    List<StreamVideoBackground>? backgrounds,
    required Future<void> Function() onClear,
    ValueGetter<String?>? selected,
    Widget? icon,
    Widget? label,
  }) : super(
         icon: icon ?? const _EffectsTabIcon(),
         label: label ?? const _EffectsTabLabel(),
         builder: (context) => StreamEffectsSettings(
           call: call,
           filters: filters,
           backgrounds: backgrounds,
           onClear: onClear,
           initialSelected: selected?.call(),
         ),
       );
}

class _EffectsTabIcon extends StatelessWidget {
  const _EffectsTabIcon();

  @override
  Widget build(BuildContext context) => Icon(context.streamIcons.blurFill);
}

class _EffectsTabLabel extends StatelessWidget {
  const _EffectsTabLabel();

  @override
  Widget build(BuildContext context) =>
      Text(context.translations.settingsEffectsTab);
}

/// A preview of the local participant over the video effects on offer: a row
/// of [filters] and a grid of [backgrounds].
///
/// The content of [StreamEffectsSettingsTab], and usable on its own.
///
/// Nothing is offered by default: a null list leaves its section out. The
/// row of filters starts with a button that turns effects off through
/// [onClear]. Without filters, selecting the selected background again turns
/// it off instead.
///
/// The selected effect starts as [initialSelected] and moves once an effect's
/// [StreamVideoEffect.onSelected] completes. An id that matches none of the
/// effects on offer leaves every effect unselected, the button to turn effects
/// off included.
class StreamEffectsSettings extends StatefulWidget {
  /// Creates the effects settings.
  const StreamEffectsSettings({
    super.key,
    required this.call,
    this.filters,
    this.backgrounds,
    required this.onClear,
    this.initialSelected,
  });

  /// The call whose local participant is previewed.
  final Call call;

  /// The effects drawn as round icon buttons, such as blurs.
  final List<StreamVideoFilter>? filters;

  /// The backgrounds drawn as image tiles.
  final List<StreamVideoBackground>? backgrounds;

  /// Turns video effects off.
  final Future<void> Function() onClear;

  /// The [StreamVideoEffect.id] of the effect in use when the settings open,
  /// or null for none.
  final String? initialSelected;

  @override
  State<StreamEffectsSettings> createState() => _StreamEffectsSettingsState();
}

class _StreamEffectsSettingsState extends State<StreamEffectsSettings> {
  late String? _selected = widget.initialSelected;

  // Counts selections, so that only the last one to be made moves the
  // selection when several are in flight; one that fails leaves the field to
  // those made before it.
  int _selection = 0;
  int _shownSelection = 0;

  late final _logger = taggedLogger(tag: 'SV:EffectsSettings');

  Future<void> _select(String? id, Future<void> Function() apply) async {
    final selection = ++_selection;
    try {
      await apply();
    } catch (error, stackTrace) {
      _logger.e(() => 'Could not apply the effect $id: $error\n$stackTrace');
      return;
    }
    if (!mounted || selection < _shownSelection) return;
    _shownSelection = selection;
    setState(() => _selected = id);
  }

  void _selectEffect(StreamVideoEffect effect) {
    // Without a button to turn effects off, the selected effect does it.
    if (widget.filters == null && effect.id == _selected) {
      _select(null, widget.onClear);
      return;
    }
    _select(effect.id, effect.onSelected);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final translations = context.translations;
    final filters = widget.filters;
    final backgrounds = widget.backgrounds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: spacing.xxl,
      children: [
        StreamSettingsLocalPreview(call: widget.call),
        if (filters != null || (backgrounds?.isNotEmpty ?? false))
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: spacing.xl,
            children: [
              if (filters != null)
                _Section(
                  heading: translations.effectsSettingsFilters,
                  child: Wrap(
                    spacing: spacing.xxxs,
                    runSpacing: spacing.xxxs,
                    children: [
                      _FilterButton(
                        label: translations.effectsSettingsNone,
                        icon: Icon(context.streamIcons.xmark),
                        selected: _selected == null,
                        onPressed: () => _select(null, widget.onClear),
                      ),
                      for (final filter in filters)
                        _FilterButton(
                          label: filter.label,
                          icon: filter.icon,
                          selected: _selected == filter.id,
                          onPressed: () => _selectEffect(filter),
                        ),
                    ],
                  ),
                ),
              if (backgrounds != null && backgrounds.isNotEmpty)
                _Section(
                  heading: translations.effectsSettingsBackgrounds,
                  child: _BackgroundGrid(
                    backgrounds: backgrounds,
                    selected: _selected,
                    onSelected: _selectEffect,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.heading, required this.child});

  final String heading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: context.streamSpacing.xs,
      children: [
        Text(
          heading,
          style: context.streamTextTheme.headingXs.copyWith(
            color: context.streamColorScheme.textPrimary,
          ),
        ),
        child,
      ],
    );
  }
}

/// A round 40px icon button in a 48px slot, ringed while selected.
class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final Widget icon;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    return Tooltip(
      message: label,
      excludeFromSemantics: true,
      child: Semantics(
        label: label,
        button: true,
        selected: selected,
        child: SizedBox.square(
          dimension: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Material(
                color: colorScheme.backgroundOnElevation,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onPressed,
                  child: SizedBox.square(
                    dimension: 40,
                    child: IconTheme.merge(
                      data: IconThemeData(
                        size: 16,
                        color: colorScheme.textPrimary,
                      ),
                      child: ExcludeSemantics(child: icon),
                    ),
                  ),
                ),
              ),
              if (selected)
                // Drawn over the slot, 2px in from its edge, rather than
                // around the button, so the row doesn't move.
                Positioned.fill(
                  child: IgnorePointer(
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          shape: CircleBorder(
                            side: BorderSide(
                              color: colorScheme.borderActive,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The backgrounds, four to a row.
class _BackgroundGrid extends StatelessWidget {
  const _BackgroundGrid({
    required this.backgrounds,
    required this.selected,
    required this.onSelected,
  });

  static const _columns = 4;

  final List<StreamVideoBackground> backgrounds;
  final String? selected;
  final ValueChanged<StreamVideoBackground> onSelected;

  @override
  Widget build(BuildContext context) {
    final gap = context.streamSpacing.xxxs;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - gap * (_columns - 1)) / _columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final background in backgrounds)
              SizedBox(
                width: width,
                child: _BackgroundTile(
                  background: background,
                  selected: background.id == selected,
                  onPressed: () => onSelected(background),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// An image tile in the design's 112:72, ringed while selected.
class _BackgroundTile extends StatelessWidget {
  const _BackgroundTile({
    required this.background,
    required this.selected,
    required this.onPressed,
  });

  final StreamVideoBackground background;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final radius = context.streamRadius;
    final outer = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(radius.md),
    );

    return Tooltip(
      message: background.label,
      excludeFromSemantics: true,
      child: Semantics(
        label: background.label,
        button: true,
        selected: selected,
        child: AspectRatio(
          aspectRatio: 112 / 72,
          child: Material(
            type: MaterialType.transparency,
            shape: outer,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              customBorder: outer,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  shape: outer.copyWith(
                    side: selected
                        ? BorderSide(
                            color: context.streamColorScheme.borderActive,
                            width: 2,
                          )
                        : BorderSide.none,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(context.streamSpacing.xxs),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(radius.sm),
                    child: Image(image: background.image, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
