//====================================================================================================
// Copyright (C) 2016-present Anne Sakitin (Tianwan Ayana).                                          =
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
import 'package:window_manager/window_manager.dart';

import '../tool.dart';

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
  Widget build(final ctx) => Padding(
        padding: EdgeInsets.symmetric(horizontal: outPadding),
        child: Material(
          color: color ??
              (MediaQuery.of(ctx).platformBrightness == Brightness.light ? CUWidget.white : CUWidget.black),
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
          ),
        ),
      );
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
  Widget build(final ctx) => Padding(
        padding: EdgeInsets.fromLTRB(left, top, right, bottom),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            label,
            style: TextStyle(
              color: color,
            ),
          ),
        ),
      );
}

@Deprecated("Don't comply with CU specifications")
class CUListTitle extends StatelessWidget {
  @Deprecated("Don't comply with CU specifications")
  const CUListTitle(
    this.title, {
    final Key? key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.padding = 10,
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
  Widget build(final ctx) => Padding(
        padding: EdgeInsets.symmetric(horizontal: outPadding),
        child: Material(
          color: color ??
              (MediaQuery.of(ctx).platformBrightness == Brightness.light ? CUWidget.white : CUWidget.black),
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
                              children: [CUWidget.arrowForward, SizedBox(width: 15)],
                            )
                          : null),
                ),
              ),
            ),
          ),
        ),
      );
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
    final allSubs = <CUNavBarGroupSub>[];
    groups.forEach((final CUNavBarGroup group) => allSubs.addAll(group.sub));
    constGroups.forEach((final CUNavBarGroup group) => allSubs.addAll(group.sub));
    _miniKeys = List<GlobalKey>.generate(allSubs.length, (final _) => GlobalKey());
    _fullKeys = List<GlobalKey>.generate(allSubs.length, (final _) => GlobalKey());
  }

  final Duration? duration;
  final double? maxHeight;
  final List<CUNavBarGroup> groups, constGroups;
  final _history = ValueNotifier<List<int>>([]);
  final ValueNotifier<int> index;
  final void Function(int)? onChange, onBack;
  late final List<GlobalKey> _miniKeys;
  late final List<GlobalKey> _fullKeys;

  @override
  Widget build(final ctx) {
    final subs = <CUNavBarGroupSub>[];
    groups.forEach((final group) {
      subs.addAll(group.sub);
      group.sub.forEach((final sub) => sub.can == null ? sub.can = ValueNotifier(true) : true);
    });
    constGroups.forEach((final group) {
      subs.addAll(group.sub);
      group.sub.forEach((final sub) => sub.can == null ? sub.can = ValueNotifier(true) : true);
    });
    return Row(
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
                    onPressed: () {
                      var nowIndex = 0;
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
                                    width: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height
                                        ? MediaQuery.of(context).size.width / 3
                                        : MediaQuery.of(context).size.width * 0.75,
                                    child: CUCard(
                                      Column(
                                        children: [
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: groups
                                                    .map(
                                                      (final group) => Column(
                                                        children: [
                                                          if (group.name.isNotEmpty)
                                                            CUHeadLabel(group.name, left: 27.5),
                                                          CUCard(
                                                            Column(
                                                              children:
                                                                  group.sub.asMap().entries.map((final entry) {
                                                                final targetIndex = nowIndex++;
                                                                final can = entry.value.can!;
                                                                return SizedBox(
                                                                  key: _fullKeys[targetIndex],
                                                                  child: AnimatedBuilder(
                                                                    animation: Listenable.merge(
                                                                      [index, can],
                                                                    ),
                                                                    builder: (final _, final __) => AbsorbPointer(
                                                                      absorbing: !can.value,
                                                                      child: CUProCard(
                                                                        Text(entry.value.name),
                                                                        leading: Icon(
                                                                          entry.value.icon,
                                                                          color: index.value == targetIndex
                                                                              ? CUWidget.red
                                                                              : can.value
                                                                                  ? null
                                                                                  : Colors.grey,
                                                                        ),
                                                                        subtitle: !can.value &&
                                                                                entry.value.whyCannot != null
                                                                            ? Text(entry.value.whyCannot!)
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
                                                      (final group) => Column(
                                                        children: [
                                                          if (group.name.isNotEmpty)
                                                            CUHeadLabel(group.name, left: 27.5),
                                                          CUCard(
                                                            Column(
                                                              children:
                                                                  group.sub.asMap().entries.map((final entry) {
                                                                final targetIndex = nowIndex++;
                                                                final can = entry.value.can!;
                                                                return SizedBox(
                                                                  key: _fullKeys[targetIndex],
                                                                  child: AnimatedBuilder(
                                                                    animation: Listenable.merge(
                                                                      [index, can],
                                                                    ),
                                                                    builder: (final _, final __) => AbsorbPointer(
                                                                      absorbing: !can.value,
                                                                      child: CUProCard(
                                                                        Text(entry.value.name),
                                                                        leading: Icon(
                                                                          entry.value.icon,
                                                                          color: index.value == targetIndex
                                                                              ? CUWidget.red
                                                                              : can.value
                                                                                  ? null
                                                                                  : Colors.grey,
                                                                        ),
                                                                        subtitle: !can.value &&
                                                                                entry.value.whyCannot != null
                                                                            ? Text(entry.value.whyCannot!)
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
                      Overlay.of(ctx).insert(overlayEntry);
                      Future<void>.delayed(const Duration(milliseconds: 50), () {
                        nowIndex = 0;
                        pos = 0;
                        overlayEntry?.markNeedsBuild();
                        WidgetsBinding.instance.addPostFrameCallback(
                          (final _) => Scrollable.ensureVisible(
                            _fullKeys[index.value].currentContext!,
                            duration: duration ?? const Duration(milliseconds: 150),
                            alignment: 0.5,
                          ),
                        );
                      });
                    },
                    icon: const Icon(Icons.menu),
                    tooltip: MaterialLocalizations.of(ctx).showMenuTooltip,
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: subs
                            .asMap()
                            .entries
                            .map(
                              (final entry) => SizedBox(
                                key: _miniKeys[entry.key],
                                child: AnimatedBuilder(
                                  animation: Listenable.merge([index, entry.value.can]),
                                  builder: (final _, final __) {
                                    if (index.value == entry.key) {
                                      WidgetsBinding.instance.addPostFrameCallback((final _) {
                                        Scrollable.ensureVisible(
                                          _miniKeys[entry.key].currentContext!,
                                          duration: duration ?? const Duration(milliseconds: 150),
                                          alignment: 0.5,
                                        );
                                      });
                                    }
                                    return AbsorbPointer(
                                      absorbing: !entry.value.can!.value,
                                      child: IconButton(
                                        onPressed: () {
                                          _history.value.add(entry.key);
                                          _history.value = _history.value.toList();
                                          index.value = entry.key;
                                          onChange?.call(entry.key);
                                        },
                                        icon: Icon(
                                          entry.value.icon,
                                          color: entry.value.can!.value ? null : Colors.grey,
                                        ),
                                        tooltip: entry.value.name,
                                        color: index.value == entry.key ? CUWidget.red : null,
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
                        onPressed: () {
                          if (value.isNotEmpty) value.removeLast();
                          index.value = value.isNotEmpty ? value.last : 0;
                          _history.value = value.toList();
                          onBack?.call(index.value);
                        },
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
            radius: const BorderRadius.only(topRight: Radius.circular(15)),
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: index,
            builder: (final _, final int value, final __) => subs.isEmpty
                ? const SizedBox.shrink()
                : AnimatedSwitcher(
                    duration: duration ?? const Duration(milliseconds: 300),
                    child: SizedBox(key: ValueKey(value), child: subs[value].page),
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
  CUNavBarGroupSub({required this.icon, required this.name, required this.page, this.can, this.whyCannot});

  final IconData icon;
  final String name;
  final Widget page;
  ValueNotifier<bool>? can;
  final String? whyCannot;
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
  Widget build(final ctx) => Padding(
        padding: EdgeInsets.symmetric(horizontal: outPadding),
        child: Material(
          color: color ??
              (MediaQuery.of(ctx).platformBrightness == Brightness.light ? CUWidget.white : CUWidget.black),
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
                  children: [
                    if (leading != null) ...[
                      DefaultTextStyle(
                        style: Theme.of(ctx).textTheme.bodyMedium ??
                            Theme.of(ctx).listTileTheme.leadingAndTrailingTextStyle ??
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
                          DefaultTextStyle(
                            style: Theme.of(ctx).textTheme.bodyMedium ??
                                Theme.of(ctx).listTileTheme.titleTextStyle ??
                                const ListTileThemeData().titleTextStyle ??
                                const TextStyle(),
                            child: title,
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 3),
                            DefaultTextStyle(
                              style: Theme.of(ctx).textTheme.bodySmall ??
                                  Theme.of(ctx).listTileTheme.subtitleTextStyle ??
                                  const ListTileThemeData().subtitleTextStyle ??
                                  const TextStyle(),
                              child: subtitle!,
                            ),
                          ],
                        ],
                      ),
                    ),
                    DefaultTextStyle(
                      style: Theme.of(ctx).textTheme.bodyMedium ??
                          Theme.of(ctx).listTileTheme.leadingAndTrailingTextStyle ??
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
  Widget build(final ctx) => _box(
        ClipRRect(
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
        ),
      );
  Widget _box(final Widget widget) => NGATool.isDesktop
      ? DragToMoveArea(
          child: widget,
        )
      : SizedBox(
          child: widget,
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

class CUWidget {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF202020);
  static const Color yellow = Color(0x80BA8A5A);
  static const Color purple = Color(0xFF5746A6);
  static const Color red = Color(0xFFC7372C);
  static final radius = BorderRadius.circular(15);
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
}
