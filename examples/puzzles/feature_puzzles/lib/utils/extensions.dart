extension IntExtensions on int {
  String get toTwoDigits {
    if (this >= 10) return "$this";
    return "0$this";
  }
}
