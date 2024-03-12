import 'package:flutter/material.dart';

class UserRoute extends StatefulWidget {
  const UserRoute({super.key});

  @override
  State<UserRoute> createState() => _UserState();
}

class _UserState extends State<UserRoute> {
  String state = 'Some user info';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('USER'),
      ),
    );
  }
}
