// TODO 75: Import necessary packages
import 'package:flutter/material.dart';

// TODO 76: Define reusable loading indicator widget
class LoadingIndicator extends StatelessWidget {
  final String message;
  final Color color;

  const LoadingIndicator({
    super.key,
    this.message = 'Loading...',
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: color),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// TODO 77: Define loading indicator for grid items
class GridLoadingIndicator extends StatefulWidget {
  final int itemCount;
  final double aspectRatio;

  const GridLoadingIndicator({
    super.key,
    this.itemCount = 6,
    this.aspectRatio = 0.7,
  });

  @override
  State<GridLoadingIndicator> createState() => _GridLoadingIndicatorState();
}

class _GridLoadingIndicatorState extends State<GridLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
      builder: (context, child) {
        return GridView.builder(
          // Non-scrollable: this widget is only shown while the actual
          // scrollable grid is loading; it acts as a placeholder skeleton.
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: widget.aspectRatio,
          ),
          itemCount: widget.itemCount,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Color.lerp(
                  Colors.grey[900],
                  Colors.grey[700],
                  _animation.value,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            );
          },
        );
      },
    );
  }
}