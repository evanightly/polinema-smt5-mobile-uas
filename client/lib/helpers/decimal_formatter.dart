import 'package:intl/intl.dart';

NumberFormat _numberFormat = NumberFormat.decimalPattern();

formatNumber(num number) {
  return _numberFormat.format(number);
}
