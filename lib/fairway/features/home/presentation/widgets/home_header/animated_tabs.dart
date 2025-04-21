import 'package:fairway/export.dart';

class AnimatedTabs extends StatelessWidget {
  const AnimatedTabs({
    required this.selectedIndex,
    required this.onTabChanged,
    required this.tabTitles,
    this.isHomeHeader = false,
    super.key,
  });

  final int selectedIndex;
  final void Function(int index) onTabChanged;
  final List<String> tabTitles;
  final bool isHomeHeader;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tabWidth = constraints.maxWidth / tabTitles.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(tabTitles.length, (index) {
                final isSelected = index == selectedIndex;
                return GestureDetector(
                  onTap: () => onTabChanged(index),
                  child: SizedBox(
                    width: tabWidth,
                    child: Column(
                      children: [
                        Text(
                          tabTitles[index],
                          textAlign: TextAlign.center,
                          style: context.b1.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? AppColors.secondaryBlue
                                : AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 4),
            Stack(
              children: [
                Row(
                  children: List.generate(
                    tabTitles.length,
                    (index) {
                      return Container(
                        width: tabWidth,
                        height: 2,
                        color: isHomeHeader
                            ? Colors.transparent
                            : AppColors.grey.withValues(alpha: 0.1),
                      );
                    },
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: selectedIndex * tabWidth,
                  child: Container(
                    width: tabWidth,
                    alignment: Alignment.center,
                    child: Container(
                      height: 3,
                      width: tabWidth * 0.6,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryBlue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
