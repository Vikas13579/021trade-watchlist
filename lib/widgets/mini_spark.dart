import 'package:flutter/material.dart';
import 'dart:math';
import '../models/stock.dart';

class MiniSpark extends StatelessWidget {
  final StockTrend trend;
  final Color color;

  const MiniSpark({super.key, required this.trend, required this.color});

  List<double> _generatePoints() {
    final rng = Random(trend.hashCode);
    final List<double> points = [];
    double val = 0.5;

    for (int i = 0; i < 10; i++) {
      final bias = switch (trend) {
        StockTrend.up => 0.06,
        StockTrend.down => -0.06,
        StockTrend.neutral => 0.0,
      };
      val += (rng.nextDouble() - 0.48) + bias;
      val = val.clamp(0.05, 0.95);
      points.add(val);
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 55,
      height: 30,
      child: CustomPaint(
        painter: _SparkPainter(points: _generatePoints(), color: color),
      ),
    );
  }
}

class _SparkPainter extends CustomPainter {
  final List<double> points;
  final Color color;

  _SparkPainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final fillPath = Path();

    final dx = size.width / (points.length - 1);

    for (int i = 0; i < points.length; i++) {
      final x = i * dx;
      final y = size.height - (points[i] * size.height);
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.18), color.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SparkPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.color != color;
}
