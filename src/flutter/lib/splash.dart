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

import 'dart:async';

import 'package:flutter/material.dart';

import 'nga.dart';

class NGASplash {
  static final ok = ValueNotifier(false);
  static final indexChar = ValueNotifier(0xE000);
  static final indexDot = ValueNotifier('');
  static late Timer indexCharTimer;
  static late Timer indexDotTimer;
  static void remove() {
    ok.value = true;
  }

  static void removeAll() {
    indexCharTimer.cancel();
    indexDotTimer.cancel();
    ok.value = true;
  }

  static void show() {
    ok.value = false;
  }

  static Widget view(
    final Widget child, {
    final Color? bgColor,
    final Color? txtColor,
    final Future<void>? func,
    final String watermarkTxt = '',
    final bool watermarkColorful = false,
  }) {
    indexCharTimer = Timer.periodic(
      const Duration(milliseconds: 25),
      (final Timer timer) => indexChar.value = indexChar.value > 0xE076 ? 0xE000 : indexChar.value + 1,
    );
    indexDotTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (final Timer timer) => indexDot.value = (indexDot.value.length > 2) ? '' : '${indexDot.value}.',
    );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          RepaintBoundary(
            child: FutureBuilder(
              future: func,
              builder: (final _, final snapshot) =>
                  snapshot.connectionState == ConnectionState.done ? child : const SizedBox.shrink(),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: ok,
            builder: (final _, final bool ok, final __) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: ok
                  ? const SizedBox.shrink()
                  : Builder(
                      key: const ValueKey('nga_splash_view'),
                      builder: (final ctx) {
                        final isDarkMode = MediaQuery.of(ctx).platformBrightness == Brightness.dark;
                        final targetBgColor =
                            bgColor ?? (isDarkMode ? const Color(0xFF000000) : const Color(0xFFF8F8F8));
                        final targetTxtColor =
                            txtColor ?? (isDarkMode ? const Color(0xFFF8F8F8) : const Color(0xFF000000));
                        final targetTxtStyle =
                            TextStyle(fontFamily: 'BOOT', package: 'nga_sdk', color: targetTxtColor);
                        return Container(
                          color: targetBgColor,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: indexChar,
                                builder: (final _, final int char, final __) => Text(
                                  String.fromCharCode(char),
                                  style: targetTxtStyle.copyWith(fontSize: 40),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ValueListenableBuilder(
                                valueListenable: indexDot,
                                builder: (final _, final String dot, final __) =>
                                    Text('Loading$dot', style: targetTxtStyle.copyWith(fontSize: 20)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
          if (watermarkTxt.isNotEmpty)
            Builder(
              builder: (final ctx) => NGAWatermark.get(ctx, watermarkTxt, colorful: watermarkColorful),
            ),
        ],
      ),
    );
  }
}

extension NGASplashExt on Widget {
  Widget withLoadingView({
    final Color? bgColor,
    final Color? txtColor,
    final Future<void>? func,
    final String watermarkTxt = '',
    final bool watermarkColorful = false,
  }) =>
      NGASplash.view(
        this,
        bgColor: bgColor,
        txtColor: txtColor,
        func: func,
        watermarkTxt: watermarkTxt,
        watermarkColorful: watermarkColorful,
      );
}
