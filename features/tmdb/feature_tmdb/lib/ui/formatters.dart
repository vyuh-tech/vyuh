import 'package:feature_tmdb/utils/constants.dart';
import 'package:intl/intl.dart';

final intFormat = NumberFormat.decimalPatternDigits(decimalDigits: 0);
const defaultLengthLimit = 9;

class DateFormatters {
  static final DateFormat namedMonthFormat = DateFormat('dd MMM, yyyy');
  static final DateFormat numericDateFormat = DateFormat('dd-MM-yyyy');
  static final DateFormat yearFormat = DateFormat('yyyy');
}

extension FormattedDate on DateFormat {
  String tryFormat(DateTime? date) => date != null ? format(date) : '-';
}

extension DateTimeFormatting on DateTime? {
  String get formattedNumericDate =>
      DateFormatters.numericDateFormat.tryFormat(this);

  String get formattedNamedMonth =>
      DateFormatters.namedMonthFormat.tryFormat(this);

  String get formattedYear => DateFormatters.yearFormat.tryFormat(this);
}

extension FormattedNumber on num {
  String get formattedInt => intFormat.format(this);
}

extension LimitListCount<T> on List<T> {
  bool get shouldShowViewAll => length > maxCountForViewAll;
}

extension Vote on double? {
  String get percentage => (this ?? 0 * 10).round().toString();
}

extension ListExtensions<T> on List<T> {
  List<T> limited([int limit = defaultLengthLimit]) => take(limit).toList();
}

extension StringExtensions on String? {
  String get safeValue => this ?? '-';
}
