part of 'watchlist_bloc.dart';

enum WatchlistStatus { initial, loading, success, failure }

class WatchlistState extends Equatable {
  final WatchlistStatus status;
  final List<Stock> stocks;
  final bool isEditMode;
  final String? errorMessage;

  const WatchlistState({
    this.status = WatchlistStatus.initial,
    this.stocks = const [],
    this.isEditMode = false,
    this.errorMessage,
  });

  WatchlistState copyWith({
    WatchlistStatus? status,
    List<Stock>? stocks,
    bool? isEditMode,
    String? errorMessage,
  }) {
    return WatchlistState(
      status: status ?? this.status,
      stocks: stocks ?? this.stocks,
      isEditMode: isEditMode ?? this.isEditMode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, stocks, isEditMode, errorMessage];
}
