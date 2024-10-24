extension IntExtension on int {
  /// Returns the number of cells in the cross axis for a staggered grid layout based on the given [index].
  ///
  /// The [index] parameter is used to determine the number of cells in the cross axis based on the value of `this`.
  ///
  /// The following rules are applied:
  /// - If `this` is 5, returns 2.
  /// - If `this` is 6, 8, or 10, returns 1 if [index] is greater than 3, otherwise returns 2.
  /// - If `this` is 7, returns 1 if [index] is greater than 2, otherwise returns 2.
  /// - If `this` is 9, returns 1 if [index] is greater than 4, otherwise returns 2.
  /// - For any other value of `this`, returns 2.
  int staggeredCrossAxisCellCount(int index) {
    switch (this) {
      case 5:
        return 2;
      case 6:
      case 8:
      case 10:
        return index > 3 ? 1 : 2;
      case 7:
        return index > 2 ? 1 : 2;
      case 9:
        return index > 4 ? 1 : 2;
      default:
        return 2;
    }
  }

  int get staggeredMainAxisCellCount {
    return this == 0 ? 2 : 1;
  }
}
