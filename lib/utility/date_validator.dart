import 'package:intl/intl.dart';

class DateValidator {
  static String ValidateDate(String date) {
    if (date.toLowerCase() == 'today') {
      return DateTime.now().toLocal().toString().split(' ')[0];
    }
    final List<String> acceptedFormats = [
      'yyyy/MM/dd',
      'yyyy/M/d',
      'MM/dd/yyyy',
      'M/D/yyyy',
      'yyyy-M-d',
      'M-d-yyyy',
      'MM-dd-yyyy'
    ];
    DateTime? parsedDate;
    final RegExp dateFormat = RegExp(r'^\d{4}-\d{2}-\d{2}$');

    if (dateFormat.hasMatch(date)) {
      return date;
    } else {
      for (String format in acceptedFormats) {
        try {
          parsedDate = DateFormat(format).parseLoose(date);
        } catch (error) {}
      }
      if (parsedDate != null) {
        return DateFormat('yyyy-MM-dd').format(parsedDate);
      } else {
        return '';
      }
    }
  }
}
