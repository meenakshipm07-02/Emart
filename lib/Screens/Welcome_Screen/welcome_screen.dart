import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Circular_progressindicator/progress_indicator.dart'
    show CustomLoader;
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';
import 'package:grocery_app/Screens/Login_Screen/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;
  bool isLoading = false;

  void _goToLogin() async {
    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
      setState(() => isLoading = false);
    }
  }

  Widget carousal({
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12 * SizeConfig.blockHeight),

        SizedBox(
          height: 35 * SizeConfig.blockHeight,
          width: double.infinity,
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),

        SizedBox(height: 5.5 * SizeConfig.blockHeight),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5 * SizeConfig.blockWidth),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 2.8 * SizeConfig.blockHeight,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ),

        SizedBox(height: 2.2 * SizeConfig.blockHeight),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5 * SizeConfig.blockWidth),
          child: Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 1.6 * SizeConfig.blockHeight,
              fontWeight: FontWeight.w500,
              color: AppColors.subtitle,
            ),
          ),
        ),

        SizedBox(height: 5 * SizeConfig.blockHeight),

        Center(
          child: SmoothPageIndicator(
            controller: _controller,
            count: 3,
            effect: WormEffect(
              dotHeight: 7,
              dotWidth: 16,
              activeDotColor: AppColors.primary,
              dotColor: AppColors.subtitle.withOpacity(0.5),
            ),
          ),
        ),

        SizedBox(height: 12 * SizeConfig.blockHeight),

        Center(
          child: SizedBox(
            width: SizeConfig.blockWidth * 85,
            height: SizeConfig.blockHeight * 5.5,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: isLoading
                  ? null
                  : () {
                      if (currentPage == 2) {
                        _goToLogin();
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
              child: isLoading
                  ? const CustomLoader(color: AppColors.success)
                  : Text(
                      currentPage == 2 ? "GET STARTED" : "NEXT",
                      style: TextStyle(
                        fontSize: SizeConfig.blockHeight * 1.8,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
            ),
          ),
        ),

        SizedBox(height: 2 * SizeConfig.blockHeight),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() => currentPage = index);
        },
        children: [
          carousal(
            title: "Get groceries at your\ndoorstep",
            subtitle:
                "Order from anywhere, and we’ll deliver\nyour groceries quickly and safely to your home.",
            imagePath: 'assets/Welcome_images/pic1.png',
          ),
          carousal(
            title: "Save time,\nsave money",
            subtitle:
                "Shop smarter with exclusive deals, fresh products,\nand fast delivery at your convenience.",
            imagePath: 'assets/Welcome_images/pic2.png',
          ),
          carousal(
            title: "Fresh Items with\nfast delivery groceries",
            subtitle:
                "We try our best to make sure our customers are happy with fresh grocery items.",
            imagePath: 'assets/Welcome_images/pic3.png',
          ),
        ],
      ),
    );
  }
}
