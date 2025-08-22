//====================================================================================================
// Copyright (C) 2016-present ShIroRRen <http://shiror.ren>.                                         =
//                                                                                                   =
// Part of the NGA project.                                                                          =
// Licensed under the F2DLPR License.                                                                =
//                                                                                                   =
// YOU MAY NOT USE THIS FILE EXCEPT IN COMPLIANCE WITH THE LICENSE.                                  =
// Provided "AS IS", WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,                                   =
// unless required by applicable law or agreed to in writing.                                        =
//                                                                                                   =
// For the NGA project, visit: <http://app.niggergo.work>.                                           =
// For the F2DLPR License terms and conditions, visit: <http://license.fileto.download>.             =
//====================================================================================================

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:system_theme/system_theme.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:window_manager/window_manager.dart';

import '../ext.dart';
import '../tool.dart';

class CUHeadLabel extends StatelessWidget {
  const CUHeadLabel(
    this.label, {
    final Key? key,
    this.color,
    this.left = CUWidget.leftPadding,
    this.top = CUWidget.topPadding,
    this.right = CUWidget.rightPadding,
    this.bottom = CUWidget.bottomPadding,
  }) : super(key: key);
  final String label;
  final Color? color;
  final double left, top, right, bottom;
  @override
  Widget build(final ctx) => Padding(
        padding: EdgeInsets.fromLTRB(left, top, right, bottom),
        child: SizedBox(
          width: double.infinity,
          child: ValueListenableBuilder(
            valueListenable: CUWidget.themeColor,
            builder: (final _, final Color dfltCl, final __) => Text(
              label,
              style: TextStyle(
                color: color ?? dfltCl,
              ),
            ),
          ),
        ),
      );
}

class _CUBaseCard extends StatelessWidget {
  const _CUBaseCard(
    this.child, {
    required this.padding,
    required this.outPadding,
    required this.onTap,
    required this.color,
    required this.tip,
    required this.radius,
    required this.allPadding,
    required this.limitHeight,
    final Key? key,
  }) : super(key: key);
  final Widget child;
  final double padding, outPadding;
  final VoidCallback? onTap;
  final Color? color;
  final String tip;
  final BorderRadius? radius;
  final bool allPadding, limitHeight;
  @override
  Widget build(final ctx) => Padding(
        padding: EdgeInsets.symmetric(horizontal: outPadding),
        child: Material(
          color: color ??
              (MediaQuery.of(ctx).platformBrightness == Brightness.light
                  ? CUWidget.white
                  : CUWidget.black),
          borderRadius: radius ?? CUWidget.radius,
          child: Container(
            constraints: limitHeight ? const BoxConstraints(minHeight: CUWidget.height) : null,
            padding: allPadding ? EdgeInsets.all(padding) : null,
            decoration: BoxDecoration(
              borderRadius: radius ?? CUWidget.radius,
            ),
            child: child,
          )
              .let(
                (final widget) => onTap == null
                    ? widget
                    : InkWell(onTap: onTap, borderRadius: radius ?? CUWidget.radius, child: widget),
              )
              .let((final widget) => tip.isEmpty ? widget : Tooltip(message: tip, child: widget)),
        ),
      );
}

class CUCard extends _CUBaseCard {
  const CUCard(
    final Widget child, {
    final Key? key,
    final double padding = 10,
    final double outPadding = CUWidget.outPadding,
    final VoidCallback? onTap,
    final Color? color,
    final String tip = '',
    final BorderRadius? radius,
  }) : super(
          child,
          key: key,
          padding: padding,
          outPadding: outPadding,
          onTap: onTap,
          color: color,
          tip: tip,
          radius: radius,
          allPadding: true,
          limitHeight: false,
        );
}

class CUProCard extends StatelessWidget {
  const CUProCard(
    this.title, {
    final Key? key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.padding = CUWidget.padding,
    this.outPadding = CUWidget.outPadding,
    this.onTap,
    this.color,
    this.tip = '',
    this.radius,
  }) : super(key: key);
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final double padding;
  final double outPadding;
  final VoidCallback? onTap;
  final Color? color;
  final String tip;
  final BorderRadius? radius;

  @override
  Widget build(final context) => _CUBaseCard(
        Row(
          children: [
            SizedBox(width: padding),
            if (leading != null) ...[
              DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyMedium ??
                    Theme.of(context).listTileTheme.leadingAndTrailingTextStyle ??
                    const ListTileThemeData().leadingAndTrailingTextStyle ??
                    const TextStyle(),
                child: leading!,
              ),
              const SizedBox(width: 20),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: padding / 2),
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyMedium ??
                        Theme.of(context).listTileTheme.titleTextStyle ??
                        const ListTileThemeData().titleTextStyle ??
                        const TextStyle(),
                    child: title,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.bodySmall ??
                          Theme.of(context).listTileTheme.subtitleTextStyle ??
                          const ListTileThemeData().subtitleTextStyle ??
                          const TextStyle(),
                      child: subtitle!,
                    ),
                  ],
                  SizedBox(height: padding / 2),
                ],
              ),
            ),
            DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyMedium ??
                  Theme.of(context).listTileTheme.leadingAndTrailingTextStyle ??
                  const ListTileThemeData().leadingAndTrailingTextStyle ??
                  const TextStyle(),
              child: trailing ?? (onTap != null ? CUWidget.arrowForward : const SizedBox.shrink()),
            ),
            SizedBox(width: padding),
          ],
        ),
        padding: padding,
        outPadding: outPadding,
        onTap: onTap,
        color: color,
        tip: tip,
        radius: radius,
        allPadding: false,
        limitHeight: true,
      );
}

class CUTopBar extends StatelessWidget implements PreferredSizeWidget {
  const CUTopBar({final Key? key, this.leading, this.icon, this.title, this.actions}) : super(key: key);
  final Widget? leading, icon, title;
  final List<Widget>? actions;
  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override
  Widget build(final ctx) => ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AppBar(
            backgroundColor: Theme.of(ctx).colorScheme.surface.withAlpha(22),
            elevation: 0,
            scrolledUnderElevation: 0,
            titleSpacing: 24,
            leading: leading,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: 16),
                ],
                if (title != null) title!,
              ],
            ),
            actions: [
              if (actions != null) ...actions!,
              if (NGATool.isDesktop)
                const SizedBox(
                  width: 138,
                  height: 60,
                  child: WindowCaption(backgroundColor: Colors.transparent),
                ),
            ],
          ),
        ),
      ).let(
        (final widget) => NGATool.isDesktop
            ? DragToMoveArea(
                child: widget,
              )
            : widget,
      );
}

class CUNavBarGroup {
  CUNavBarGroup({required this.name, required this.sub});

  final String name;
  final List<CUNavBarGroupSub> sub;
}

class CUNavBarGroupSub {
  CUNavBarGroupSub(
      {required this.icon, required this.name, required this.page, this.can, this.whyCannot});

  final IconData icon;
  final String name;
  final Widget page;
  ValueNotifier<bool>? can;
  final String? whyCannot;
}

class CUNavBar extends StatelessWidget {
  CUNavBar({
    required this.groups,
    required this.constGroups,
    required this.index,
    final Key? key,
    this.onChange,
    this.onBack,
    this.maxHeight,
    this.duration,
  }) : super(key: key) {
    for (final groups in [groups, constGroups]) {
      groups.forEach((final CUNavBarGroup group) {
        group.sub.forEach((final sub) => sub.can == null ? sub.can = ValueNotifier(true) : true);
        _allSubs.addAll(group.sub);
      });
    }
    _miniKeys.addAll(List<GlobalKey>.generate(_allSubs.length, (final _) => GlobalKey()));
    _fullKeys.addAll(List<GlobalKey>.generate(_allSubs.length, (final _) => GlobalKey()));
  }

  final Duration? duration;
  final double? maxHeight;
  final List<CUNavBarGroup> groups, constGroups;
  final _history = ValueNotifier<List<int>>([]);
  final ValueNotifier<int> index;
  final void Function(int)? onChange, onBack;
  final List<GlobalKey> _miniKeys = [], _fullKeys = [];
  final List<CUNavBarGroupSub> _allSubs = [];

  @override
  Widget build(final ctx) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: CUCard(
              Container(
                constraints: BoxConstraints(maxHeight: maxHeight ?? MediaQuery.of(ctx).size.height / 2.5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => WidgetsBinding.instance.addPostFrameCallback((final _) {
                        var pos = -(MediaQuery.of(ctx).size.width > MediaQuery.of(ctx).size.height
                            ? MediaQuery.of(ctx).size.width / 3
                            : MediaQuery.of(ctx).size.width * 0.75);
                        OverlayEntry? overlayEntry;
                        overlayEntry = OverlayEntry(
                          builder: (final context) => Stack(
                            children: [
                              GestureDetector(
                                onTap: () => overlayEntry?.remove(),
                                child: Container(color: Colors.black.withAlpha(127)),
                              ),
                              AnimatedPositioned(
                                duration: duration ?? const Duration(milliseconds: 150),
                                left: pos,
                                top: 0,
                                bottom: 0,
                                child: SafeArea(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width >
                                              MediaQuery.of(context).size.height
                                          ? MediaQuery.of(context).size.width / 3
                                          : MediaQuery.of(context).size.width * 0.75,
                                      child: CUCard(
                                        ((final List<CUNavBarGroup> target) => target
                                            .map(
                                              (final group) => Column(
                                                children: [
                                                  if (group.name.isNotEmpty)
                                                    CUHeadLabel(group.name,
                                                        left: CUWidget.lessLeftPadding),
                                                  CUCard(
                                                    Column(
                                                      children: group.sub.map((final sub) {
                                                        final targetIndex = _allSubs.indexOf(sub);
                                                        final can = sub.can!;
                                                        return SizedBox(
                                                          key: _fullKeys[targetIndex],
                                                          child: AnimatedBuilder(
                                                            animation: Listenable.merge(
                                                              [index, can, CUWidget.themeColor],
                                                            ),
                                                            builder: (final _, final __) => AbsorbPointer(
                                                              absorbing: !can.value,
                                                              child: CUProCard(
                                                                Text(sub.name),
                                                                leading: Icon(
                                                                  sub.icon,
                                                                  color: index.value == targetIndex
                                                                      ? CUWidget.themeColor.value
                                                                      : can.value
                                                                          ? null
                                                                          : Colors.grey,
                                                                ),
                                                                subtitle:
                                                                    !can.value && sub.whyCannot != null
                                                                        ? Text(sub.whyCannot!)
                                                                        : null,
                                                                onTap: () {
                                                                  _history.value.add(targetIndex);
                                                                  _history.value =
                                                                      _history.value.toList();
                                                                  index.value = targetIndex;
                                                                  onChange?.call(targetIndex);
                                                                  overlayEntry?.remove();
                                                                },
                                                                outPadding: 0,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                    padding: 0,
                                                    outPadding: 5,
                                                  ),
                                                ],
                                              ),
                                            )
                                            .toList()).let(
                                          (final func) => Column(
                                            children: [
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  child: Column(children: func(groups)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context).size.height * 0.25,
                                                child: SingleChildScrollView(
                                                  child: Column(children: func(constGroups)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        outPadding: 0,
                                        color: Theme.of(context).colorScheme.surface,
                                        radius: const BorderRadius.only(
                                          topRight: Radius.circular(CUWidget.radiusNum),
                                          bottomRight: Radius.circular(CUWidget.radiusNum),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                        Overlay.of(ctx).insert(overlayEntry);
                        Future<void>.delayed(
                          const Duration(milliseconds: 50),
                          () => WidgetsBinding.instance.addPostFrameCallback((final _) {
                            pos = 0;
                            overlayEntry?.markNeedsBuild();
                            Scrollable.ensureVisible(
                              _fullKeys[index.value].currentContext!,
                              duration: duration ?? const Duration(milliseconds: 150),
                              alignment: 0.5,
                            );
                          }),
                        );
                      }),
                      icon: const Icon(Icons.menu),
                      tooltip: MaterialLocalizations.of(ctx).showMenuTooltip,
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: _allSubs
                              .asMap()
                              .entries
                              .map(
                                (final entry) => SizedBox(
                                  key: _miniKeys[entry.key],
                                  child: AnimatedBuilder(
                                    animation:
                                        Listenable.merge([index, entry.value.can, CUWidget.themeColor]),
                                    builder: (final _, final __) {
                                      if (index.value == entry.key)
                                        WidgetsBinding.instance.addPostFrameCallback((final _) {
                                          Scrollable.ensureVisible(
                                            _miniKeys[entry.key].currentContext!,
                                            duration: duration ?? const Duration(milliseconds: 150),
                                            alignment: 0.5,
                                          );
                                        });
                                      return AbsorbPointer(
                                        absorbing: !entry.value.can!.value,
                                        child: IconButton(
                                          onPressed: () =>
                                              WidgetsBinding.instance.addPostFrameCallback((final _) {
                                            _history.value.add(entry.key);
                                            _history.value = _history.value.toList();
                                            index.value = entry.key;
                                            onChange?.call(entry.key);
                                          }),
                                          icon: Icon(
                                            entry.value.icon,
                                            color: entry.value.can!.value ? null : Colors.grey,
                                          ),
                                          tooltip: entry.value.name,
                                          color:
                                              index.value == entry.key ? CUWidget.themeColor.value : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _history,
                      builder: (final _, final List<int> value, final __) => AbsorbPointer(
                        absorbing: value.isEmpty,
                        child: IconButton(
                          onPressed: () => WidgetsBinding.instance.addPostFrameCallback((final _) {
                            if (value.isNotEmpty) value.removeLast();
                            index.value = value.isNotEmpty ? value.last : 0;
                            _history.value = value.toList();
                            onBack?.call(index.value);
                          }),
                          icon: Icon(Icons.arrow_back, color: value.isEmpty ? Colors.grey : null),
                          tooltip: MaterialLocalizations.of(ctx).backButtonTooltip,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              padding: 5,
              outPadding: 0,
              radius: const BorderRadius.only(topRight: Radius.circular(CUWidget.radiusNum)),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: index,
              builder: (final _, final int value, final __) => _allSubs.isEmpty
                  ? const SizedBox.shrink()
                  : AnimatedSwitcher(
                      duration: duration ?? const Duration(milliseconds: 150),
                      child: SizedBox(key: ValueKey(value), child: _allSubs[value].page),
                    ),
            ),
          ),
        ],
      );
}

class CUTxtButton extends StatelessWidget {
  const CUTxtButton(this.txt, this.onTap, {final Key? key, this.intrinsic = false, this.tip = ''})
      : super(key: key);
  final Widget txt;
  final VoidCallback onTap;
  final bool intrinsic;
  final String tip;
  @override
  Widget build(final ctx) => Material(
        color: Colors.grey.withAlpha(22),
        borderRadius: CUWidget.radius,
        child: Tooltip(
          message: tip,
          child: InkWell(
            onTap: onTap,
            borderRadius: CUWidget.radius,
            child: intrinsic
                ? IntrinsicWidth(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: CUWidget.radius,
                      ),
                      child: Center(child: txt),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: CUWidget.radius,
                    ),
                    child: Center(child: txt),
                  ),
          ),
        ),
      );
}

class CUWidget extends StatelessWidget {
  const CUWidget(this.child, {final Key? key}) : super(key: key);

  static final _themeColor = ValueNotifier(red);
  static var _themeColorListener = false;
  static ValueNotifier<Color> get themeColor {
    if (!kIsWasm && !kIsWeb && !_themeColorListener) {
      SystemTheme.fallbackColor = red;
      SystemTheme.accentColor.load().then((final _) {
        _themeColor.value = SystemTheme.accentColor.accent.withAlpha(255);
        SystemTheme.onChange.listen(
          (final _) => _themeColor.value = SystemTheme.accentColor.accent.withAlpha(255),
        );
      });
      _themeColorListener = true;
    }
    return _themeColor;
  }

  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF202020);
  static const yellow = Color(0xFFD9C1A9);
  static const purple = Color(0xFF5746A6);
  static const red = Color(0xFFC8372C);
  static const padding = 22.5;
  static const outPadding = 20.0;
  static const leftPadding = 42.5;
  static const lessLeftPadding = 27.5;
  static const topPadding = 20.0;
  static const rightPadding = 0.0;
  static const bottomPadding = 7.5;
  static const height = 50.5;
  static const radiusNum = 15.0;
  static final radius = BorderRadius.circular(radiusNum);
  static const lightColorScheme = ColorScheme.light(
    primary: Color(0xFF000000),
    secondary: Color(0xFF888888),
    surface: Color(0xFFF8F8F8),
    tertiary: Color(0xFFE0E0E0),
    outline: Color(0xFF888888),
  );
  static const darkColorScheme = ColorScheme.dark(
    primary: Color(0xFFFFFFFF),
    secondary: Color(0xFF888888),
    surface: Color(0xFF000000),
    tertiary: Color(0xFF404040),
    outline: Color(0xFF888888),
  );
  static const arrowForward = SvgPicture(
    AssetBytesLoader('nga_dat/arrow_forward.vec', packageName: 'nga_sdk'),
    width: 16,
    height: 16,
  );

  final Widget child;
  @override
  Widget build(final context) => SizedBox(
        height: CUWidget.height - CUWidget.padding / 2,
        child: FittedBox(
          child: child,
        ),
      );
}
