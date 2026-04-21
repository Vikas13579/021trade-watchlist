import 'package:equatable/equatable.dart';

enum StockTrend { up, down, neutral }

class Stock extends Equatable {
  final String id;
  final String symbol;
  final String companyName;
  final double price;
  final double change;
  final double changePercent;
  final StockTrend trend;
  final String exchange;
  final double volume;

  const Stock({
    required this.id,
    required this.symbol,
    required this.companyName,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.exchange,
    required this.volume,
  }) : trend = change > 0
           ? StockTrend.up
           : change < 0
           ? StockTrend.down
           : StockTrend.neutral;

  const Stock._internal({
    required this.id,
    required this.symbol,
    required this.companyName,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.trend,
    required this.exchange,
    required this.volume,
  });

  Stock copyWith({
    String? id,
    String? symbol,
    String? companyName,
    double? price,
    double? change,
    double? changePercent,
    String? exchange,
    double? volume,
  }) {
    final newChange = change ?? this.change;
    return Stock._internal(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      companyName: companyName ?? this.companyName,
      price: price ?? this.price,
      change: newChange,
      changePercent: changePercent ?? this.changePercent,
      trend: newChange > 0
          ? StockTrend.up
          : newChange < 0
          ? StockTrend.down
          : StockTrend.neutral,
      exchange: exchange ?? this.exchange,
      volume: volume ?? this.volume,
    );
  }

  @override
  List<Object?> get props => [
    id,
    symbol,
    companyName,
    price,
    change,
    changePercent,
    trend,
    exchange,
    volume,
  ];
}
