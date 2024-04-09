import 'dart:math';
import 'package:flutter/material.dart';

class CircleBordersPainter extends CustomPainter {
  final String? centerText;
  final Map<int, double> map;
  final Map<int, Color> colorMap;

  CircleBordersPainter({
    this.centerText,
    required this.map, 
    required this.colorMap
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9.0
      ..strokeCap = StrokeCap.round;

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double maxRadius = min(centerX, centerY) - 5;

    double totalValue = map.values.reduce((value, element) => value + element);

    double startAngle = -pi / 2;
    if (map.length == 1) {
      for (int key in map.keys) {
        double segmentValue = map[key]!;
        double segmentAngle = (2 * pi * (segmentValue / totalValue));

        double radius = maxRadius; 
        
        paint.color = colorMap[key]!;
        canvas.drawArc(Rect.fromCircle(
            center: Offset(centerX, centerY), 
            radius: radius
          ),
          startAngle, 
          segmentAngle, 
          false, 
          paint
        );
        startAngle += segmentAngle;
      }
    } else {
      double gap = 0.12;
      if (map.length > 5) {
        gap = 0.10;
      } 
      
      if (map.length >= 9) {
        gap = 0.08;
      }

      for (int key in map.keys) {
        double segmentValue = map[key]!;
        double segmentAngle = (2 * pi * (segmentValue / totalValue)) - gap;

        double radius = maxRadius; 
        
        paint.color = colorMap[key]!;
        canvas.drawArc(Rect.fromCircle(
            center: Offset(centerX, centerY), 
            radius: radius
          ),
          startAngle, 
          segmentAngle, 
          false, 
          paint
        );
        startAngle += segmentAngle + gap;
      }
    }

    if (centerText != null) {
       TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: centerText ?? '',
          style: const TextStyle(
            color: Color(0xFF191C1B), 
            fontSize: 50.0
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      double textX = centerX - textPainter.width / 2;
      double textY = centerY - textPainter.height / 2;
      textPainter.paint(canvas, Offset(textX, textY));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}