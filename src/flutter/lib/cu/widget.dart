//================================================================================================================
// Copyright (c) 2023-present Anne Sakitin (Tianwan Ayana).                                                      =
//                                                                                                               =
// Part of the NGA project.                                                                                      =
// Licensed under the F2DLPR License.                                                                            =
//                                                                                                               =
// YOU MAY NOT USE THIS FILE EXCEPT IN COMPLIANCE WITH THE LICENSE.                                              =
// Provided "AS IS", WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,                                               =
// unless required by applicable law or agreed to in writing.                                                    =
//                                                                                                               =
// For details about the NGA project, visit: http://app.niggergo.work.                                           =
// For details about the F2DLPR License terms and conditions, visit: http://license.fileto.download.             =
//================================================================================================================

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class CUCard extends StatelessWidget {
  final Widget child;
  final double padding, outPadding;
  final VoidCallback? onTap;
  final Color? color;
  final String tip;
  final BorderRadius? radius;
  const CUCard(this.child,
      {Key? key, this.padding = 10, this.outPadding = 20, this.onTap, this.color, this.tip = '', this.radius})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
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
}

class CUHeadLabel extends StatelessWidget {
  final String label;
  final Color color;
  final double left, top, right, bottom;
  const CUHeadLabel(this.label,
      {Key? key, this.color = CUWidget.red, this.left = 42.5, this.top = 20, this.right = 0, this.bottom = 7.5})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
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
}

class CUListTitle extends StatelessWidget {
  final Widget title;
  final Widget? subtitle, leading, trailing;
  final double padding, outPadding;
  final VoidCallback? onTap;
  final Color? color;
  final String tip;
  const CUListTitle(this.title,
      {Key? key,
      this.subtitle,
      this.leading,
      this.trailing,
      this.padding = 10,
      this.outPadding = 20,
      this.onTap,
      this.color,
      this.tip = ''})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [CUWidget.arrowForward, SizedBox(width: 15)])
                            : null),
                  ),
                ),
              ),
            )));
  }
}

class CUNavBar extends StatelessWidget {
  final Duration? duration;
  final double? maxHeight;
  final List<CUNavBarGroup> groups;
  final List<CUNavBarGroup> constGroups;
  final ValueNotifier<List<int>> _history = ValueNotifier<List<int>>([]);
  final ValueNotifier<int> index;
  final void Function(int)? onChanged, onBacked;

  CUNavBar({
    Key? key,
    required this.groups,
    required this.constGroups,
    required this.index,
    this.onChanged,
    this.onBacked,
    this.maxHeight,
    this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<CUNavBarGroupSub> subs = [];
    for (var group in groups) {
      subs.addAll(group.sub);
    }
    for (var group in constGroups) {
      subs.addAll(group.sub);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: CUCard(
            Container(
              constraints: BoxConstraints(maxHeight: maxHeight ?? MediaQuery.of(context).size.height / 2.5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      int nowIndex = 0;
                      double pos = -(MediaQuery.of(context).size.width > MediaQuery.of(context).size.height
                          ? MediaQuery.of(context).size.width / 3
                          : MediaQuery.of(context).size.width * 0.75);
                      OverlayEntry? overlayEntry;
                      overlayEntry = OverlayEntry(
                        builder: (context) => Stack(
                          children: [
                            GestureDetector(
                              onTap: () => overlayEntry?.remove(),
                              child: Container(color: Colors.black.withAlpha(127)),
                            ),
                            AnimatedPositioned(
                              duration: duration ?? Duration(milliseconds: 150),
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
                                                      (group) => Column(
                                                        children: [
                                                          if (group.name.isNotEmpty)
                                                            CUHeadLabel(group.name, left: 27.5),
                                                          CUCard(
                                                            Column(
                                                              children: group.sub.asMap().entries.map((entry) {
                                                                final targetIndex = nowIndex++;
                                                                return CUProCard(
                                                                  Text(entry.value.name),
                                                                  leading: ValueListenableBuilder<int>(
                                                                    valueListenable: index,
                                                                    builder: (_, value, __) => Icon(
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
                                                                    if (onChanged != null) {
                                                                      onChanged!(targetIndex);
                                                                    }
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
                                                      (group) => Column(
                                                        children: [
                                                          if (group.name.isNotEmpty)
                                                            CUHeadLabel(group.name, left: 27.5),
                                                          CUCard(
                                                            Column(
                                                              children: group.sub.asMap().entries.map((entry) {
                                                                final targetIndex = nowIndex++;
                                                                return CUProCard(
                                                                  Text(entry.value.name),
                                                                  leading: ValueListenableBuilder<int>(
                                                                    valueListenable: index,
                                                                    builder: (_, value, __) => Icon(
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
                                                                    if (onChanged != null) {
                                                                      onChanged!(targetIndex);
                                                                    }
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
                                      radius: BorderRadius.only(
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
                      Future.delayed(Duration(milliseconds: 50), () {
                        nowIndex = 0;
                        pos = 0;
                        overlayEntry?.markNeedsBuild();
                      });
                    },
                    icon: Icon(Icons.menu),
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
                              (entry) => ValueListenableBuilder<int>(
                                valueListenable: index,
                                builder: (_, value, __) => IconButton(
                                  onPressed: () {
                                    _history.value.add(entry.key);
                                    _history.value = _history.value.toList();
                                    index.value = entry.key;
                                    if (onChanged != null) onChanged!(entry.key);
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
                    builder: (_, value, __) => AbsorbPointer(
                      absorbing: value.isEmpty,
                      child: IconButton(
                        onPressed: () {
                          if (value.isNotEmpty) value.removeLast();
                          index.value = value.isNotEmpty ? value.last : 0;
                          _history.value = value.toList();
                          if (onBacked != null) onBacked!(index.value);
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
            radius: BorderRadius.only(topRight: Radius.circular(15)),
          ),
        ),
        Expanded(
          child: ValueListenableBuilder<int>(
            valueListenable: index,
            builder: (_, value, __) => subs.isEmpty
                ? SizedBox.shrink()
                : AnimatedSwitcher(
                    duration: duration ?? Duration(milliseconds: 300),
                    child: SizedBox(key: ValueKey<int>(value), child: subs[value].page),
                  ),
          ),
        ),
      ],
    );
  }
}

class CUNavBarGroup {
  final String name;
  final List<CUNavBarGroupSub> sub;
  CUNavBarGroup({required this.name, required this.sub});
}

class CUNavBarGroupSub {
  final IconData icon;
  final String name;
  final Widget page;
  CUNavBarGroupSub({required this.icon, required this.name, required this.page});
}

class CUProCard extends StatelessWidget {
  final Widget title;
  final Widget? subtitle, leading, trailing;
  final double padding, outPadding;
  final VoidCallback? onTap;
  final Color? color;
  final String tip;
  const CUProCard(
    this.title, {
    Key? key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.padding = 22.5,
    this.outPadding = 20,
    this.onTap,
    this.color,
    this.tip = '',
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
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
              constraints: BoxConstraints(minHeight: 50),
              padding: EdgeInsets.fromLTRB(padding, padding / 2, padding, padding / 2),
              decoration: BoxDecoration(borderRadius: CUWidget.radius),
              child: Row(
                children: [
                  if (leading != null) ...[
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.bodyMedium ??
                          Theme.of(context).listTileTheme.leadingAndTrailingTextStyle ??
                          ListTileThemeData().leadingAndTrailingTextStyle ??
                          TextStyle(),
                      child: leading!,
                    ),
                    SizedBox(width: 20),
                  ],
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.bodyMedium ??
                            Theme.of(context).listTileTheme.titleTextStyle ??
                            ListTileThemeData().titleTextStyle ??
                            TextStyle(),
                        child: title,
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 3),
                        DefaultTextStyle(
                          style: Theme.of(context).textTheme.bodySmall ??
                              Theme.of(context).listTileTheme.subtitleTextStyle ??
                              ListTileThemeData().subtitleTextStyle ??
                              TextStyle(),
                          child: subtitle!,
                        ),
                      ],
                    ],
                  )),
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyMedium ??
                        Theme.of(context).listTileTheme.leadingAndTrailingTextStyle ??
                        ListTileThemeData().leadingAndTrailingTextStyle ??
                        TextStyle(),
                    child: trailing ?? (onTap != null ? CUWidget.arrowForward : SizedBox.shrink()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CUTopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading, icon, title;
  final List<Widget>? actions;
  const CUTopBar({Key? key, this.leading, this.icon, this.title, this.actions}) : super(key: key);
  @override
  Size get preferredSize => Size.fromHeight(60);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
            children: [
              if (icon != null) ...[
                icon!,
                SizedBox(width: 16),
              ],
              if (title != null) ...[
                title!,
              ],
            ],
          ),
          actions: actions,
        ),
      ),
    );
  }
}

class CUTxtButton extends StatelessWidget {
  final Widget txt;
  final VoidCallback onTap;
  final bool intrinsic;
  final String tip;
  const CUTxtButton(this.txt, this.onTap, {Key? key, this.intrinsic = false, this.tip = ''}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
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
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: CUWidget.radius,
                      ),
                      child: Center(child: txt),
                    ))
                  : Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: CUWidget.radius,
                      ),
                      child: Center(child: txt),
                    ),
            )));
  }
}

class CUWidget {
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF202020);
  static const yellow = Color(0x80BA8A5A);
  static const purple = Color(0xFF5746A6);
  static const red = Color(0xFFC7372C);
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
