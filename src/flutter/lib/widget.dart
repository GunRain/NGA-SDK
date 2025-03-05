// NGA SDK by Sakitin(GitHub@GunRain 酷安@芙洛洛 bilibili@安音咲汀)

// GitHub link: https://github.com/GunRain/NGA-SDK

import 'dart:ui';

import 'package:flutter/material.dart';

enum NGAMsg { info, err, warn, ok }

class NGA {
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
      padding: isAllPadding
          ? EdgeInsets.all(outPadding)
          : EdgeInsets.only(left: outPadding, right: outPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: (useWhite ? Colors.white : Colors.grey).withAlpha(alpha),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(radius),
              child: InkWell(
                  onTap: onTap,
                  child:
                      Padding(padding: EdgeInsets.all(padding), child: child)),
            ),
          ),
        ),
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
      padding: isAllPadding
          ? EdgeInsets.all(outPadding)
          : EdgeInsets.only(left: outPadding, right: outPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: (useWhite ? Colors.white : Colors.grey).withAlpha(alpha),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: padding),
                for (int i = 0; i < children.length; i++) ...[
                  Padding(
                      padding: EdgeInsets.only(left: padding, right: padding),
                      child: children[i]),
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

  static Widget txtButton(Widget txt, void Function() onTap,
      {double radius = 24, int alpha = 22, bool useWhite = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            child: IntrinsicWidth(
              child: Container(
                decoration: BoxDecoration(
                  color:
                      (useWhite ? Colors.white : Colors.grey).withAlpha(alpha),
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Center(child: txt)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void msg(BuildContext context,
      {required String txt, required NGAMsg type, int s = 3}) {
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
              return Transform.translate(
                  offset: offset * MediaQuery.of(context).size.height,
                  child: child);
            },
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                          color: Colors.white.withAlpha(128),
                          borderRadius: BorderRadius.circular(16.0)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(icon, color: color),
                          SizedBox(width: 12),
                          Text(txt, style: TextStyle(color: color))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    OverlayEntry goEntry = toastOverlayEntry(
        Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0)));
    overlayState.insert(goEntry);
    Future.delayed(Duration(seconds: s), () {
      OverlayEntry backEntry = toastOverlayEntry(
          Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1)));
      overlayState.insert(backEntry);
      goEntry.remove();
      Future.delayed(Duration(milliseconds: 300), () => backEntry.remove());
    });
  }
}
