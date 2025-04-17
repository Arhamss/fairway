import 'package:fairway/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    required this.text,
    required this.svgPath,
    required this.onPressed,
    super.key,
    this.backgroundColor = AppColors.bluePrimary,
    this.textColor = AppColors.black,
    this.height = 56.0,
  });
  final String text;
  final String svgPath;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(
                  svgPath,
                ),
              ),
              Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Example usage for Apple button:
class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({
    required this.onPressed,
    super.key,
  });
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SocialButton(
      text: 'Connect with Apple',
      svgPath: 'assets/svgs/apple_logo.svg', // Make sure you have this SVG file
      onPressed: onPressed,
    );
  }
}
