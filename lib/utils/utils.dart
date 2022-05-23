import 'package:intl/intl.dart';

class Utils {
  static final DateFormat formatter = DateFormat('dd-MM-yyyy');

  static String formatDate(DateTime date) {
    return formatter.format(date);
  }

  static bool isNumeric(string) => num.tryParse(string) != null;
}
