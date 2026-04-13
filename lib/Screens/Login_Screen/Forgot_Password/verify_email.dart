import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Circular_progressindicator/progress_indicator.dart';
import 'package:grocery_app/Providers/Forgot_Passproviders/verify%20_password.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/Common_Widgets/Login_Fields/login_textformfield.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';
import 'package:grocery_app/Screens/Login_Screen/login_screen.dart'; // ✅ for navigation

class VerifyEmail extends StatefulWidget {
  final String email;
  const VerifyEmail({super.key, required this.email});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  late TextEditingController emailController;
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final resetProvider = Provider.of<ResetPasswordProvider>(context);

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
          "Email Verification",
          style: GoogleFonts.poppins(
            color: AppColors.secondary,
            fontSize: SizeConfig.blockHeight * 1.9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockWidth * 6.5,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Get Your Code",
                      style: GoogleFonts.poppins(
                        color: AppColors.primary,
                        fontSize: SizeConfig.blockHeight * 2.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockHeight * 1),
                    Text(
                      "Please enter the 6-digit code \nthat was sent to your email address.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: AppColors.subtitle,
                        fontWeight: FontWeight.w500,
                        fontSize: SizeConfig.blockHeight * 1.7,
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockHeight * 4),

                    /// Email
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
                      readonly: true,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Email cannot be empty'
                          : null,
                    ),
                    SizedBox(height: SizeConfig.blockHeight * 2.2),

                    /// OTP
                    Row(
                      children: [
                        Text(
                          'OTP',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: SizeConfig.blockHeight * 1.8,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    LoginTextformfield(
                      hinttext: 'Enter 6-digit code',
                      controller: otpController,
                      isPassword: false,
                      keyboardType: TextInputType.number,
                      readonly: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the OTP';
                        }
                        if (value.length != 6) {
                          return 'OTP must be exactly 6 digits';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: SizeConfig.blockHeight * 2.2),

                    /// New Password
                    Row(
                      children: [
                        Text(
                          'New Password',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: SizeConfig.blockHeight * 1.8,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    LoginTextformfield(
                      hinttext: 'Enter new password',
                      controller: passwordController,
                      isPassword: true,
                      keyboardType: TextInputType.text,
                      readonly: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
                        }
                        if (value.length < 4) {
                          return 'Password must be at least 4 characters';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: SizeConfig.blockHeight * 5.5),

                    SizedBox(
                      width: SizeConfig.blockWidth * 80,
                      height: SizeConfig.blockHeight * 5.2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: resetProvider.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  await resetProvider.resetPassword(
                                    email: emailController.text.trim(),
                                    otp:
                                        int.tryParse(
                                          otpController.text.trim(),
                                        ) ??
                                        0,
                                    newPassword: passwordController.text.trim(),
                                  );

                                  if (!mounted) return;

                                  final isSuccess =
                                      resetProvider.statusMessage
                                          ?.toLowerCase()
                                          .contains("success") ??
                                      false;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: isSuccess
                                          ? AppColors.success
                                          : AppColors.error,
                                      duration: const Duration(seconds: 2),
                                      content: Center(
                                        child: Text(
                                          resetProvider.statusMessage ??
                                              'Something went wrong',
                                          style: GoogleFonts.poppins(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );

                                  if (isSuccess) {
                                    await Future.delayed(
                                      const Duration(seconds: 2),
                                    );
                                    if (!mounted) return;
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                }
                              },
                        child: resetProvider.isLoading
                            ? const CustomLoader(color: AppColors.success)
                            : Text(
                                "Verify and Proceed",
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
      ),
    );
  }
}
