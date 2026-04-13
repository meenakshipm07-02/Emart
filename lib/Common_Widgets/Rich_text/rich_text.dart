import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';

class CommonRichText extends StatelessWidget {
  final String firstText;
  final String secondText;
  final double fontSize;
  final Color firstColor;
  final Color secondColor;
  final FontWeight firstWeight;
  final FontWeight secondWeight;

  const CommonRichText({
    super.key,
    required this.firstText,
    required this.secondText,
    this.fontSize = 22,
    this.firstColor = Colors.transparent,
    this.secondColor = Colors.transparent,
    this.firstWeight = FontWeight.w800,
    this.secondWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(fontSize: fontSize),
        children: [
          TextSpan(
            text: firstText,
            style: GoogleFonts.poppins(
              color: firstColor,
              fontWeight: firstWeight,
            ),
          ),
          WidgetSpan(child: SizedBox(width: SizeConfig.blockWidth * 0.5)),
          TextSpan(
            text: secondText,
            style: GoogleFonts.poppins(
              color: secondColor,
              fontWeight: secondWeight,
            ),
          ),
        ],
      ),
    );
  }
}
