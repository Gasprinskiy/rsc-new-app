
import 'package:flutter/material.dart';

class ChangeUserSalaryInfoScreen extends StatefulWidget {
  const ChangeUserSalaryInfoScreen({super.key});

  @override
  State<ChangeUserSalaryInfoScreen> createState() => _ChangeUserSalaryInfoScreenState();
}

class _ChangeUserSalaryInfoScreenState extends State<ChangeUserSalaryInfoScreen> {  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Change salary info')),
    );
  }
}