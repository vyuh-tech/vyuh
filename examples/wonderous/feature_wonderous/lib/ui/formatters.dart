extension YearFormat on int {
  String get formattedYear {
    return this <= 0 ? '${-this} BCE' : '$this CE';
  }
}
