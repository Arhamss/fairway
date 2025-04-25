import 'package:fairway/export.dart';

class FaqItem {
  const FaqItem({
    required this.question,
    required this.answer,
  });
  final String question;
  final String answer;
}

class ExpandableFaqItem extends StatefulWidget {
  const ExpandableFaqItem({
    required this.question,
    required this.answer,
    super.key,
  });

  final String question;
  final String answer;

  @override
  State<ExpandableFaqItem> createState() => _ExpandableFaqItemState();
}

class _ExpandableFaqItemState extends State<ExpandableFaqItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.question,
                        style: context.b1.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: isExpanded ? 0.5 : 0,
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 36,
                        color: AppColors.greyShade6,
                      ),
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Text(
                    widget.answer,
                    style: context.b2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
