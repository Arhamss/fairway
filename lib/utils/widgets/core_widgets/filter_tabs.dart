import 'package:fairway/constants/app_colors.dart';
import 'package:fairway/export.dart';
import 'package:flutter/material.dart';

class FairwayFilterTab extends StatelessWidget {
  const FairwayFilterTab({
    required this.label,
    required this.onRemove,
    this.backgroundColor = AppColors.filterChipColour,
    this.labelColor = AppColors.textPrimary,
    this.removeIconColor = AppColors.greyShade7,
    super.key,
  });

  final String label;
  final VoidCallback onRemove;
  final Color backgroundColor;
  final Color labelColor;
  final Color removeIconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: removeIconColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 12,
                color: backgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget to display multiple filter tabs
class FairwayFilterTabsList extends StatelessWidget {
  const FairwayFilterTabsList({
    required this.filters,
    required this.onRemoveFilter,
    this.padding,
    super.key,
  });

  final List<String> filters;
  final Function(String) onRemoveFilter;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: filters.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FairwayFilterTab(
              label: filter,
              onRemove: () => onRemoveFilter(filter),
            ),
          );
        }).toList(),
      ),
    );
  }
}
