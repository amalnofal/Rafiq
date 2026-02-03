import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class CustomTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool isPassword;
  final String? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final Color? fillColor;
  final Color? focusedFillColor;
  final TextStyle? style;
  final TextStyle? focusedStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentpadding;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.keyboardType,
    this.focusNode,
    this.textInputAction,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.fillColor,
    this.focusedFillColor,
    this.style,
    this.focusedStyle,
    this.padding,
    this.contentpadding,
    this.onSubmitted,
    this.hintStyle,
    this.readOnly = false,
    this.maxLines = 1, // الافتراضي سطر واحد
    this.minLines,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode ?? FocusNode();

    _focusNode.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;
    final isFocused = _focusNode.hasFocus;

    return Padding(
      padding:
          widget.padding ??
          EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
      child: TextFormField(
        validator:
            widget.validator ??
            (data) {
              if (data == null || data.isEmpty) {
                return AppLocalizations.of(context)!.fieldRequired;
              }
              return null;
            },
        focusNode: _focusNode,
        controller: widget.controller,

        textInputAction: widget.textInputAction ?? TextInputAction.next,
        onFieldSubmitted: widget.onSubmitted,
        readOnly: widget.readOnly,
        style: isFocused
            ? (widget.focusedStyle ?? widget.style ?? theme.textTheme.bodyLarge)
            : (widget.style ?? theme.textTheme.bodyLarge),

        keyboardType: widget.keyboardType ?? TextInputType.text,
        obscureText: widget.isPassword ? _obscure : false,
        onChanged: widget.onChanged,

        maxLines: widget.isPassword ? 1 : widget.maxLines,
        minLines: widget.minLines,

        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ?? theme.inputDecorationTheme.hintStyle,

          filled: true,

          isDense: true,
          fillColor: isFocused
              ? (widget.focusedFillColor ?? theme.colorScheme.surface)
              : (widget.fillColor ?? inputTheme.fillColor),

          contentPadding: widget.contentpadding ?? EdgeInsets.all(14.h),

          prefixIcon: widget.prefixIcon != null
              ? SizedBox(
                  width: 35.h,
                  height: 35.h,
                  child: Center(
                    child: SvgPicture.asset(
                      widget.prefixIcon!,
                      width: AppDimensions.iconM,
                      colorFilter: ColorFilter.mode(
                        theme.hintColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                )
              : null,

          suffixIcon: widget.isPassword
              ? IconButton(
                  focusNode: FocusNode(skipTraversal: true),
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: theme.colorScheme.onTertiary,
                    size: AppDimensions.iconM,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                )
              : widget.suffixIcon,
        ),
      ),
    );
  }
}
