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
  const CUCard(this.child,
      {Key? key, this.padding = 10, this.outPadding = 20, this.onTap, this.color, this.tip = ''})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: outPadding),
        child: Material(
            color: color ??
                (MediaQuery.of(context).platformBrightness == Brightness.light ? CUWidget.white : CUWidget.black),
            borderRadius: BorderRadius.circular(15),
            child: Tooltip(
              message: tip,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(15),
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
  const CUHeadLabel(
    this.label, {
    Key? key,
    this.color = CUWidget.red,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(42.5, 20, 0, 7.5),
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
            borderRadius: BorderRadius.circular(15),
            child: Tooltip(
              message: tip,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.fromLTRB(padding, 5, padding / 2, 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
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
        borderRadius: BorderRadius.circular(15),
        child: Tooltip(
          message: tip,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              constraints: BoxConstraints(minHeight: 50),
              padding: EdgeInsets.fromLTRB(padding, padding / 2, padding, padding / 2),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
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
  final String tip;
  const CUTxtButton(this.txt, this.onTap, {Key? key, this.tip = ''}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.grey.withAlpha(22),
        borderRadius: BorderRadius.circular(15),
        child: Tooltip(
            message: tip,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(15),
              child: IntrinsicWidth(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(child: txt),
                ),
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
