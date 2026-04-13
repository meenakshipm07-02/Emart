import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Circular_progressindicator/progress_indicator.dart';
import 'package:grocery_app/Common_Widgets/Login_Fields/login_textformfield.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';
import 'package:grocery_app/Providers/auth_provider.dart';
import 'package:grocery_app/Screens/Createacc_Screen/create_acc.dart';
import 'package:grocery_app/Screens/Home_Screen/hom_screen.dart';
import 'package:grocery_app/Screens/Login_Screen/Forgot_Password/forgot_password.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isFieldsReadOnly = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Login_Images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockWidth * 6.5,
              ),
              child: Form(
                key: _loginKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: SizeConfig.blockHeight * 3.4),
                    SizedBox(
                      height: SizeConfig.blockHeight * 28,
                      width: SizeConfig.blockWidth * 90,
                      child: Image.asset('assets/Login_Images/pic2.png'),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: SizeConfig.blockHeight * 3.8,
                          fontWeight: FontWeight.w600,
                        ),
                        children: const [
                          TextSpan(
                            text: "Hello ",
                            style: TextStyle(color: AppColors.primary),
                          ),
                          TextSpan(
                            text: "Again!",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      " Log In and enjoy your Shopping",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: SizeConfig.blockHeight * 1.8,
                        color: AppColors.subtitle,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockHeight * 4.5),

                    Row(
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.blockHeight * 1.8,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    LoginTextformfield(
                      hinttext: 'Example@gmail.com',
                      controller: emailController,
                      isPassword: false,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the email address';
                        } else if (!RegExp(
                          r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: SizeConfig.blockHeight * 3),
                    Row(
                      children: [
                        Text(
                          'Password',
                          style: TextStyle(
                            fontSize: SizeConfig.blockHeight * 1.8,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    LoginTextformfield(
                      controller: passwordController,
                      hinttext: '******',
                      isPassword: true,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: SizeConfig.blockHeight * .8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ForgotPassword(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot password?",
                            style: GoogleFonts.poppins(
                              color: AppColors.black,
                              fontSize: SizeConfig.blockHeight * 1.7,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.blockHeight * 2),
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
                          onPressed: authProvider.isLoading
                              ? null
                              : () async {
                                  if (_loginKey.currentState?.validate() ??
                                      false) {
                                    final success = await authProvider.login(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                    );

                                    if (success) {
                                      if (!mounted) return;
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen(),
                                        ),
                                      );
                                    } else {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 1),
                                          backgroundColor: AppColors.error,
                                          content: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              style: GoogleFonts.poppins(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              authProvider.errorMessage ??
                                                  "Login failed",
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                          child: authProvider.isLoading
                              ? const CustomLoader(
                                  color: AppColors.primary,
                                  size: 24,
                                  strokeWidth: 3,
                                )
                              : Text(
                                  "Log In",
                                  style: GoogleFonts.poppins(
                                    fontSize: SizeConfig.blockHeight * 1.8,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    Column(
                      children: [
                        SizedBox(height: SizeConfig.blockHeight * 3),
                        SizedBox(
                          width: SizeConfig.blockWidth * 85,
                          height: SizeConfig.blockHeight * 5.5,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade200,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/Icons/google.png',
                              height: SizeConfig.blockHeight * 3.4,
                              width: SizeConfig.blockWidth * 6,
                            ),
                            label: Text(
                              'Sign In with Google',
                              style: GoogleFonts.poppins(
                                fontSize: SizeConfig.blockHeight * 1.8,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockHeight * 1.5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'New User?',
                              style: GoogleFonts.poppins(
                                fontSize: SizeConfig.blockHeight * 1.7,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => CreateAccount(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: Text(
                                'Create Account',
                                style: GoogleFonts.poppins(
                                  fontSize: SizeConfig.blockHeight * 1.8,
                                  color: const Color.fromARGB(255, 5, 143, 47),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
