import 'package:charity_app/core/config/res/refactor_color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({
    super.key,
    this.label,
    this.subLabel,
    this.controller,
    this.focusNode,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.onTap,
    this.onChanged,
    this.readOnly = false,
    this.enabled = true,
    this.fillColor,
    this.borderColor,
    this.maxLines = 1,
    this.enableSuffixPadding = true,
    this.labelSpace,
    this.icon,
    this.hint,
    this.hintStyle,
    this.labelStyle,
    this.hasTextAbove = false,
    this.alignLabelWithHint = false,
    this.isRequired = false,
    this.textInputAction = TextInputAction.next,
    this.textAboveStyle,
    this.hasEdit,
    this.editWidget,
    this.onFieldSubmitted,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
  });

  final String? label;
  final bool hasTextAbove;
  final TextStyle? textAboveStyle;
  final TextStyle? labelStyle;
  final String? subLabel, hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon, suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool isPassword;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final bool readOnly, enabled;
  final Color? fillColor, borderColor;
  final int maxLines;
  final bool enableSuffixPadding;
  final double? labelSpace;
  final Widget? icon;
  final TextStyle? hintStyle;
  final bool? alignLabelWithHint;
  final bool? isRequired;
  final bool? hasEdit;
  final Widget? editWidget;
  final TextInputAction? textInputAction;
  final FloatingLabelBehavior floatingLabelBehavior;

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  TextDirection? _textDirection;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    if (widget.controller != null && widget.controller!.text.isNotEmpty) {
      _updateTextDirection(widget.controller!.text);
    }
  }

  void _updateTextDirection(String text) {
    if (widget.keyboardType == TextInputType.phone) {
      if (_textDirection != TextDirection.ltr) {
        setState(() => _textDirection = TextDirection.ltr);
      }
      return;
    }

    if (text.isEmpty) {
      if (_textDirection != null) {
        setState(() => _textDirection = null);
      }
      return;
    }

    final isRtl = intl.Bidi.detectRtlDirectionality(text);
    final newDirection = isRtl ? TextDirection.rtl : TextDirection.ltr;

    if (_textDirection != newDirection) {
      setState(() => _textDirection = newDirection);
    }
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    final effectiveFillColor =
        widget.fillColor ??
        (_isFocused ? colors.primary.withValues(alpha: 0.05) : colors.whiteBtn);

    final effectiveBorderColor =
        widget.borderColor ?? (_isFocused ? colors.primary : colors.border);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.hasTextAbove && widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style:
                    widget.textAboveStyle ??
                    TextStyle(
                      color: colors.textSubtle,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              if (widget.isRequired == true) ...[
                const SizedBox(width: 5),
                Text(
                  '*',
                  style: TextStyle(
                    color: colors.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ],
              if (widget.hasEdit == true) ...[
                const Spacer(),
                widget.editWidget ?? const SizedBox.shrink(),
              ],
            ],
          ),
          SizedBox(height: widget.labelSpace ?? 8.h),
        ],
        TextFormField(
          maxLines: widget.maxLines,
          controller: widget.controller,
          focusNode: _focusNode,
          validator: widget.validator,
          autovalidateMode:
              AutovalidateMode.onUserInteraction, // Enable real-time validation
          inputFormatters: widget.inputFormatters,
          cursorColor: colors.primary,
          obscureText: widget.isPassword,

          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          style: TextStyle(
            color: colors.text,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: widget.keyboardType,
          onTap: widget.onTap,
          onChanged: (value) {
             _updateTextDirection(value);
            widget.onChanged?.call(value);
          },
          readOnly: widget.readOnly,
          onFieldSubmitted: widget.onFieldSubmitted,
          enabled: widget.enabled,
          textInputAction: (widget.keyboardType == TextInputType.phone)
              ? TextInputAction.done
              : widget.textInputAction,
          textDirection:
              _textDirection ??
              ((widget.keyboardType == TextInputType.phone)
                  ? TextDirection.ltr
                  : 
                  Directionality.of(context) ),
          decoration: InputDecoration(
            icon: widget.icon,
            filled: true,
            fillColor: effectiveFillColor,
            labelText: !widget.hasTextAbove ? widget.label : null,
            labelStyle:
                widget.labelStyle ??
                TextStyle(
                  color: _isFocused ? colors.primary : colors.hintText,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
            floatingLabelBehavior: widget.floatingLabelBehavior,
            hintText: widget.hint,
            hintTextDirection: Directionality.of(context),
            hintStyle:
                widget.hintStyle ??
                TextStyle(
                  color: colors.hintText,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  
                ),
            errorStyle: TextStyle(
              color: colors.error,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
            errorMaxLines: 3,
            prefixIcon: Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 10.w,
                vertical: 12.h,
              ),
              child: widget.prefixIcon,
            ),
            alignLabelWithHint: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            suffixIcon: Padding(
              padding: widget.enableSuffixPadding
                  ? EdgeInsetsDirectional.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    )
                  : EdgeInsets.zero,
              child: widget.suffixIcon,
            ),
            suffixIconConstraints: const BoxConstraints(),
            prefixIconConstraints: const BoxConstraints(),
            border: _buildBorder(color: effectiveBorderColor),
            enabledBorder: _buildBorder(color: effectiveBorderColor),
            focusedBorder: _buildBorder(color: colors.primary),
            errorBorder: _buildBorder(color: colors.error),
            focusedErrorBorder: _buildBorder(color: colors.error, width: 1.5),
            disabledBorder: _buildBorder(color: colors.disabled),
          ),
        ),
        if (widget.subLabel != null) ...[
          SizedBox(height: 5.h),
          Text(
            widget.subLabel!,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              color: colors.textSubtle,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  OutlineInputBorder _buildBorder({required Color color, double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
