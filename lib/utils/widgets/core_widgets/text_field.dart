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
    this.compareValueBuilder,
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
  final String Function()? compareValueBuilder;

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
    _cubit.close(); // Don't forget to close the cubit
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
        if (value.trim().length < 6) {
          return 'Password must be at least 6 characters';
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

    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<FairwayTextFieldCubit, FairwayTextFieldState>(
        builder: (context, state) {
          return Padding(
            padding: widget.padding,
            child: TextFormField(
              style: GoogleFonts.urbanist(
                color: AppColors.textDark,
                fontSize: 16,
              ),
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
                filled: true, // Add this
                fillColor: AppColors.greyShade5,
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
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          state.obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          _cubit.toggleObscureText();
                        },
                      )
                    : null,
                // prefixIcon: widget.prefixPath != null
                //     ? SvgPicture.asset(
                //         widget.prefixPath!,
                //         colorFilter: ColorFilter.mode(
                //           iconColor,
                //           BlendMode.srcIn,
                //         ),
                //       )
                //     : (isPassword
                //         ? SvgPicture.asset(
                //             AssetPaths.lockIcon,
                //             height: 20,
                //             colorFilter: ColorFilter.mode(
                //               iconColor,
                //               BlendMode.srcIn,
                //             ),
                //           )
                //         : (isEmail
                //             ? SvgPicture.asset(
                //                 AssetPaths.smsIcon,
                //                 height: 20,
                //                 colorFilter: ColorFilter.mode(
                //                   iconColor,
                //                   BlendMode.srcIn,
                //                 ),
                //               )
                //             : null)),
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
