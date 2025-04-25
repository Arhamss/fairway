import 'package:equatable/equatable.dart';
import 'package:fairway/export.dart';
import 'package:google_fonts/google_fonts.dart';

enum FairwayTextFieldType {
  email,
  password,
  confirmPassword,
  description,
  number,
  text,
  location,
}

class FairwayTextFieldState extends Equatable {
  const FairwayTextFieldState({
    this.obscureText = true,
  });

  final bool obscureText;

  FairwayTextFieldState copyWith({
    bool? obscureText,
  }) {
    return FairwayTextFieldState(
      obscureText: obscureText ?? this.obscureText,
    );
  }

  @override
  List<Object?> get props => [
        obscureText,
      ];
}

class FairwayTextFieldCubit extends Cubit<FairwayTextFieldState> {
  FairwayTextFieldCubit() : super(const FairwayTextFieldState());

  void toggleObscureText() {
    emit(state.copyWith(obscureText: !state.obscureText));
  }
}

class FairwayTextField extends StatefulWidget {
  const FairwayTextField({
    required this.controller,
    this.padding = EdgeInsets.zero,
    this.labelText,
    this.hintText,
    this.hintColor,
    this.type = FairwayTextFieldType.text,
    this.validator,
    this.prefixPath, // SVG asset path for prefix icon
    this.suffixPath,
    this.contentPadding,
    this.readOnly,
    this.descriptionMaxCharacter = 200,
    this.regularMaxCharacter = 100,
    this.onTap,
    this.onChanged,
    this.onClear,
    super.key,
    this.compareValueBuilder,
    this.enabled = true,
    this.textStyle,
    this.showPrefixIcon = true,
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
  final bool enabled;
  final VoidCallback? onTap;
  final int regularMaxCharacter;
  final int descriptionMaxCharacter;
  final void Function(String)? onChanged;
  final VoidCallback? onClear;
  final String Function()? compareValueBuilder;
  final TextStyle? textStyle;
  final bool? showPrefixIcon;
  @override
  State<FairwayTextField> createState() => _FairwayTextFieldState();
}

class _FairwayTextFieldState extends State<FairwayTextField> {
  final FocusNode _focusNode = FocusNode();
  late final FairwayTextFieldCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = FairwayTextFieldCubit();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.type == FairwayTextFieldType.password ||
        widget.type == FairwayTextFieldType.confirmPassword;
    final isEmail = widget.type == FairwayTextFieldType.email;
    final isNumber = widget.type == FairwayTextFieldType.number;
    final isDescription = widget.type == FairwayTextFieldType.description;
    final isLocation = widget.type == FairwayTextFieldType.location;
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        isDescription ? 24 : 15,
      ),
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
    );

    String? validator(String? value) {
      if (value == null || value.trim().isEmpty) {
        return "This Field Can't Be Empty";
      }

      if (widget.type == FairwayTextFieldType.email) {
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value.trim())) {
          return 'Please enter a valid email address';
        }
      } else if (widget.type == FairwayTextFieldType.password ||
          widget.type == FairwayTextFieldType.confirmPassword) {
        final specialCharRegex = RegExp(r'[^\w\s]');

        if (value.trim().length < 8) {
          return 'Password must be at least 8 characters';
        }
        if (!value.contains(RegExp('[A-Z]'))) {
          return 'Password must contain at least one uppercase letter';
        }
        if (!value.contains(RegExp('[a-z]'))) {
          return 'Password must contain at least one lowercase letter';
        }

        if (!value.contains(RegExp('[0-9]'))) {
          return 'Password must contain at least one number';
        }
        if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_]'))) {
          return 'Password must contain at least one special character';
        }
      }

      if (widget.type == FairwayTextFieldType.confirmPassword) {
        final passwordValue = widget.compareValueBuilder?.call();
        if (passwordValue != null && value != passwordValue) {
          return 'Passwords do not match';
        }
      }
      return null;
    }

    // Get prefix icon based on field type or custom SVG path
    Widget? buildPrefixIcon() {
      // If a custom prefixPath is provided, use it
      if (widget.prefixPath != null && widget.showPrefixIcon == true) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: SizedBox(
            child: SvgPicture.asset(
              widget.prefixPath!,
              height: 18,
            ),
          ),
        );
      }

      if (isLocation && widget.showPrefixIcon == true) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: SizedBox(
            child: SvgPicture.asset(
              AssetPaths.locationIcon,
              height: 18,
            ),
          ),
        );
      } else if (isEmail && widget.showPrefixIcon == true) {
        return const Padding(
          padding: EdgeInsets.only(left: 16, right: 8),
          child: SizedBox(
            child: Icon(
              Icons.email_outlined,
              size: 18,
              color: AppColors.grey,
            ),
          ),
        );
      } else if (isPassword && widget.showPrefixIcon == true) {
        return const Padding(
          padding: EdgeInsets.only(left: 16, right: 8),
          child: SizedBox(
            child: Icon(
              Icons.lock_outline,
              size: 18,
              color: AppColors.grey,
            ),
          ),
        );
      }

      return null;
    }

    Widget? buildSuffixIcon(
      bool isPassword,
      bool isLocation,
      FairwayTextFieldState state,
    ) {
      if (isPassword) {
        return IconButton(
          icon: Icon(
            color: AppColors.greyShade1,
            state.obscureText
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
          ),
          onPressed: () {
            _cubit.toggleObscureText();
          },
        );
      } else if (widget.controller.text.isNotEmpty && isLocation) {
        return GestureDetector(
          onTap: () {
            widget.controller.clear();
            // Call the onClear callback if provided
            if (widget.onClear != null) {
              widget.onClear!();
            }
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.greyShade5,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close_outlined,
              color: AppColors.black,
              size: 18,
            ),
          ),
        );
      }
      return null;
    }

    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<FairwayTextFieldCubit, FairwayTextFieldState>(
        builder: (context, state) {
          return Padding(
            padding: widget.padding,
            child: TextFormField(
              style: widget.textStyle ??
                  GoogleFonts.urbanist(
                    color: AppColors.textDark,
                  ),
              onChanged: widget.onChanged,
              onTap: widget.onTap,
              readOnly: widget.readOnly ?? false,
              enabled: widget.enabled,
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
              obscureText: (widget.type == FairwayTextFieldType.password ||
                      widget.type == FairwayTextFieldType.confirmPassword) &&
                  state.obscureText,
              maxLines: isDescription ? 5 : 1,
              maxLength: isDescription
                  ? widget.descriptionMaxCharacter
                  : widget.regularMaxCharacter,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              cursorColor: AppColors.textDark,
              inputFormatters:
                  isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.greyShade5,
                counterText: '',
                hintText: widget.hintText,
                hintStyle: GoogleFonts.urbanist(
                  color: AppColors.disabled,
                ),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                ),
                suffixIcon: buildSuffixIcon(isPassword, isLocation, state),
                prefixIcon: buildPrefixIcon(),
                prefixIconConstraints: const BoxConstraints(),
                border: baseBorder,
                focusedBorder: baseBorder,
                errorBorder: baseBorder,
                enabledBorder: baseBorder,
                contentPadding: isDescription
                    ? const EdgeInsetsDirectional.only(
                        start: 24,
                        top: 24,
                      )
                    : widget.contentPadding ??
                        const EdgeInsetsDirectional.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                errorStyle: const TextStyle(
                  color: AppColors.error,
                ),
                errorMaxLines: 2,
              ),
              validator: validator,
            ),
          );
        },
      ),
    );
  }
}
