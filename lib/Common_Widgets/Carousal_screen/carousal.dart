import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';

class PromoCarouselPage extends StatelessWidget {
  const PromoCarouselPage({super.key});

  Widget buildPromoCard({
    required String imagePath,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
    required Color gradient1,
    required Color gradient2,
    required double imageWidth,
    required double imageHeight,
    required Color textColor,
    required Color foregroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradient1, gradient2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.blockHeight * 0.8),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: SizeConfig.blockHeight * 1.5,
                    color: textColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: SizeConfig.blockHeight * 0.5),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: SizeConfig.blockHeight * 1.8,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                SizedBox(height: SizeConfig.blockHeight * 2.1),

                SizedBox(
                  height: SizeConfig.blockHeight * 3.8,
                  width: SizeConfig.blockWidth * 31,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: foregroundColor,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Shop Now',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: SizeConfig.blockHeight * 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: SizeConfig.blockWidth * 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,

              width: imageWidth,

              height: imageHeight,

              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CarouselSlider(
        options: CarouselOptions(
          height: SizeConfig.blockHeight * 19.5,
          enlargeCenterPage: false,
          enableInfiniteScroll: true,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          viewportFraction: 1,
        ),
        items: [
          buildPromoCard(
            imagePath: 'assets/Carousal_images/basket.png',
            subtitle: "Eat fresh, live well",
            title: "Organic fruits Straight\nFrom farms..",
            imageHeight: SizeConfig.blockHeight * 15,
            imageWidth: SizeConfig.blockWidth * 30,
            onPressed: () {},
            gradient1: Color.fromARGB(255, 34, 120, 32),
            gradient2: const Color.fromARGB(255, 27, 60, 28),
            textColor: Colors.white,
            foregroundColor: const Color.fromARGB(255, 27, 60, 28),
          ),
          buildPromoCard(
            imageHeight: SizeConfig.blockHeight * 15,
            imageWidth: SizeConfig.blockWidth * 30,
            imagePath: 'assets/Carousal_images/tomato.png',
            subtitle: 'Hurry up! Get 20% off ',
            title: 'Fresh foods everyday\nFrom here..',
            onPressed: () {},
            gradient1: Color.fromARGB(255, 224, 88, 88),
            gradient2: const Color.fromARGB(255, 173, 38, 28),
            textColor: Colors.white,
            foregroundColor: Colors.red,
          ),
          buildPromoCard(
            imagePath: 'assets/Carousal_images/orange.png',
            subtitle: "Freshness delivered daily",
            title: "Healthy Choices,\nHappy Life..",
            imageHeight: SizeConfig.blockHeight * 13,
            imageWidth: SizeConfig.blockWidth * 30,
            onPressed: () {},
            gradient1: Color.fromARGB(255, 231, 118, 66),
            gradient2: const Color.fromARGB(255, 196, 69, 14),
            textColor: Colors.white,
            foregroundColor: Color.fromARGB(255, 231, 118, 66),
          ),
        ],
      ),
    );
  }
}
