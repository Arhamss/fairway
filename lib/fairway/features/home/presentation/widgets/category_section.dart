import 'package:fairway/constants/app_text_style.dart';
import 'package:fairway/constants/asset_paths.dart';
import 'package:flutter/material.dart';
import 'package:fairway/constants/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'SVG': AssetPaths.sandwiches, 'label': 'Sandwich'},
      {'SVG': AssetPaths.pizza, 'label': 'Pizza'},
      {'SVG': AssetPaths.burgers, 'label': 'Burgers'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Category',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See all',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.18, // Fixed height for the row
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: categories.map((category) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width /
                      3.5, // Set fixed width
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.greyShade5,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          child: SvgPicture.asset(
                            category['SVG']!,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        category['label']!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
