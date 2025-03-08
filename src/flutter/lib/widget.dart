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
// For full information about the NGA project, please visit: http://app.niggergo.work.                           =
// For full information about the F2DLPR License terms and conditions, please visit: http://license.fileto.download.   =
//================================================================================================================

import 'dart:ui';

import 'package:flutter/material.dart';

enum NGAMsg { info, err, warn, ok }

class NGAWidget {
  static Widget card(
    BuildContext context,
    Widget child, {
    double radius = 24,
    double padding = 16,
    double outPadding = 0,
    int alpha = 22,
    bool useWhite = false,
    bool isAllPadding = true,
    void Function()? onTap,
  }) {
    return Padding(
      padding: isAllPadding ? EdgeInsets.all(outPadding) : EdgeInsets.symmetric(horizontal: outPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(radius),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(radius),
                child: Container(
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    color: (useWhite ? Colors.white : Colors.grey).withAlpha(alpha),
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                  child: child,
                ),
              ),
            )),
      ),
    );
  }

  static Widget cards(
    BuildContext context,
    List<Widget> children, {
    double radius = 24,
    double padding = 16,
    double outPadding = 0,
    int alpha = 22,
    bool useWhite = false,
    bool isAllPadding = true,
  }) {
    return Padding(
      padding: isAllPadding ? EdgeInsets.all(outPadding) : EdgeInsets.symmetric(horizontal: outPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: (useWhite ? Colors.white : Colors.grey).withAlpha(alpha),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: padding),
                for (int i = 0; i < children.length; i++) ...[
                  Padding(padding: EdgeInsets.symmetric(horizontal: padding), child: children[i]),
                  if (i < children.length - 1) Divider(),
                ],
                SizedBox(height: padding),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void msg(BuildContext context,
      {void Function()? onTap, required String txt, required NGAMsg type, int s = 3}) {
    if (!context.mounted) return;
    final overlayState = Overlay.of(context);
    IconData icon;
    Color color;
    switch (type) {
      case NGAMsg.err:
        icon = Icons.error_rounded;
        color = Colors.redAccent;
        break;
      case NGAMsg.warn:
        icon = Icons.warning_rounded;
        color = Colors.orangeAccent;
        break;
      case NGAMsg.ok:
        icon = Icons.check_circle_rounded;
        color = Colors.greenAccent;
        break;
      case NGAMsg.info:
        icon = Icons.info_rounded;
        color = Colors.blueAccent;
    }
    OverlayEntry toastOverlayEntry(Tween<Offset> tween) {
      return OverlayEntry(
        builder: (context) => Positioned(
          top: MediaQuery.of(context).size.height * 0.075,
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
          child: TweenAnimationBuilder<Offset>(
            tween: tween,
            duration: Duration(milliseconds: 300),
            builder: (context, offset, child) {
              return Transform.translate(offset: offset * MediaQuery.of(context).size.height, child: child);
            },
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                          onTap: onTap,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.white.withAlpha(128), borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(icon, color: color),
                                SizedBox(width: 12),
                                Text(txt, style: TextStyle(color: color))
                              ],
                            ),
                          ))),
                ),
              ),
            ),
          ),
        ),
      );
    }

    OverlayEntry goEntry = toastOverlayEntry(Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0)));
    overlayState.insert(goEntry);
    Future.delayed(Duration(seconds: s), () {
      OverlayEntry backEntry = toastOverlayEntry(Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1)));
      overlayState.insert(backEntry);
      goEntry.remove();
      Future.delayed(Duration(milliseconds: 300), () => backEntry.remove());
    });
  }

  static Widget txtButton(Widget txt, void Function() onTap,
      {double radius = 24, int alpha = 22, bool useWhite = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(radius),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(radius),
              child: IntrinsicWidth(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (useWhite ? Colors.white : Colors.grey).withAlpha(alpha),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  child: Center(child: txt),
                ),
              ),
            )),
      ),
    );
  }
}
