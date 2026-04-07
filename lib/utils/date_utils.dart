import 'package:intl/intl.dart';

class StandardDateUtils {

  static String getCurrentDate() {
    DateTime date = DateTime.now();
    String formattedDate = DateFormat('yyyy/MM/dd').format(date);
    return formattedDate;
  }
}
