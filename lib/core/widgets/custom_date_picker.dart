// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:lost/src/config/res/app_sizes.dart';
// import 'package:lost/src/core/extensions/context_extension.dart';

// import '../../config/language/languages.dart';
// import '../navigation/navigation.dart';

// Future<DateTime?> showCustomDatePicker(
//     {required TextEditingController controller,
//     String? dateFormat,
//     DateTime? firstDate,
//     DateTime? lastDate,
//     DateTime? initialDate}) async {
//   DateTime? pickedDate = await showDatePicker(
//     locale: Languages.currentLanguage.locale,
//     context: NavigationService.navigatorKey.currentContext!,
//     initialDate: initialDate ?? DateTime.now(),
//     firstDate: firstDate ?? DateTime.now(),
//     initialEntryMode: DatePickerEntryMode.calendarOnly,
//     lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365 * 4)),
//     // lastDate: DateTime(2100),
//     builder: (context, child) {
//       return Theme(
//         data: Theme.of(context).copyWith(
//           colorScheme: ColorScheme.light(
//             primary: context.colors.primary,
//             onPrimary: context.colors.white,
//             onSurface: context.colors.primary,
//             surface: context.colors.card,
//           ),
//           textTheme: Theme.of(context).textTheme.copyWith(
//                 bodyLarge: TextStyle(
//                   color: context.colors.textSubtle,
//                   fontSize: FontSize.s16,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 bodyMedium: TextStyle(
//                   color: context.colors.text,
//                   fontSize: FontSize.s14,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 bodySmall: TextStyle(
//                   color: context.colors.textSubtle,
//                   fontSize: FontSize.s12,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//           textButtonTheme: TextButtonThemeData(
//             style: TextButton.styleFrom(
//               foregroundColor: context.colors.primary, // button text color
//             ),
//           ),
//         ),
//         child: child!,
//       );
//     },
//   );
//   if (pickedDate != null) {
//     String formattedDate =
//         DateFormat(dateFormat ?? 'EEE, M/d/y', Languages.currentLanguage.locale.languageCode)
//             .format(pickedDate); // use your desired date format
//     controller.text = formattedDate;
//   }
//   return pickedDate;
// }
