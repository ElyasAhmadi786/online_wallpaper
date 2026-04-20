// TODO 87: Import necessary packages
import 'package:flutter/material.dart';

// TODO 88: Import utils
import '../../utils/themes.dart';

// TODO 89: Define category chip widget
class CategoryChip extends StatelessWidget {
  final String name;
  final String iconName;
  final String colorName;
  final bool isLoading;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.name,
    required this.iconName,
    required this.colorName,
    required this.onTap,
    this.isLoading = false,
  });

  // TODO 90: Map icon names to Icons
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'landscape':
        return Icons.landscape;
      case 'brush':
        return Icons.brush;
      case 'computer':
        return Icons.computer;
      case 'pets':
        return Icons.pets;
      case 'rocket_launch':
        return Icons.rocket_launch;
      case 'search':
        return Icons.search;
      case 'favorite':
        return Icons.favorite;
      case 'category':
        return Icons.category;
      default:
        return Icons.explore;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = AppThemes.getCategoryColor(colorName);
    final icon = _getIconData(iconName);

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isLoading ? 0.08 : 0.18),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isLoading ? Colors.grey.shade700 : color,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            else
              Icon(icon, color: color, size: 40),
            const SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                color: isLoading ? Colors.grey : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}