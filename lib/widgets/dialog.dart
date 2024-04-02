import 'package:flutter/material.dart';
import 'package:test_flutter/constants/app_strings.dart';

// class Alert {
//   Future<void> show(
//       BuildContext context, String title, String? subtitle) async {
//     return showDialog<void>(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text(title),
//             content: Text(subtitle ?? ''),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text(AppStrings.close),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         });
//   }
// }

class AppDialog {
  static AppDialog? _instance;

  AppDialog._();

  static AppDialog getInstance() {
    _instance ??= AppDialog._();
    return _instance!;
  }

  void show(
    BuildContext context, 
    String title,
    bool? closeOnBlur,
    Widget? content,
    List<Widget>? actions,
  ) {
    showDialog(
      context: context, 
      barrierDismissible: closeOnBlur ?? false,
      builder: (BuildContext builder) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          scrollable: true,
          title: Text(title, style: const TextStyle(fontSize: 18)),
          content: content,
          actions: actions,
        );
      }
    );
  }
}
