import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';

class ProfileCard extends StatelessWidget {
  final String title;
  final IconData leftIcon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? backgroundColor;

  const ProfileCard({
    Key? key,
    required this.title,
    required this.leftIcon,
    required this.onTap,
    this.iconColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          // Left Icon
          leading: Container(
            height: SizeConfig.blockHeight * 4,
            width: SizeConfig.blockHeight * 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            child: Icon(
              leftIcon,
              color: iconColor ?? AppColors.black,
              size: SizeConfig.blockHeight * 2.5,
            ),
          ),
          // Title
          title: Text(
            title,

            style: GoogleFonts.poppins(
              color: AppColors.secondary,
              fontSize: SizeConfig.blockHeight * 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          // Right Arrow Icon
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: SizeConfig.blockHeight * 1.9,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
