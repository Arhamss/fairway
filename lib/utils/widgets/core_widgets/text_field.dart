import 'package:fairway/export.dart';
import 'package:google_fonts/google_fonts.dart';

enum FairwayTextFieldType { email, password, description, number, text }

class FairwayTextField extends StatefulWidget {
  FairwayTextField({
    required this.controller,
    this.padding = EdgeInsets.zero,
    this.labelText,
    this.hintText,
    this.hintColor,
    this.type = FairwayTextFieldType.text,
    this.validator,
    this.prefixPath,
    this.suffixPath,
    this.contentPadding,
    this.readOnly,
    this.descriptionMaxCharacter = 200,
    this.regularMaxCharacter = 100,
    this.onTap,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final EdgeInsetsGeometry padding;
  final String? labelText;
  final String? hintText;
  final Color? hintColor;
  final FairwayTextFieldType type;
  final String? Function(String?)? validator;
  final String? prefixPath;
  final String? suffixPath;
  final EdgeInsetsGeometry? contentPadding;
  final bool? readOnly;
  final VoidCallback? onTap;
  final int regularMaxCharacter;
  final int descriptionMaxCharacter;
  void Function(String)? onChanged;

  @override
  State<FairwayTextField> createState() => _FairwayTextFieldState();
}

class _FairwayTextFieldState extends State<FairwayTextField> {
  bool _obscureText = true;
  final FocusNode _focusNode = FocusNode();
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  void _updateErrorState(bool hasError) {
    setState(() {
      _hasError = hasError;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.type == FairwayTextFieldType.password;
    final isEmail = widget.type == FairwayTextFieldType.email;
    final isNumber = widget.type == FairwayTextFieldType.number;
    final isDescription = widget.type == FairwayTextFieldType.description;

    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        isDescription ? 24 : 100,
      ),
      borderSide: BorderSide(
        color: _hasError ? AppColors.error : AppColors.textFieldBorder,
      ),
    );

    final iconColor = _hasError
        ? AppColors.error
        : (_focusNode.hasFocus ? AppColors.greenPrimary : AppColors.disabled);

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
            const SizedBox(height: 4),
          ],
          TextFormField(
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            readOnly: widget.readOnly ?? false,
            focusNode: _focusNode,
            autocorrect: widget.type != FairwayTextFieldType.password,
            cursorWidth: 1,
            controller: widget.controller,
            keyboardType: isEmail
                ? TextInputType.emailAddress
                : isPassword
                    ? TextInputType.visiblePassword
                    : isNumber
                        ? TextInputType.number
                        : TextInputType.text,
            obscureText: isPassword ? _obscureText : false,
            maxLines: isDescription ? 5 : 1,
            maxLength: isDescription
                ? widget.descriptionMaxCharacter
                : widget.regularMaxCharacter,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            cursorColor: AppColors.textDark,
            inputFormatters:
                isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
            decoration: InputDecoration(
              counterText: '',
              hintText: widget.hintText,
              hintStyle: GoogleFonts.urbanist(
                color: AppColors.disabled,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 40,
              ),
              suffixIcon: widget.suffixPath != null
                  ? SvgPicture.asset(
                      widget.suffixPath!,
                      colorFilter: ColorFilter.mode(
                        iconColor,
                        BlendMode.srcIn,
                      ),
                    )
                  : (isPassword
                      ? IconButton(
                          icon: SvgPicture.asset(
                            _obscureText
                                ? AssetPaths.eyeSlashIcon
                                : AssetPaths.eyeIcon,
                            colorFilter: ColorFilter.mode(
                              iconColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )
                      : null),
              prefixIcon: widget.prefixPath != null
                  ? SvgPicture.asset(
                      widget.prefixPath!,
                      colorFilter: ColorFilter.mode(
                        iconColor,
                        BlendMode.srcIn,
                      ),
                    )
                  : (isPassword
                      ? SvgPicture.asset(
                          AssetPaths.lockIcon,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            iconColor,
                            BlendMode.srcIn,
                          ),
                        )
                      : (isEmail
                          ? SvgPicture.asset(
                              AssetPaths.smsIcon,
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                iconColor,
                                BlendMode.srcIn,
                              ),
                            )
                          : null)),
              border: baseBorder,
              focusedBorder: baseBorder.copyWith(
                borderSide: const BorderSide(
                  color: AppColors.greenPrimary,
                ),
              ),
              contentPadding: isDescription
                  ? const EdgeInsetsDirectional.only(
                      start: 16,
                      top: 24,
                    )
                  : widget.contentPadding ??
                      const EdgeInsetsDirectional.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
              errorStyle: const TextStyle(
                color: AppColors.error,
              ),
              errorMaxLines: 2,
            ),
            validator: (value) {
              final errorText = widget.validator?.call(value);
              _updateErrorState(errorText != null); // Update error state
              return errorText;
            },
          ),
        ],
      ),
    );
  }
}
