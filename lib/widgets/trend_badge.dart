import 'package:flutter/material.dart';
import '../models/stock.dart';
import '../utils/formaters.dart';

class TrendBadge extends StatelessWidget {
  final double change;
  final double changePercent;
  final StockTrend trend;
  final Color trendColor;
  final Color trendDimColor;

  const TrendBadge({
    super.key,
    required this.change,
    required this.changePercent,
    required this.trend,
    required this.trendColor,
    required this.trendDimColor,
  });

  IconData get _icon {
    return switch (trend) {
      StockTrend.up => Icons.arrow_drop_up_rounded,
      StockTrend.down => Icons.arrow_drop_down_rounded,
      StockTrend.neutral => Icons.remove,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: trendDimColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, color: trendColor, size: 14),
          const SizedBox(width: 1),
          Text(
            Formatters.formatChangePercent(changePercent),
            style: TextStyle(
              color: trendColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
