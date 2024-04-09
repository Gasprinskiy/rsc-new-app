
import 'package:flutter/material.dart';
import 'package:rsc/widgets/circular_painter.dart';

class StatisticsCircularDiagram extends StatelessWidget {
  final String? text;
  final Size? size;
  final Map<int, double> diagramMap;
  final Map<int, Color> monthColorsMap;

  const StatisticsCircularDiagram({
    super.key,
    this.text,
    this.size,
    required this.diagramMap,
    required this.monthColorsMap
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size ?? const Size(200, 200),
      painter: CircleBordersPainter(
        centerText: text,
        map: diagramMap,
        colorMap: monthColorsMap,
      ),
    );
  }
}