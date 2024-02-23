import 'package:flutter/material.dart';
import 'package:test_flutter/constants/app_strings.dart';

class Alert {
  Future<void> show(
      BuildContext context, String title, String? subtitle) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(subtitle ?? ''),
            actions: <Widget>[
              TextButton(
                child: const Text(AppStrings.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
