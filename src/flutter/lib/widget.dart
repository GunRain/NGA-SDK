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

import 'package:flutter/material.dart';

class NGACard extends StatelessWidget {
  const NGACard(
    this.child, {
    final Key? key,
    this.radius = 24,
    this.padding = 16,
    this.outPadding = 0,
    this.alpha = 22,
    this.useWhite = false,
    this.isAllPadding = true,
    this.onTap,
    this.tip = '',
  }) : super(key: key);
  final Widget child;
  final double radius, padding, outPadding;
  final int alpha;
  final bool useWhite, isAllPadding;
  final VoidCallback? onTap;
  final String tip;
  @override
  Widget build(final ctx) => Padding(
        padding: isAllPadding ? EdgeInsets.all(outPadding) : EdgeInsets.symmetric(horizontal: outPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(radius),
              child: Tooltip(
                message: tip,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(radius),
                  child: Container(
                    padding: EdgeInsets.all(padding),
                    decoration: BoxDecoration(
                      color: (useWhite ? Colors.white : Colors.grey).withAlpha(alpha),
                      borderRadius: BorderRadius.circular(radius),
                      border: Border.all(color: Theme.of(ctx).colorScheme.outlineVariant),
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class NGACards extends StatelessWidget {
  const NGACards(
    this.children, {
    final Key? key,
    this.radius = 24,
    this.padding = 16,
    this.outPadding = 0,
    this.alpha = 22,
    this.useWhite = false,
    this.isAllPadding = true,
  }) : super(key: key);
  final List<Widget> children;
  final double radius, padding, outPadding;
  final int alpha;
  final bool useWhite, isAllPadding;
  @override
  Widget build(final ctx) => Padding(
        padding: isAllPadding ? EdgeInsets.all(outPadding) : EdgeInsets.symmetric(horizontal: outPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: (useWhite ? Colors.white : Colors.grey).withAlpha(alpha),
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(color: Theme.of(ctx).colorScheme.outlineVariant),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: padding),
                  for (int i = 0; i < children.length; i++) ...[
                    Padding(padding: EdgeInsets.symmetric(horizontal: padding), child: children[i]),
                    if (i < children.length - 1) const Divider(),
                  ],
                  SizedBox(height: padding),
                ],
              ),
            ),
          ),
        ),
      );
}

class NGAMsg {
  static void show(
    final BuildContext context, {
    required final String txt,
    required final NGAMsgType type,
    final void Function()? onTap,
    final int s = 3,
    final String tip = '',
  }) {
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
        break;
    }
    OverlayEntry toastOverlayEntry(final Tween<Offset> tween) => OverlayEntry(
          builder: (final ctx) => Positioned(
            top: MediaQuery.of(ctx).size.height * 0.075,
            left: MediaQuery.of(ctx).size.width * 0.1,
            right: MediaQuery.of(ctx).size.width * 0.1,
            child: TweenAnimationBuilder(
              tween: tween,
              duration: const Duration(milliseconds: 300),
              builder: (final ctx, final Offset offset, final Widget? child) =>
                  Transform.translate(offset: offset * MediaQuery.of(ctx).size.height, child: child),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: Tooltip(
                        message: tip,
                        child: InkWell(
                          onTap: onTap,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(128),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(icon, color: color),
                                const SizedBox(width: 12),
                                Text(txt, style: TextStyle(color: color)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

    final goEntry = toastOverlayEntry(Tween(begin: const Offset(0, -1), end: Offset.zero));
    overlayState.insert(goEntry);
    Future<void>.delayed(Duration(seconds: s), () {
      final backEntry = toastOverlayEntry(Tween(begin: Offset.zero, end: const Offset(0, -1)));
      overlayState.insert(backEntry);
      goEntry.remove();
      Future<void>.delayed(const Duration(milliseconds: 300), backEntry.remove);
    });
  }
}

enum NGAMsgType { info, err, warn, ok }

class NGATxtButton extends StatelessWidget {
  const NGATxtButton(
    this.txt,
    this.onTap, {
    final Key? key,
    this.radius = 24,
    this.alpha = 22,
    this.useWhite = false,
    this.intrinsic = false,
    this.tip = '',
  }) : super(key: key);
  final Widget txt;
  final VoidCallback onTap;
  final double radius;
  final int alpha;
  final bool useWhite, intrinsic;
  final String tip;
  @override
  Widget build(final ctx) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(radius),
            child: Tooltip(
              message: tip,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(radius),
                child: intrinsic
                    ? IntrinsicWidth(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (useWhite ? Colors.white : Colors.grey).withAlpha(alpha),
                            borderRadius: BorderRadius.circular(radius),
                          ),
                          child: Center(child: txt),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (useWhite ? Colors.white : Colors.grey).withAlpha(alpha),
                          borderRadius: BorderRadius.circular(radius),
                        ),
                        child: Center(child: txt),
                      ),
              ),
            ),
          ),
        ),
      );
}
