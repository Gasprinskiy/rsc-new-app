
import 'package:flutter/material.dart';

class PrepaymentsScreen extends StatefulWidget {
  const PrepaymentsScreen({super.key});

  @override
  State<PrepaymentsScreen> createState() => _PrepaymentsScreenState();
}

class _PrepaymentsScreenState extends State<PrepaymentsScreen> { 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Prepayments')),
    );
  }
}