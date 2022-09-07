import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Color? bgColor;
  const CustomButton({Key? key, required this.buttonText, this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        shadowColor: Colors.yellow,
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: bgColor ?? Colors.blue[900]),
          child: Center(
              child: Text(buttonText,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18))),
        ),
      ),
    );
  }
}
