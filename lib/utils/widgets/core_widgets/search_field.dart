import 'package:fairway/export.dart';
import 'package:google_fonts/google_fonts.dart';

class FairwaySearchField extends StatefulWidget {
  const FairwaySearchField({
    required this.controller,
    this.padding = EdgeInsets.zero,
    this.labelText,
    this.hintText,
    this.hintColor,
    this.validator,
    this.prefixPath,
    this.suffixPath,
    this.fillColor,
    this.labelSpacing,
    this.selectedBorderColor = AppColors.black,
    this.borderColor = AppColors.textFieldBorder,
    this.suffixOnTap,
    this.prefixOnTap,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final EdgeInsetsGeometry padding;
  final String? labelText;
  final String? hintText;
  final Color? hintColor;
  final String? Function(String?)? validator;
  final String? prefixPath;
  final String? suffixPath;
  final Color? fillColor;
  final double? labelSpacing;
  final Color borderColor;
  final Color selectedBorderColor;
  final VoidCallback? suffixOnTap;
  final VoidCallback? prefixOnTap;
  final ValueChanged<String>? onChanged;

  @override
  State<FairwaySearchField> createState() => _FairwaySearchFieldState();
}

class _FairwaySearchFieldState extends State<FairwaySearchField> {
  final FocusNode _focusNode = FocusNode();
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _updateErrorState(bool hasError) {
    setState(() {
      _hasError = hasError;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _hasError
        ? AppColors.error
        : (_focusNode.hasFocus
            ? widget.selectedBorderColor
            : AppColors.disabled);

    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText != null) ...[
            Text(
              widget.labelText ?? '',
              style: context.t1.customCopyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: widget.labelSpacing ?? 4),
          ],
          TextFormField(
            focusNode: _focusNode,
            autocorrect: false,
            cursorWidth: 1,
            controller: widget.controller,
            keyboardType: TextInputType.text,
            cursorColor: AppColors.textDark,
            decoration: InputDecoration(
              filled: widget.fillColor != null,
              fillColor: widget.fillColor,
              hintText: widget.hintText,
              hintStyle: GoogleFonts.urbanist(
                color: AppColors.disabled,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 18,
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 18,
              ),
              suffixIcon: widget.controller.text.isNotEmpty
                  ? GestureDetector(
                      onTap: widget.suffixOnTap,
                      child: widget.suffixPath != null
                          ? SvgPicture.asset(
                              widget.suffixPath!,
                              colorFilter: ColorFilter.mode(
                                iconColor,
                                BlendMode.srcIn,
                              ),
                            )
                          : SvgPicture.asset(
                              AssetPaths.closeCircleIcon,
                              colorFilter: ColorFilter.mode(
                                iconColor,
                                BlendMode.srcIn,
                              ),
                            ),
                    )
                  : null,
              prefixIcon: GestureDetector(
                onTap: widget.prefixOnTap,
                child: widget.prefixPath != null
                    ? SvgPicture.asset(
                        widget.prefixPath!,
                        colorFilter: ColorFilter.mode(
                          iconColor,
                          BlendMode.srcIn,
                        ),
                      )
                    : SvgPicture.asset(
                        AssetPaths.searchIcon,
                        colorFilter: ColorFilter.mode(
                          iconColor,
                          BlendMode.srcIn,
                        ),
                      ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(
                  color: AppColors.amberPrimary,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(
                  color: _hasError
                      ? AppColors.error
                      : (_focusNode.hasFocus
                          ? widget.selectedBorderColor
                          : widget.borderColor),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(
                  color:
                      _hasError ? AppColors.error : widget.selectedBorderColor,
                ),
              ),
              contentPadding: EdgeInsets.zero,
              errorStyle: const TextStyle(
                color: AppColors.error,
              ),
            ),
            onChanged: widget.onChanged,
            validator: (value) {
              final errorText = widget.validator?.call(value);
              _updateErrorState(errorText != null);
              return errorText;
            },
          ),
        ],
      ),
    );
  }
}
