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
// For full information about the F2DLPR License terms and policies, please visit: http://prl.fileto.download.   =
//================================================================================================================

import 'dart:async';

import 'package:flutter/material.dart';

class NGASplash {
  static final ok = ValueNotifier<bool>(false);
  static final indexChar = ValueNotifier<int>(0xE000);
  static final indexDot = ValueNotifier<String>("");
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

  static Widget view(Widget child, {Color? bgColor, Color? txtColor}) {
    indexCharTimer = Timer.periodic(Duration(milliseconds: 25),
        (timer) => indexChar.value = indexChar.value > 0xE076 ? 0xE000 : indexChar.value + 1);
    indexDotTimer = Timer.periodic(
      Duration(milliseconds: 500),
      (timer) => indexDot.value = (indexDot.value.length > 2) ? "" : ("${indexDot.value}."),
    );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          child,
          ValueListenableBuilder<bool>(
            valueListenable: ok,
            builder: (_, ok, __) => AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: ok
                  ? SizedBox.shrink()
                  : Builder(
                      key: ValueKey("nga_splash_view"),
                      builder: (context) {
                        final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
                        final targetBgColor = bgColor ?? (isDarkMode ? Color(0xFF000000) : Color(0xFFFFFFFF));
                        final targetTxtColor = txtColor ?? (isDarkMode ? Color(0xFFFFFFFF) : Color(0xFF000000));
                        final targetTxtStyle =
                            TextStyle(fontFamily: 'BOOT', package: 'nga_sdk', color: targetTxtColor);
                        return Container(
                          color: targetBgColor,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ValueListenableBuilder<int>(
                                valueListenable: indexChar,
                                builder: (_, char, __) =>
                                    Text(String.fromCharCode(char), style: targetTxtStyle.copyWith(fontSize: 40)),
                              ),
                              SizedBox(height: 10),
                              ValueListenableBuilder<String>(
                                valueListenable: indexDot,
                                builder: (_, dot, __) =>
                                    Text("Loading$dot", style: targetTxtStyle.copyWith(fontSize: 20)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
