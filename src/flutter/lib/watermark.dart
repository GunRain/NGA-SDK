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

import 'dart:math';

import 'package:flutter/material.dart';

import 'ext.dart';

class NGAWatermark {
  static OverlayEntry? _watermark;
  static void add(final BuildContext ctx, final String txt, {final bool colorful = false}) {
    if (_watermark != null) return;
    _watermark = OverlayEntry(builder: (final _) => get(ctx, txt, colorful: colorful))
        .let((final OverlayEntry entry) {
      Overlay.of(ctx).insert(entry);
      return entry;
    });
  }

  static Widget get(final BuildContext ctx, final String txt, {final bool colorful = false}) =>
      Positioned.fill(
        child: IgnorePointer(
          child: CustomPaint(size: Size.infinite, painter: _NGAWatermarkPainter(ctx, txt, colorful)),
        ),
      );
  static void remove() => _watermark?.remove();
}

class _NGAWatermarkPainter extends CustomPainter {
  _NGAWatermarkPainter(this.ctx, this.text, this.colorful);

  final BuildContext ctx;
  final String text;
  final bool colorful;
  @override
  void paint(final canvas, final size) {
    final txtStyle = Theme.of(ctx).textTheme.headlineMedium ?? const TextStyle();
    final txtPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: colorful
            ? txtStyle.copyWith(
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [
                      Colors.red.withAlpha(50),
                      Colors.orange.withAlpha(50),
                      Colors.yellow.withAlpha(50),
                      Colors.green.withAlpha(50),
                      Colors.blue.withAlpha(50),
                      Colors.indigo.withAlpha(50),
                      Colors.purple.withAlpha(50),
                    ],
                  ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
              )
            : txtStyle.copyWith(color: Colors.grey.withAlpha(50)),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final stepX = txtPainter.width * 1.5;
    final stepY = txtPainter.height * 1.5;
    final len = size.width + size.height;
    canvas
      ..save()
      ..translate(0, size.height)
      ..rotate(-pi / 4);
    for (var y = -len; y < len; y += stepY)
      for (var x = -len; x < len; x += stepX) txtPainter.paint(canvas, Offset(x, y));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant final CustomPainter oldDelegate) => false;
}
