import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final String? titleText, hintText, labelText, suggestionText;
  final bool readOnly;
  final FocusNode? focusNode;
  final void Function(String?)? onSaved;
  final void Function()? onTap;
  final String? Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final int? minLines;
  final int maxLines;
  final TextStyle? textStyle;
  final double borderRadius;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final Color? fillColor;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final bool autofocus;
  final BoxConstraints? suffixIconConstraints;
  final Key? fieldKey;
  const AppTextFormField({
    super.key,
    this.titleText,
    this.suggestionText,
    this.keyboardType,
    this.focusNode,
    this.hintText,
    this.labelText,
    this.onSaved,
    this.onTap,
    this.onChanged,
    this.validator,
    this.controller,
    this.minLines,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.readOnly = false,
    this.autofocus = false,
    this.borderRadius = 12,
    this.textStyle,
    this.obscureText = false,
    this.fillColor,
    this.contentPadding,
    this.hintStyle,
    this.suffixIconConstraints,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    var field = TextFormField(
      key: fieldKey,
      style: textStyle ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
      keyboardType: keyboardType,
      cursorColor: Colors.black,
      controller: controller,
      readOnly: readOnly,
      minLines: minLines,
      maxLines: maxLines,
      validator: validator,
      onSaved: onSaved,
      onTap: onTap,
      onChanged: onChanged,
      obscureText: obscureText,
      focusNode: focusNode,
      autofocus: autofocus,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        labelText: labelText,
        fillColor: fillColor ?? Color(0xFFDFEAFF),
        filled: true,
        contentPadding: contentPadding ?? EdgeInsets.fromLTRB(16, 12, 16, 12),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        suffixIconConstraints: suffixIconConstraints,
        errorMaxLines: 3,
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: BorderSide.none,
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (titleText != null)
          Text(
            titleText!,
          ),
        if (titleText != null) const SizedBox(height: 6),
        field,
        if (suggestionText != null) const SizedBox(height: 4),
        if (suggestionText != null)
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              suggestionText!,

            ),
          ),
      ],
    );
  }
}
