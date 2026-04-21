import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class WatchlistShimmer extends StatefulWidget {
  const WatchlistShimmer({super.key});

  @override
  State<WatchlistShimmer> createState() => _WatchlistShimmerState();
}

class _WatchlistShimmerState extends State<WatchlistShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return ListView.builder(
          padding: const EdgeInsets.only(top: 6, bottom: 100),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 7,
          itemBuilder: (context, index) => _ShimmerTile(
            opacity: (0.4 + (_animation.value * 0.4)).clamp(0.0, 1.0),
          ),
        );
      },
    );
  }
}

class _ShimmerTile extends StatelessWidget {
  final double opacity;

  const _ShimmerTile({required this.opacity});

  Widget _box(double w, double h, {double radius = 6}) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(opacity),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          _box(42, 42, radius: 11),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(80, 14),
                const SizedBox(height: 6),
                _box(130, 11),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _box(80, 14),
              const SizedBox(height: 6),
              _box(60, 22, radius: 6),
            ],
          ),
        ],
      ),
    );
  }
}
