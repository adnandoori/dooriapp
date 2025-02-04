import 'package:doori_mobileapp/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:form_field_validator/form_field_validator.dart';

class AppTextField extends StatelessWidget {
  final String label, hint;
  final String? prefixText, errorText, error;
  final bool obscureText;
  final TextStyle? textStyle;
  final InputDecoration? decoration;
  final TextInputAction keyboardAction;
  final TextCapitalization textCapitalization;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validators;
  final List<TextInputFormatter>? inputFormatters;
  final InputCounterWidgetBuilder? buildCounter;
  final int? maxLength;
  final Widget? prefixIcon;
  final bool enabled;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final Function()? onTap;
  final bool readOnly;
  final bool enableInteractiveSelection;
  final Widget? suffixIcon;
  final String? initValue;
  final FormFieldSetter<String>? onSaved;
  final bool paddingLeft;
  final EdgeInsets? contentPadding;
  final int maxLines;
  final double height;
  final bool filled;
  final Widget? suffix;
  final Widget? prefix;
  final Function(String?)? onChanged;
  final Function(String?)? onSubmit;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final bool? isDense;

  AppTextField({
    required this.label,
    required this.hint,
    this.error,
    this.obscureText = false,
    this.textStyle,
    this.decoration,
    this.keyboardAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.validators,
    this.inputFormatters,
    this.maxLength,
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.nextFocusNode,
    this.onTap,
    this.readOnly = false,
    this.enableInteractiveSelection = true,
    this.suffixIcon,
    this.initValue,
    this.paddingLeft = false,
    this.contentPadding,
    this.prefixIcon,
    this.onSaved,
    this.prefixText,
    this.maxLines = 1,
    this.height = 1,
    this.filled = false,
    this.suffix,
    this.prefix,
    this.onChanged,
    this.onSubmit,
    this.errorText,
    this.buildCounter,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.isDense,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initValue,
      onSaved: onSaved,
      cursorColor: Colors.black,
      enableInteractiveSelection: enableInteractiveSelection,
      readOnly: readOnly,
      onTap: onTap,
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      expands: false,
      autofocus: false,
      minLines: 1,
      maxLines: maxLines,
      style: textStyle,
      obscureText: obscureText,
      validator: validators != null ? validators : (String? value) {},
      keyboardType: keyboardType,
      textInputAction: keyboardAction,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onFieldSubmitted: onSubmit,
      //(_) => submit(context),
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      decoration: decoration ??
          InputDecoration(
            counterStyle:
                textMedium.copyWith(color: Colors.black.withOpacity(0.50)),
            counterText: "",
            filled: filled,
            prefixText: prefixText,
            isDense: isDense,
            prefix: prefix,
            prefixStyle: textMedium.copyWith(
                color: Colors.black, fontFamily: "Montserrat"),
            prefixIcon: prefixIcon,
            prefixIconConstraints: prefixIconConstraints,
            fillColor: filled ? Colors.grey : Colors.grey,
            hintText: hint,
            hintMaxLines: 1,
            suffixIcon: suffixIcon,
            suffix: suffix,
            suffixIconConstraints: suffixIconConstraints,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintStyle: textMedium.copyWith(
                color: Colors.grey, fontSize: 15.sp, fontFamily: "Montserrat"),
            errorStyle: textMedium.copyWith(
                color: Colors.red, fontFamily: "Montserrat", fontSize: 16),
            errorMaxLines: 2,
            alignLabelWithHint: true,
            contentPadding:
                contentPadding ?? const EdgeInsets.fromLTRB(12, 15, 12, 15),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: filled
                  ? BorderSide.none
                  : BorderSide(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.0,
                    ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: filled
                  ? BorderSide.none
                  : BorderSide(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.0,
                    ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: filled
                  ? BorderSide.none
                  : BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: filled
                  ? BorderSide.none
                  : BorderSide(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.0,
                    ),
            ),
          ),
    );
  }

  void submit(BuildContext context) {
    switch (keyboardAction) {
      case TextInputAction.done:
        FocusScope.of(context).unfocus();
        break;
      case TextInputAction.next:
        FocusScope.of(context).requestFocus(nextFocusNode);
        break;
      default:
        FocusScope.of(context).nextFocus();
        break;
    }
  }
}
