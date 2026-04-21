// lib/widgets/stock_tile.dart

import 'package:flutter/material.dart';
import '../models/stock.dart';

import '../themes/app_theme.dart';
import '../utils/formaters.dart';
import 'trend_badge.dart';
import 'mini_spark.dart';

class StockTile extends StatelessWidget {
  final Stock stock;
  final bool isEditMode;
  final VoidCallback? onRemove;

  const StockTile({
    super.key,
    required this.stock,
    required this.isEditMode,
    this.onRemove,
  });

  Color get _trendColor {
    return switch (stock.trend) {
      StockTrend.up => AppColors.gainGreen,
      StockTrend.down => AppColors.lossRed,
      StockTrend.neutral => AppColors.neutral,
    };
  }

  Color get _trendDimColor {
    return switch (stock.trend) {
      StockTrend.up => AppColors.gainGreenDim,
      StockTrend.down => AppColors.lossRedDim,
      StockTrend.neutral => AppColors.surfaceVariant,
    };
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isEditMode ? AppColors.accent.withOpacity(0.25) : AppColors.cardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEditMode ? null : () {},
            splashColor: AppColors.accent.withOpacity(0.05),
            highlightColor: AppColors.surfaceVariant.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Drag handle (edit mode) OR remove button
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: isEditMode
                        ? _buildEditControls()
                        : const SizedBox(width: 0),
                  ),

                  // Symbol avatar
                  _SymbolAvatar(symbol: stock.symbol, trendColor: _trendColor),
                  const SizedBox(width: 12),

                  // Name & exchange
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stock.symbol,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            _ExchangeBadge(exchange: stock.exchange),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                stock.companyName,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Spark chart
                  if (!isEditMode) ...[
                    MiniSpark(trend: stock.trend, color: _trendColor),
                    const SizedBox(width: 12),
                  ],

                  // Price & change
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Formatters.formatPrice(stock.price),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TrendBadge(
                        change: stock.change,
                        changePercent: stock.changePercent,
                        trend: stock.trend,
                        trendColor: _trendColor,
                        trendDimColor: _trendDimColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onRemove,
          child: Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppColors.lossRed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.remove, color: Colors.white, size: 14),
          ),
        ),
        const Icon(
          Icons.drag_handle_rounded,
          color: AppColors.dragHandle,
          size: 22,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _SymbolAvatar extends StatelessWidget {
  final String symbol;
  final Color trendColor;

  const _SymbolAvatar({required this.symbol, required this.trendColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Center(
        child: Text(
          symbol.length > 3 ? symbol.substring(0, 3) : symbol,
          style: TextStyle(
            color: trendColor,
            fontSize: symbol.length > 3 ? 9 : 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

class _ExchangeBadge extends StatelessWidget {
  final String exchange;

  const _ExchangeBadge({required this.exchange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
      ),
      child: Text(
        exchange,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}