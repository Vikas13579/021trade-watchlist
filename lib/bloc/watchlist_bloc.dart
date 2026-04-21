import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tahadiamond_flutter_task/bloc/watchlist_event.dart';
import '../models/sample_data.dart';
import '../models/stock.dart';

part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc() : super(const WatchlistState()) {

    on<WatchlistLoaded>(_onLoaded);
    on<WatchlistReordered>(_onReordered);
    on<WatchlistStockRemoved>(_onStockRemoved);
    on<WatchlistEditModeToggled>(_onEditModeToggled);
  }

  void _onLoaded(WatchlistLoaded event, Emitter<WatchlistState> emit) async {
    emit(state.copyWith(status: WatchlistStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 600));
      final stocks = SampleData.watchlistStocks;

      emit(state.copyWith(status: WatchlistStatus.success, stocks: stocks));
    } catch (e) {
      emit(
        state.copyWith(
          status: WatchlistStatus.failure,
          errorMessage: 'Failed to load watchlist. Please try again.',
        ),
      );
    }
  }

  void _onReordered(WatchlistReordered event, Emitter<WatchlistState> emit) {
    final stocks = List<Stock>.from(state.stocks);
    final int oldIndex = event.oldIndex;
    int newIndex = event.newIndex;

    if (newIndex > oldIndex) newIndex -= 1;

    final Stock movedItem = stocks.removeAt(oldIndex);
    stocks.insert(newIndex, movedItem);

    emit(state.copyWith(stocks: stocks));
  }

  void _onStockRemoved(
    WatchlistStockRemoved event,
    Emitter<WatchlistState> emit,
  ) {
    final updatedStocks = state.stocks
        .where((s) => s.id != event.stockId)
        .toList();
    emit(state.copyWith(stocks: updatedStocks));
  }

  void _onEditModeToggled(
    WatchlistEditModeToggled event,
    Emitter<WatchlistState> emit,
  ) {
    emit(state.copyWith(isEditMode: !state.isEditMode));
  }
}
