import 'package:fairway/constants/export.dart';
import 'package:flutter/material.dart';

class IntroductionWidget extends StatelessWidget {
  const IntroductionWidget({
    required this.imagePath,
    required this.title,
    required this.description,
    super.key,
  });
  final String imagePath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath),
          const SizedBox(height: 30),
          Text(
            title,
            style: context.h1.copyWith(
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: context.t1.copyWith(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
