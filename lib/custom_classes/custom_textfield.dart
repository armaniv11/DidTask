import 'dart:ui';

import 'package:did/appConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final Widget? icon;
  final double width;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final TextInputType inputType;
  final int maxlines;
  final int? maxlength;
  final Color headingColor;
  final bool isDense;
  final double headingSize;
  final bool validationEnabled;
  final bool enabled;
  final bool reverted;
  final Color? fillColor;
  final VoidCallback? onChanged;
  final String? suffix;
  const CustomTextField(
      {Key? key,
      required this.controller,
      this.hintText,
      this.icon,
      required this.width,
      this.paddingLeft = 8.0,
      this.paddingRight = 8.0,
      this.paddingTop = 8.0,
      this.paddingBottom = 8.0,
      required this.inputType,
      this.maxlines = 1,
      this.maxlength,
      required this.headingColor,
      this.isDense = false,
      required this.headingSize,
      this.validationEnabled = false,
      this.enabled = true,
      this.reverted = false,
      this.fillColor = Colors.white,
      this.onChanged,
      this.suffix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: TextFormField(
          validator: (value) {
            if (validationEnabled) {
              return value!.isEmpty ? "${hintText} cannot be empty!!" : null;
            }
            return null;
          },
          textCapitalization: TextCapitalization.sentences,
          enabled: enabled,
          maxLines: maxlines == 1 ? null : maxlines,
          maxLength: maxlength == 15 ? null : maxlength,
          keyboardType: inputType,
          controller: controller,
          style: TextStyle(color: !enabled ? Colors.grey : Colors.black),
          decoration: InputDecoration(
            label: Text("$hintText"),
            suffixText: suffix,
            labelStyle: GoogleFonts.montserrat(
              textStyle: const TextStyle(color: Colors.black, fontSize: 13),
            ),
            errorStyle:
                const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            prefixIcon: icon,
            fillColor: fillColor,
            filled: true,
            isDense: isDense,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[900]!),
              borderRadius: BorderRadius.circular(12.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onChanged: (val) {
            if (onChanged != null) {
              onChanged!();
            }
            // if (reverted) {
            //   onChanged(val);
            // }
          }),
    );
  }
}
