import 'package:fairway/constants/export.dart';
import 'package:fairway/export.dart';
import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Terms of Service',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(title: 'Terms'),
              SizedBox(height: 8),
              SectionContent(
                content:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
                    "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
              ),
              SizedBox(height: 16),
              SectionContent(
                content:
                    'when an unknown printer took a galley of type and scrambled it to make a type '
                    'specimen book. It has survived not only five centuries, but also the leap into '
                    'electronic typesetting.',
              ),
              SizedBox(height: 24),

              // Changes section
              SectionTitle(title: 'Changes with Service and Terms'),
              SizedBox(height: 8),
              SectionContent(
                content:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
                    "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
              ),
              SizedBox(height: 24),

              // Terms & Conditions section
              SectionTitle(title: 'Term & Conditions'),
              SizedBox(height: 8),
              SectionContent(
                content:
                    'To make a type specimen book. It has survived not only five centuries, but also '
                    'the leap into electronic typesetting, remaining essentially unchanged. It was '
                    'popularised in the 1960s with the release of Letraset sheets containing Lorem '
                    'Ipsum passages, and more recently with desktop publishing software '
                    'like Aldus PageMaker including versions of Lorem Ipsum.',
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.title,
    super.key,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class SectionContent extends StatelessWidget {
  const SectionContent({
    required this.content,
    super.key,
  });
  final String content;

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 16,
        height: 1.7,
      ),
    );
  }
}
