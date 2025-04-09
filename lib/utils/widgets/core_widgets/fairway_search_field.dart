import 'package:fairway/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FairwaySmartSearchField extends StatelessWidget {
  const FairwaySmartSearchField({
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search Field
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.greyShade5,
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: context.b2.copyWith(
                  color: AppColors.greyShade2,
                  fontSize: 20,
                ),
                border: InputBorder.none,
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SvgPicture.asset(
                    AssetPaths.searchIcon, // Replace with your SVG path
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8, // Add vertical padding to center-align the text
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Cancel Button
        GestureDetector(
          onTap: () {
            controller.clear();
            if (onChanged != null) {
              onChanged!('');
            }
          },
          child: Text(
            'Cancel',
            style: context.l1.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
