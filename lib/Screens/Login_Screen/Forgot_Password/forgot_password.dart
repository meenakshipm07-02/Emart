import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Circular_progressindicator/progress_indicator.dart';
import 'package:grocery_app/Common_Widgets/Login_Fields/login_textformfield.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';
import 'package:grocery_app/Providers/Forgot_Passproviders/recover_password.dart';
import 'package:grocery_app/Screens/Login_Screen/Forgot_Password/verify_email.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _forgotKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forgotProvider = Provider.of<RecoverPasswordProvider>(context);
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, size: SizeConfig.blockWidth * 5),
        ),
        toolbarHeight: SizeConfig.blockHeight * 8,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Forgot Password",
          style: GoogleFonts.poppins(
            color: AppColors.secondary,
            fontSize: SizeConfig.blockHeight * 1.9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockWidth * 6.5,
              vertical: SizeConfig.blockHeight * 3,
            ),
            child: Form(
              key: _forgotKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: SizeConfig.blockHeight * 16),
                  Text(
                    "Mail Address Here",
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontSize: SizeConfig.blockHeight * 2.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 1),
                  Text(
                    "Enter the email address associated\nwith your Account",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.subtitle,
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.blockHeight * 1.7,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 7),

                  Row(
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: SizeConfig.blockHeight * 1.8,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),

                  LoginTextformfield(
                    hinttext: 'example@gmail.com',
                    controller: emailController,
                    isPassword: false,
                    keyboardType: TextInputType.emailAddress,
                    readonly: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 5),

                  SizedBox(
                    width: SizeConfig.blockWidth * 85,
                    height: SizeConfig.blockHeight * 5.5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: forgotProvider.isLoading
                          ? null
                          : () async {
                              if (_forgotKey.currentState?.validate() ??
                                  false) {
                                final success = await forgotProvider
                                    .sendForgotOtp(emailController.text.trim());

                                if (success) {
                                  if (!mounted) return;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VerifyEmail(
                                        email: emailController.text.trim(),
                                      ),
                                    ),
                                  );
                                } else {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: AppColors.error,
                                      content: Center(
                                        child: Text(
                                          forgotProvider.message ??
                                              "Failed to send OTP",
                                          style: TextStyle(
                                            fontSize:
                                                SizeConfig.blockHeight * 1.6,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                      child: forgotProvider.isLoading
                          ? const CustomLoader(color: AppColors.success)
                          : Text(
                              "Recover Password",
                              style: GoogleFonts.poppins(
                                fontSize: SizeConfig.blockHeight * 1.8,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
