import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../themes/app_theme.dart';
import '../widgets/stock_tile.dart';
import 'watchlist_empty.dart';
import 'watchlist_error.dart';
import 'watchlist_shimmer.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _WatchlistAppBar(),
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          return switch (state.status) {
            WatchlistStatus.initial ||
            WatchlistStatus.loading => const WatchlistShimmer(),
            WatchlistStatus.failure => WatchlistError(
              message: state.errorMessage ?? 'Something went wrong.',
              onRetry: () =>
                  context.read<WatchlistBloc>().add(const WatchlistLoaded()),
            ),
            WatchlistStatus.success =>
              state.stocks.isEmpty
                  ? const WatchlistEmpty()
                  : _WatchlistBody(state: state),
          };
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// AppBar
// ─────────────────────────────────────────────
class _WatchlistAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 44);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        final isEditMode = state.isEditMode;

        return AppBar(
          backgroundColor: AppColors.background,
          toolbarHeight: kToolbarHeight + 44,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Logo / Brand mark
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.accent, AppColors.accentDim],
                          ),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Center(
                          child: Text(
                            '021',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Watchlist',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Spacer(),

                      // Edit / Done toggle button
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: GestureDetector(
                          key: ValueKey(isEditMode),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            context.read<WatchlistBloc>().add(
                              const WatchlistEditModeToggled(),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isEditMode
                                  ? AppColors.accent.withOpacity(0.15)
                                  : AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isEditMode
                                    ? AppColors.accent.withOpacity(0.4)
                                    : AppColors.cardBorder,
                              ),
                            ),
                            child: Text(
                              isEditMode ? 'Done' : 'Edit',
                              style: TextStyle(
                                color: isEditMode
                                    ? AppColors.accent
                                    : AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Sub-header with count
                  Row(
                    children: [
                      Text(
                        '${state.stocks.length} stocks',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (isEditMode) ...[
                        const SizedBox(width: 8),
                        const Text(
                          '· Hold & drag to reorder',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Main List Body
// ─────────────────────────────────────────────
class _WatchlistBody extends StatelessWidget {
  final WatchlistState state;

  const _WatchlistBody({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isEditMode) {
      return _ReorderableList(state: state);
    }
    return _NormalList(state: state);
  }
}

// Normal scrollable list (non-edit mode)
class _NormalList extends StatelessWidget {
  final WatchlistState state;

  const _NormalList({required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 6, bottom: 100),
      itemCount: state.stocks.length,
      itemBuilder: (context, index) {
        final stock = state.stocks[index];
        return StockTile(
          key: ValueKey(stock.id),
          stock: stock,
          isEditMode: false,
        );
      },
    );
  }
}

// ReorderableListView (edit mode)
class _ReorderableList extends StatelessWidget {
  final WatchlistState state;

  const _ReorderableList({required this.state});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: ReorderableListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 6, bottom: 100),
        proxyDecorator: (child, index, animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final double elevation = Tween<double>(begin: 0, end: 1)
                  .animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  )
                  .value;
              return Transform.scale(
                scale: 1.0 + (elevation * 0.03),
                child: Opacity(opacity: 0.92, child: child),
              );
            },
            child: child,
          );
        },
        itemCount: state.stocks.length,
        itemBuilder: (context, index) {
          final stock = state.stocks[index];
          return StockTile(
            key: ValueKey(stock.id),
            stock: stock,
            isEditMode: true,
            onRemove: () {
              HapticFeedback.mediumImpact();
              context.read<WatchlistBloc>().add(
                WatchlistStockRemoved(stockId: stock.id),
              );
            },
          );
        },
        onReorder: (oldIndex, newIndex) {
          HapticFeedback.selectionClick();
          context.read<WatchlistBloc>().add(
            WatchlistReordered(oldIndex: oldIndex, newIndex: newIndex),
          );
        },
      ),
    );
  }
}
