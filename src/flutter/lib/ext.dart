// NGA SDK by Sakitin(GitHub@GunRain 酷安@芙洛洛 bilibili@安音咲汀)

// GitHub link: https://github.com/GunRain/NGA-SDK

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
