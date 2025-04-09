import 'package:fairway/export.dart';

class FairwaySmartSearchField extends StatefulWidget {
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
  State<FairwaySmartSearchField> createState() =>
      _FairwaySmartSearchFieldState();
}

class _FairwaySmartSearchFieldState extends State<FairwaySmartSearchField> {
  bool _showClearIcon = false;

  @override
  void initState() {
    super.initState();
    _showClearIcon = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    setState(() {
      _showClearIcon = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search Field
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.greyShade5,
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: context.b2.copyWith(
                  color: AppColors.greyShade2,
                ),
                border: InputBorder.none,
                isDense: true,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: SvgPicture.asset(
                    AssetPaths.searchIcon,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minHeight: 24,
                  minWidth: 40,
                ),
                suffixIcon: _showClearIcon
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          widget.controller.clear();
                          widget.onChanged?.call('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
