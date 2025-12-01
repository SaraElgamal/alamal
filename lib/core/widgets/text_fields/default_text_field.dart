import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:charity_app/core/config/res/constants_manager.dart';

class DefaultTextField extends StatefulWidget {
  final String? hint;
  final bool secure;
  final TextInputType inputType;
  final TextEditingController? controller;
  final FormFieldValidator<String?>? validator;
  final Function(String?)? onSubmitted;
  final Color? fillColor;
  final Widget? prefixIcon;
  final bool readOnly;
  final bool enabled;
  final bool filled;
  final int? maxLength;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final GestureTapCallback? onTap;
  final String? suffixText;
  final TextInputAction action;
  final bool autoFocus;
  final FocusNode? focusNode;
  final Widget? prefixWidget;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final bool? isPassword;
  final int? maxLines;
  final bool? hasBorderColor;
  final Color? borderColor;
  final void Function(String?)? onChanged;
  final bool closeWhenTapOutSide;
  final TextStyle? style;
  final String? label;

  const DefaultTextField({
    super.key,
    this.hint,
    this.label,
    this.secure = false,
    this.inputType = TextInputType.text,
    this.borderColor,
    this.onTap,
    this.controller,
    this.contentPadding,
    this.closeWhenTapOutSide = true,
    this.hasBorderColor = true,
    this.validator,
    this.onSubmitted,
    this.isPassword = false,
    this.fillColor,
    this.inputFormatters,
    this.prefixIcon,
    this.prefixWidget,
    this.maxLength,
    this.filled = true,
    this.readOnly = false,
    this.enabled = true,
    this.textAlign = TextAlign.start,
    this.action = TextInputAction.next,
    this.focusNode,
    this.autoFocus = false,
    this.suffixText,
    this.suffixIcon,
    this.maxLines,
    this.onChanged,
    this.style,
  });

  @override
  State<DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  late bool _isSecure;

  @override
  void initState() {
    if (widget.isPassword != null) {
      _isSecure = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bool isLabel = widget.label != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label ?? '',
          style: TextStyle(
            color: context.colors.black80,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          inputFormatters: widget.inputFormatters,
          obscureText: widget.isPassword == true ? _isSecure : widget.secure,
          onTap: widget.onTap,
          onTapOutside: (event) {
            if (widget.closeWhenTapOutSide == true) {
              FocusScope.of(context).unfocus();
            }
          },
          keyboardType: widget.inputType,
          autofillHints: _getAutoFillHints(widget.inputType),
          validator: widget.validator,
          maxLength: widget.maxLength,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          textAlign: widget.textAlign!,
          maxLines: widget.inputType == TextInputType.multiline ? widget.maxLines ?? 7 : 1,
          style: widget.style ??
              TextStyle(
                color: context.colors.black50,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
          onFieldSubmitted: widget.onSubmitted,
          textInputAction: widget.action,
          enableSuggestions: false,
          autocorrect: false,
          autofocus: widget.autoFocus,
          focusNode: widget.autoFocus == true ? widget.focusNode : null,
          cursorColor: context.colors.primary,
          decoration: InputDecoration(
            errorMaxLines: 3,
            errorStyle: TextStyle(
              color: context.colors.red,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            isDense: true,
            contentPadding: widget.contentPadding,
            counterText: ConstantManager.emptyText,
            filled: widget.filled,
            suffixText: widget.suffixText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPassword == true
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isSecure = !_isSecure;
                      });
                    },
                    icon: Icon(
                      _isSecure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: context.colors.hintText,
                    ),
                  )
                : widget.suffixIcon,
            prefix: widget.prefixWidget,
            prefixIconConstraints: const BoxConstraints(),
            fillColor: widget.fillColor ?? Colors.white,
            hintText: widget.hint,
            // label: isLabel ? Text(widget.label!) : null,
            // labelStyle: isLabel ? const TextStyle(color: context.colors.primary) : null,
            hintStyle: TextStyle(
              color: context.colors.black50,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
            border: _border(context, borderColor: widget.borderColor),
            enabledBorder: _border(context, borderColor: widget.borderColor),
            focusedBorder: _focusedBorder(context, borderColor: widget.borderColor),
            errorBorder: _errorBorder(context, borderColor: widget.borderColor),
            focusedErrorBorder: _border(context, borderColor: widget.borderColor),
            disabledBorder: _border(context, borderColor: widget.borderColor),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(context, {required Color? borderColor}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor ?? context.colors.textFieldBorder),
      );

  OutlineInputBorder _focusedBorder(context, {required Color? borderColor}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor ?? context.colors.primary),
      );

  OutlineInputBorder _errorBorder(context, {required Color? borderColor}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor ?? context.colors.error),
      );
}

List<String> _getAutoFillHints(TextInputType inputType) {
  if (inputType == TextInputType.emailAddress) {
    return [AutofillHints.email];
  } else if (inputType == TextInputType.datetime) {
    return [AutofillHints.birthday];
  } else if (inputType == TextInputType.phone) {
    return [AutofillHints.telephoneNumber];
  } else if (inputType == TextInputType.url) {
    return [AutofillHints.url];
  }
  return [AutofillHints.name, AutofillHints.username];
}
