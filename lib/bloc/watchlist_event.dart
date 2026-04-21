import 'package:equatable/equatable.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class WatchlistLoaded extends WatchlistEvent {
  const WatchlistLoaded();
}

class WatchlistReordered extends WatchlistEvent {
  final int oldIndex;
  final int newIndex;

  const WatchlistReordered({required this.oldIndex, required this.newIndex});

  @override
  List<Object?> get props => [oldIndex, newIndex];
}

class WatchlistStockRemoved extends WatchlistEvent {
  final String stockId;

  const WatchlistStockRemoved({required this.stockId});

  @override
  List<Object?> get props => [stockId];
}

class WatchlistEditModeToggled extends WatchlistEvent {
  const WatchlistEditModeToggled();
}
