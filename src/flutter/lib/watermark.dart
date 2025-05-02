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

import 'dart:math';

import 'package:flutter/material.dart';

import 'ext.dart';

class NGAWatermark {
  static OverlayEntry? _watermark;
  static void add(final BuildContext ctx, final String txt, {final bool colorful = false}) {
    if (_watermark != null) return;
    _watermark =
        OverlayEntry(builder: (final _) => get(ctx, txt, colorful: colorful)).let((final OverlayEntry entry) {
      Overlay.of(ctx).insert(entry);
      return entry;
    });
  }

  static Widget get(final BuildContext ctx, final String txt, {final bool colorful = false}) => Positioned.fill(
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
  void paint(final Canvas canvas, final Size size) {
    final TextStyle txtStyle = Theme.of(ctx).textTheme.headlineMedium ?? const TextStyle();
    final TextPainter txtPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: colorful
            ? txtStyle.copyWith(
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: <Color>[
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
    final double stepX = txtPainter.width * 1.5;
    final double stepY = txtPainter.height * 1.5;
    final double len = size.width + size.height;
    canvas
      ..save()
      ..translate(0, size.height)
      ..rotate(-pi / 4);
    for (double y = -len; y < len; y += stepY)
      for (double x = -len; x < len; x += stepX) txtPainter.paint(canvas, Offset(x, y));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant final CustomPainter oldDelegate) => false;
}
