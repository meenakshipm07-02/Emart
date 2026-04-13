import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';
//hi

class AddressCard extends StatelessWidget {
  final int id;
  final String addressType;
  final String address;
  final String pincode;
  final VoidCallback onDelete;

  const AddressCard({
    super.key,
    required this.id,
    required this.addressType,
    required this.address,
    required this.pincode,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      elevation: 0.8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              addressType,
              style: GoogleFonts.poppins(
                color: AppColors.secondary,
                fontSize: SizeConfig.blockHeight * 1.7,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: SizeConfig.blockHeight * 0.4),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: AppColors.black,
                      fontSize: SizeConfig.blockHeight * 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onDelete,
                  child: Image.asset(
                    'assets/Icons/delete.png',
                    height: SizeConfig.blockHeight * 2.2,
                    width: SizeConfig.blockHeight * 2.2,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.blockHeight * 0.4),

            Text(
              "Pincode: $pincode",
              style: GoogleFonts.poppins(
                color: AppColors.subtitle,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.blockHeight * 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
