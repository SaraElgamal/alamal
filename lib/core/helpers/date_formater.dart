import 'package:intl/intl.dart';

String formatArabicDate(String? isoDateString) {
  if (isoDateString == null || isoDateString.isEmpty) {
    return '';
  }
  // Parse the string to DateTime
  final date = DateTime.parse(isoDateString).toLocal();

  // Create formatters
  final dateFormatter = DateFormat('dd/MM/yyyy', 'en');
  final timeFormatter = DateFormat('hh:mm a', 'en');

  // Format date and time
  String formattedDate = dateFormatter.format(date);
  String formattedTime = timeFormatter.format(date);

  // Convert AM/PM to Arabic equivalents
  // formattedTime = Languages.currentLanguage.locale.languageCode == 'ar'
  //     ? formattedTime
  //         .replaceAll('ص', 'صباحاً')
  //         .replaceAll('م', 'مساءً')
  //         .replaceAll('AM', 'صباحاً')
  //         .replaceAll('PM', 'مساءً')
  //     : formattedTime;

  return '$formattedDate - $formattedTime';
}
