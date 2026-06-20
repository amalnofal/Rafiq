import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/arabic_numbers_formatter.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class CustomTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextDirection? textDirection;
  final bool isPassword;
  final String? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool rejectNumbers;
  final Color? fillColor;
  final Color? focusedFillColor;
  final Color? borderColor;
  final TextStyle? style;
  final TextStyle? focusedStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentpadding;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final TextAlign? textAlign;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.keyboardType,
    this.focusNode,
    this.textInputAction,
    this.textDirection,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.rejectNumbers = false,
    this.fillColor,
    this.focusedFillColor,
    this.borderColor,
    this.style,
    this.focusedStyle,
    this.padding,
    this.contentpadding,
    this.onSubmitted,
    this.hintStyle,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1, // الافتراضي سطر واحد
    this.minLines,
    this.textAlign,
    this.textCapitalization = TextCapitalization.none,
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

    InputBorder? customBorder;
    if (widget.borderColor != null &&
        inputTheme.enabledBorder is OutlineInputBorder) {
      final baseBorder = inputTheme.enabledBorder as OutlineInputBorder;
      customBorder = baseBorder.copyWith(
        borderSide: baseBorder.borderSide.copyWith(color: widget.borderColor),
      );
    } else if (widget.borderColor != null) {
      customBorder = OutlineInputBorder(
        borderSide: BorderSide(color: widget.borderColor!, width: 1.5.w),
      );
    }

    List<TextInputFormatter> defaultFormatters =
        widget.inputFormatters?.toList() ?? [];

    defaultFormatters.add(ArabicToEnglishNumbersFormatter());

    if (widget.rejectNumbers) {
      defaultFormatters.add(
        FilteringTextInputFormatter.deny(RegExp(r'[0-9٠-٩]')),
      );
    }

    final currentStyle = widget.readOnly
        ? theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onTertiary.withValues(alpha: 0.6),
          )
        : isFocused
        ? (widget.focusedStyle ?? widget.style ?? theme.textTheme.bodyLarge)
        : (widget.style ?? theme.textTheme.bodyLarge);

    return Padding(
      padding:
          widget.padding ??
          EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
      child: TextFormField(
        textCapitalization: widget.textCapitalization,
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
        textAlign: widget.textAlign ?? TextAlign.start,

        textDirection: widget.textDirection,
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        onFieldSubmitted: widget.onSubmitted,
        readOnly: widget.readOnly,
        enabled: widget.enabled,

        style: currentStyle,

        keyboardType: widget.keyboardType ?? TextInputType.text,

        inputFormatters: defaultFormatters.isNotEmpty
            ? defaultFormatters
            : null,

        obscureText: widget.isPassword ? _obscure : false,
        onChanged: widget.onChanged,

        maxLines: widget.isPassword ? 1 : widget.maxLines,
        minLines: widget.minLines,

        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ?? theme.inputDecorationTheme.hintStyle,
          errorText: widget.errorText,

          // 🌟 تطبيق البوردر المخصص لو مبعوت، غير كده هياخد من الثيم عادي
          enabledBorder: customBorder ?? inputTheme.enabledBorder,
          focusedBorder: customBorder ?? inputTheme.focusedBorder,
          disabledBorder: customBorder ?? inputTheme.disabledBorder,

          filled: true,
          isDense: true,

          fillColor: widget.readOnly
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.2)
              : isFocused
              ? (widget.focusedFillColor ?? theme.colorScheme.surface)
              : (widget.fillColor ?? inputTheme.fillColor),

          contentPadding: widget.contentpadding ?? EdgeInsets.all(14.h),

          prefixIcon: widget.prefixIcon != null
              ? SizedBox(
                  width: 35.h,
                  height: 35.h,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: SvgPicture.asset(
                        widget.prefixIcon!,
                        width: AppDimensions.iconM,
                        colorFilter: ColorFilter.mode(
                          widget.readOnly ? Colors.grey : theme.hintColor,
                          BlendMode.srcIn,
                        ),
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
