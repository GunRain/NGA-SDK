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

extension NGALet<T> on T? {
  R let<R>(R Function(T) f) {
    return f(this as T);
  }
}

extension NGAStr on String? {
  String ifEmpty(String s) {
    return this?.isEmpty ?? true ? s : this!;
  }
}
