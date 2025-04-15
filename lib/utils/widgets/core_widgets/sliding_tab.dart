import 'package:fairway/constants/app_colors.dart';
import 'package:fairway/constants/app_text_style.dart';
import 'package:flutter/material.dart';

class FairwaySlidingTab extends StatefulWidget {
  const FairwaySlidingTab({
    required this.textOne,
    required this.textTwo,
    required this.onTapOne,
    required this.onTapTwo,
    this.height,
    this.width,
    this.textStyle,
    this.selectedColor,
    this.initialIndex = 0,
    this.shortenWidth = false,
    super.key,
  });

  final String textOne;
  final String textTwo;
  final VoidCallback onTapOne;
  final VoidCallback onTapTwo;
  final double? height;
  final double? width;
  final TextStyle? textStyle;
  final Color? selectedColor;
  final int initialIndex;
  final bool shortenWidth;

  @override
  State<FairwaySlidingTab> createState() => _FairwaySlidingTabState();
}

class _FairwaySlidingTabState extends State<FairwaySlidingTab> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    if (widget.width != null) {
      width = widget.width!;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      width: widget.width ?? double.infinity,
      height: widget.height != null ? widget.height! + 16 : 48,
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            alignment: selectedIndex == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              width: widget.shortenWidth ? (width - 8) / 2.2 : (width - 8) / 2,
              decoration: BoxDecoration(
                color: widget.selectedColor ?? AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.greenSecondary,
                  width: 0.75,
                ),
              ),
            ),
          ),
          // Tab options
          Row(
            children: [
              // Left Tab
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                      widget.onTapOne();
                    });
                  },
                  child: Center(
                    child: Text(
                      widget.textOne,
                      style: (widget.textStyle ?? context.b3).copyWith(
                        fontSize: 14,
                        color: selectedIndex == 0 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              // Right Tab
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                      widget.onTapTwo();
                    });
                  },
                  child: Center(
                    child: Text(
                      widget.textTwo,
                      style: (widget.textStyle ?? context.b3).copyWith(
                        fontSize: 14,
                        color: selectedIndex == 1 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
