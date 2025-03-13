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

class NGACard extends StatelessWidget {
  final Widget child;
  final double radius, padding, outPadding;
  final int alpha;
  final bool useWhite, isAllPadding;
  final VoidCallback? onTap;
  const NGACard(this.child,
      {Key? key,
      this.radius = 24,
      this.padding = 16,
      this.outPadding = 0,
      this.alpha = 22,
      this.useWhite = false,
      this.isAllPadding = true,
      this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
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
}

class NGACards extends StatelessWidget {
  final List<Widget> children;
  final double radius, padding, outPadding;
  final int alpha;
  final bool useWhite, isAllPadding;
  const NGACards(
    this.children, {
    Key? key,
    this.radius = 24,
    this.padding = 16,
    this.outPadding = 0,
    this.alpha = 22,
    this.useWhite = false,
    this.isAllPadding = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
              children: [
                SizedBox(height: padding),
                for (int i = 0; i < children.length; i++) ...[
                  Padding(padding: EdgeInsets.symmetric(horizontal: padding), child: children[i]),
                  if (i < children.length - 1) Divider(),
                ],
                SizedBox(height: padding),
              ],
            ).min(),
          ),
        ),
      ),
    );
  }
}

class NGAMsg {
  static void show(BuildContext context,
      {void Function()? onTap, required String txt, required NGAMsgType type, int s = 3}) {
    if (!context.mounted) return;
    final overlayState = Overlay.of(context);
    IconData icon;
    Color color;
    switch (type) {
      case NGAMsgType.err:
        icon = Icons.error_rounded;
        color = Colors.redAccent;
        break;
      case NGAMsgType.warn:
        icon = Icons.warning_rounded;
        color = Colors.orangeAccent;
        break;
      case NGAMsgType.ok:
        icon = Icons.check_circle_rounded;
        color = Colors.greenAccent;
        break;
      case NGAMsgType.info:
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
                              children: [
                                Icon(icon, color: color),
                                SizedBox(width: 12),
                                Text(txt, style: TextStyle(color: color))
                              ],
                            ).min(),
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
}

enum NGAMsgType { info, err, warn, ok }

class NGATxtButton extends StatelessWidget {
  final Widget txt;
  final VoidCallback onTap;
  final double radius;
  final int alpha;
  final bool useWhite;
  const NGATxtButton(this.txt, this.onTap, {Key? key, this.radius = 24, this.alpha = 22, this.useWhite = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
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

extension ColumnMinSize on Column {
  Column min() {
    return Column(
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      spacing: spacing,
      children: children,
    );
  }
}

extension RowMinSize on Row {
  Row min() {
    return Row(
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      spacing: spacing,
      children: children,
    );
  }
}
