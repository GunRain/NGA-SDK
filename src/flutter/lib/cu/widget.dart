//====================================================================================================
// Copyright (c) 2023-present Anne Sakitin (Tianwan Ayana).                                          =
//                                                                                                   =
// Part of the NGA project.                                                                          =
// Licensed under the F2DLPR License.                                                                =
//                                                                                                   =
// YOU MAY NOT USE THIS FILE EXCEPT IN COMPLIANCE WITH THE LICENSE.                                  =
// Provided "AS IS", WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,                                   =
// unless required by applicable law or agreed to in writing.                                        =
//                                                                                                   =
// For details about the NGA project, visit: http://app.niggergo.work.                               =
// For details about the F2DLPR License terms and conditions, visit: http://license.fileto.download. =
//====================================================================================================

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class CUCard extends StatelessWidget {
  const CUCard(
    this.child, {
    final Key? key,
    this.padding = 10,
    this.outPadding = 20,
    this.onTap,
    this.color,
    this.tip = '',
    this.radius,
  }) : super(key: key);
  final Widget child;
  final double padding, outPadding;
  final VoidCallback? onTap;
  final Color? color;
  final String tip;
  final BorderRadius? radius;
  @override
  Widget build(final BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(horizontal: outPadding),
      child: Material(
          color: color ??
              (MediaQuery.of(context).platformBrightness == Brightness.light ? CUWidget.white : CUWidget.black),
          borderRadius: radius ?? CUWidget.radius,
          child: Tooltip(
            message: tip,
            child: InkWell(
              onTap: onTap,
              borderRadius: radius ?? CUWidget.radius,
              child: Container(
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: child,
              ),
            ),
          )));
}

class CUHeadLabel extends StatelessWidget {
  const CUHeadLabel(
    this.label, {
    final Key? key,
    this.color = CUWidget.red,
    this.left = 42.5,
    this.top = 20,
    this.right = 0,
    this.bottom = 7.5,
  }) : super(key: key);
  final String label;
  final Color color;
  final double left, top, right, bottom;
  @override
  Widget build(final BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(left, top, right, bottom),
        child: SizedBox(
            width: double.infinity,
            child: Text(
              label,
              style: TextStyle(
                color: color,
              ),
            )),
      );
}

@Deprecated("Don't comply with CU specifications")
class CUListTitle extends StatelessWidget {
  @Deprecated("Don't comply with CU specifications")
  const CUListTitle(this.title,
      {final Key? key,
      this.subtitle,
      this.leading,
      this.trailing,
      this.padding = 10,
      this.outPadding = 20,
      this.onTap,
      this.color,
      this.tip = ''})
      : super(key: key);
  final Widget title;
  final Widget? subtitle, leading, trailing;
  final double padding, outPadding;
  final VoidCallback? onTap;
  final Color? color;
  final String tip;
  @override
  Widget build(final BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(horizontal: outPadding),
      child: Material(
          color: color ??
              (MediaQuery.of(context).platformBrightness == Brightness.light ? CUWidget.white : CUWidget.black),
          borderRadius: CUWidget.radius,
          child: Tooltip(
            message: tip,
            child: InkWell(
              onTap: onTap,
              borderRadius: CUWidget.radius,
              child: Container(
                padding: EdgeInsets.fromLTRB(padding, 5, padding / 2, 5),
                decoration: BoxDecoration(
                  borderRadius: CUWidget.radius,
                ),
                child: ListTile(
                  leading: leading,
                  title: title,
                  subtitle: subtitle,
                  trailing: trailing ??
                      (onTap != null
                          ? const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[CUWidget.arrowForward, SizedBox(width: 15)])
                          : null),
                ),
              ),
            ),
          )));
}

class CUNavBar extends StatelessWidget {
  CUNavBar({
    required this.groups,
    required this.constGroups,
    required this.index,
    final Key? key,
    this.onChanged,
    this.onBacked,
    this.maxHeight,
    this.duration,
  }) : super(key: key);
  final Duration? duration;
  final double? maxHeight;
  final List<CUNavBarGroup> groups, constGroups;
  final ValueNotifier<List<int>> _history = ValueNotifier<List<int>>(<int>[]);
  final ValueNotifier<int> index;
  final void Function(int)? onChanged, onBacked;

  @override
  Widget build(final BuildContext context) {
    final List<CUNavBarGroupSub> subs = <CUNavBarGroupSub>[];
    for (final CUNavBarGroup group in groups) {
      subs.addAll(group.sub);
    }
    for (final CUNavBarGroup group in constGroups) {
      subs.addAll(group.sub);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.bottomLeft,
          child: CUCard(
            Container(
              constraints: BoxConstraints(maxHeight: maxHeight ?? MediaQuery.of(context).size.height / 2.5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      int nowIndex = 0;
                      double pos = -(MediaQuery.of(context).size.width > MediaQuery.of(context).size.height
                          ? MediaQuery.of(context).size.width / 3
                          : MediaQuery.of(context).size.width * 0.75);
                      OverlayEntry? overlayEntry;
                      overlayEntry = OverlayEntry(
                        builder: (final BuildContext context) => Stack(
                          children: <Widget>[
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
                                    width: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height
                                        ? MediaQuery.of(context).size.width / 3
                                        : MediaQuery.of(context).size.width * 0.75,
                                    child: CUCard(
                                      Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: groups
                                                    .map(
                                                      (final CUNavBarGroup group) => Column(
                                                        children: <Widget>[
                                                          if (group.name.isNotEmpty)
                                                            CUHeadLabel(group.name, left: 27.5),
                                                          CUCard(
                                                            Column(
                                                              children: group.sub.asMap().entries.map(
                                                                  (final MapEntry<int, CUNavBarGroupSub> entry) {
                                                                final int targetIndex = nowIndex++;
                                                                return CUProCard(
                                                                  Text(entry.value.name),
                                                                  leading: ValueListenableBuilder<int>(
                                                                    valueListenable: index,
                                                                    builder:
                                                                        (final _, final int value, final __) =>
                                                                            Icon(
                                                                      entry.value.icon,
                                                                      color: value == targetIndex
                                                                          ? CUWidget.red
                                                                          : null,
                                                                    ),
                                                                  ),
                                                                  onTap: () {
                                                                    _history.value.add(targetIndex);
                                                                    _history.value = _history.value.toList();
                                                                    index.value = targetIndex;
                                                                    onChanged?.call(targetIndex);
                                                                    overlayEntry?.remove();
                                                                  },
                                                                  outPadding: 0,
                                                                );
                                                              }).toList(),
                                                            ),
                                                            padding: 0,
                                                            outPadding: 5,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.25,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: constGroups
                                                    .map(
                                                      (final CUNavBarGroup group) => Column(
                                                        children: <Widget>[
                                                          if (group.name.isNotEmpty)
                                                            CUHeadLabel(group.name, left: 27.5),
                                                          CUCard(
                                                            Column(
                                                              children: group.sub.asMap().entries.map(
                                                                  (final MapEntry<int, CUNavBarGroupSub> entry) {
                                                                final int targetIndex = nowIndex++;
                                                                return CUProCard(
                                                                  Text(entry.value.name),
                                                                  leading: ValueListenableBuilder<int>(
                                                                    valueListenable: index,
                                                                    builder:
                                                                        (final _, final int value, final __) =>
                                                                            Icon(
                                                                      entry.value.icon,
                                                                      color: value == targetIndex
                                                                          ? CUWidget.red
                                                                          : null,
                                                                    ),
                                                                  ),
                                                                  onTap: () {
                                                                    _history.value.add(targetIndex);
                                                                    _history.value = _history.value.toList();
                                                                    index.value = targetIndex;
                                                                    onChanged?.call(targetIndex);
                                                                    overlayEntry?.remove();
                                                                  },
                                                                  outPadding: 0,
                                                                );
                                                              }).toList(),
                                                            ),
                                                            padding: 0,
                                                            outPadding: 5,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      outPadding: 0,
                                      color: Theme.of(context).colorScheme.surface,
                                      radius: const BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      Overlay.of(context).insert(overlayEntry);
                      Future<void>.delayed(const Duration(milliseconds: 50), () {
                        nowIndex = 0;
                        pos = 0;
                        overlayEntry?.markNeedsBuild();
                      });
                    },
                    icon: const Icon(Icons.menu),
                    tooltip: MaterialLocalizations.of(context).showMenuTooltip,
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: subs
                            .asMap()
                            .entries
                            .map(
                              (final MapEntry<int, CUNavBarGroupSub> entry) => ValueListenableBuilder<int>(
                                valueListenable: index,
                                builder: (final _, final int value, final __) => IconButton(
                                  onPressed: () {
                                    _history.value.add(entry.key);
                                    _history.value = _history.value.toList();
                                    index.value = entry.key;
                                    onChanged?.call(entry.key);
                                  },
                                  icon: Icon(entry.value.icon),
                                  tooltip: entry.value.name,
                                  color: value == entry.key ? CUWidget.red : null,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  ValueListenableBuilder<List<int>>(
                    valueListenable: _history,
                    builder: (final _, final List<int> value, final __) => AbsorbPointer(
                      absorbing: value.isEmpty,
                      child: IconButton(
                        onPressed: () {
                          if (value.isNotEmpty) value.removeLast();
                          index.value = value.isNotEmpty ? value.last : 0;
                          _history.value = value.toList();
                          onBacked?.call(index.value);
                        },
                        icon: Icon(Icons.arrow_back, color: value.isEmpty ? Colors.grey : null),
                        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            padding: 5,
            outPadding: 0,
            radius: const BorderRadius.only(topRight: Radius.circular(15)),
          ),
        ),
        Expanded(
          child: ValueListenableBuilder<int>(
            valueListenable: index,
            builder: (final _, final int value, final __) => subs.isEmpty
                ? const SizedBox.shrink()
                : AnimatedSwitcher(
                    duration: duration ?? const Duration(milliseconds: 300),
                    child: SizedBox(key: ValueKey<int>(value), child: subs[value].page),
                  ),
          ),
        ),
      ],
    );
  }
}

class CUNavBarGroup {
  CUNavBarGroup({required this.name, required this.sub});

  final String name;
  final List<CUNavBarGroupSub> sub;
}

class CUNavBarGroupSub {
  CUNavBarGroupSub({required this.icon, required this.name, required this.page});

  final IconData icon;
  final String name;
  final Widget page;
}

class CUProCard extends StatelessWidget {
  const CUProCard(
    this.title, {
    final Key? key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.padding = 22.5,
    this.outPadding = 20,
    this.onTap,
    this.color,
    this.tip = '',
  }) : super(key: key);
  final Widget title;
  final Widget? subtitle, leading, trailing;
  final double padding, outPadding;
  final VoidCallback? onTap;
  final Color? color;
  final String tip;
  @override
  Widget build(final BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: outPadding),
        child: Material(
          color: color ??
              (MediaQuery.of(context).platformBrightness == Brightness.light ? CUWidget.white : CUWidget.black),
          borderRadius: CUWidget.radius,
          child: Tooltip(
            message: tip,
            child: InkWell(
              onTap: onTap,
              borderRadius: CUWidget.radius,
              child: Container(
                constraints: const BoxConstraints(minHeight: 50),
                padding: EdgeInsets.fromLTRB(padding, padding / 2, padding, padding / 2),
                decoration: BoxDecoration(borderRadius: CUWidget.radius),
                child: Row(
                  children: <Widget>[
                    if (leading != null) ...<Widget>[
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
                        children: <Widget>[
                          DefaultTextStyle(
                            style: Theme.of(context).textTheme.bodyMedium ??
                                Theme.of(context).listTileTheme.titleTextStyle ??
                                const ListTileThemeData().titleTextStyle ??
                                const TextStyle(),
                            child: title,
                          ),
                          if (subtitle != null) ...<Widget>[
                            const SizedBox(height: 3),
                            DefaultTextStyle(
                              style: Theme.of(context).textTheme.bodySmall ??
                                  Theme.of(context).listTileTheme.subtitleTextStyle ??
                                  const ListTileThemeData().subtitleTextStyle ??
                                  const TextStyle(),
                              child: subtitle!,
                            ),
                          ],
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
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class CUTopBar extends StatelessWidget implements PreferredSizeWidget {
  const CUTopBar({final Key? key, this.leading, this.icon, this.title, this.actions}) : super(key: key);
  final Widget? leading, icon, title;
  final List<Widget>? actions;
  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override
  Widget build(final BuildContext context) => ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(22),
            elevation: 0,
            scrolledUnderElevation: 0,
            titleSpacing: 24,
            leading: leading,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  icon!,
                  const SizedBox(width: 16),
                ],
                if (title != null) ...<Widget>[
                  title!,
                ],
              ],
            ),
            actions: actions,
          ),
        ),
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
  Widget build(final BuildContext context) => Material(
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

class CUWidget {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF202020);
  static const Color yellow = Color(0x80BA8A5A);
  static const Color purple = Color(0xFF5746A6);
  static const Color red = Color(0xFFC7372C);
  static final BorderRadius radius = BorderRadius.circular(15);
  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: Color(0xFF000000),
    secondary: Color(0xFF888888),
    surface: Color(0xFFF8F8F8),
    tertiary: Color(0xFFE0E0E0),
    outline: Color(0xFF888888),
  );
  static const ColorScheme darkColorScheme = ColorScheme.dark(
    primary: Color(0xFFFFFFFF),
    secondary: Color(0xFF888888),
    surface: Color(0xFF000000),
    tertiary: Color(0xFF404040),
    outline: Color(0xFF888888),
  );
  static const SvgPicture arrowForward = SvgPicture(
    AssetBytesLoader('nga_dat/arrow_forward.vec', packageName: 'nga_sdk'),
    width: 16,
    height: 16,
  );
}
