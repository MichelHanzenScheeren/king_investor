import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final String? labelText;
  final String? placeHolder;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType textInputType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Function(String)? onSubmit;
  final Function(String?)? onSave;
  final bool enabled;
  final bool obscure;
  final bool enablePasteOption;
  final TextEditingController? controller;
  final String? initialValue;
  final double borderRadius;
  final EdgeInsets? contentPadding;
  final bool? autoFocus;
  final bool centerTitle;
  final String? prefixText;

  CustomTextFieldWidget({
    this.labelText,
    this.placeHolder,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputType: TextInputType.text,
    this.onChanged,
    this.validator,
    this.onSubmit,
    this.onSave,
    this.enabled: true,
    this.obscure: false,
    this.enablePasteOption: true,
    this.controller,
    this.initialValue,
    this.borderRadius: 10,
    this.contentPadding,
    this.autoFocus,
    this.centerTitle: false,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        primaryColor: Colors.black.withAlpha(180),
        splashColor: Colors.yellow,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.grey[600],
          selectionColor: Colors.grey[400],
        ),
      ),
      child: TextFormField(
        initialValue: controller == null ? initialValue : null,
        textAlign: centerTitle ? TextAlign.center : TextAlign.left,
        autofocus: autoFocus ?? false,
        onFieldSubmitted: onSubmit,
        onSaved: onSave,
        controller: controller,
        readOnly: !enabled,
        obscureText: obscure,
        toolbarOptions: enablePasteOption ? null : ToolbarOptions(copy: true),
        validator: validator,
        onChanged: onChanged,
        keyboardType: textInputType,
        style: theme.textTheme.bodyText2!.copyWith(fontSize: 16),
        decoration: InputDecoration(
          contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          errorMaxLines: 2,
          helperMaxLines: 5,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.black),
          hintText: placeHolder,
          hintStyle: TextStyle(color: Colors.black.withAlpha(150), fontSize: 14),
          errorStyle: TextStyle(color: Theme.of(context).errorColor, fontSize: 13),
          helperText: helperText,
          helperStyle: TextStyle(color: Colors.grey[400]),
          prefixText: prefixText,
          prefixStyle: TextStyle(color: Colors.black),
          enabledBorder: getBorder(Colors.transparent),
          focusedBorder: getBorder(Colors.transparent),
          errorBorder: getBorder(Colors.red[600]!),
          focusedErrorBorder: getBorder(Colors.red[600]!),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  OutlineInputBorder getBorder(Color receivedColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: receivedColor, width: 2.5),
    );
  }
}
