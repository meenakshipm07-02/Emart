import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Circular_progressindicator/progress_indicator.dart';
import 'package:grocery_app/Common_Widgets/Login_Fields/login_textformfield.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';
import 'package:grocery_app/Providers/createacc_provider.dart';
import 'package:grocery_app/Screens/Login_Screen/login_screen.dart';
import 'package:provider/provider.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _createAccountKey = GlobalKey<FormState>();
  final name_Controller = TextEditingController();
  final email_Controller = TextEditingController();
  final password_Controller = TextEditingController();
  final phone_Controller = TextEditingController();
  // final auth_controller =TextEditingController();

  @override
  Widget build(BuildContext context) {
    final createaccProvider = Provider.of<CreateaccProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockWidth * 6.5,
            ),
            child: Form(
              key: _createAccountKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: SizeConfig.blockHeight * 1),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: SizeConfig.blockHeight * 3.8,
                        fontWeight: FontWeight.w600,
                      ),
                      children: const [
                        TextSpan(
                          text: "Create ",
                          style: TextStyle(color: AppColors.primary),
                        ),
                        TextSpan(
                          text: "Account",
                          style: TextStyle(color: AppColors.black),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockHeight * .3),

                  Text(
                    "Create your account here and enjoy\nThe shopping",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: SizeConfig.blockHeight * 1.8,
                      color: AppColors.subtitle,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 3.2),

                  Row(
                    children: [
                      Text(
                        'Full Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockHeight * 1.8,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  LoginTextformfield(
                    hinttext: 'Jhone doe',
                    controller: name_Controller,
                    isPassword: false,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 2),

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
                    hinttext: 'example@gmail.com',
                    controller: email_Controller,
                    isPassword: false,
                    keyboardType: TextInputType.emailAddress,
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
                  SizedBox(height: SizeConfig.blockHeight * 2),
                  Row(
                    children: [
                      Text(
                        'Phone ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockHeight * 1.8,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  LoginTextformfield(
                    hinttext: '+91 ',
                    controller: phone_Controller,
                    isPassword: false,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (value.length != 10) {
                        return 'Phone number must be exactly 10 digits';
                      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Phone number must contain only digits';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 2),

                  Row(
                    children: [
                      Text(
                        'Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockHeight * 1.8,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  LoginTextformfield(
                    hinttext: '••••••••',
                    controller: password_Controller,
                    isPassword: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 3.2),

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
                      onPressed: createaccProvider.isLoading
                          ? null
                          : () async {
                              if (_createAccountKey.currentState?.validate() ??
                                  false) {
                                final success = await createaccProvider
                                    .createAccount(
                                      name: name_Controller.text.trim(),
                                      email: email_Controller.text.trim(),
                                      password: password_Controller.text.trim(),
                                      phone: phone_Controller.text.trim(),
                                      address: 'bnc',
                                    );

                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: Duration(seconds: 1),
                                      backgroundColor: AppColors.primary,
                                      content: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          createaccProvider.successMessage ??
                                              "Account created successfully",
                                          style: TextStyle(
                                            fontSize:
                                                SizeConfig.blockHeight * 1.6,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: Duration(seconds: 1),
                                      backgroundColor: AppColors.error,

                                      content: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          createaccProvider.errorMessage ??
                                              "Registration failed",
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
                      child: createaccProvider.isLoading
                          ? const CustomLoader(
                              color: AppColors.primary,
                              size: 24,
                              strokeWidth: 3,
                            )
                          : Text(
                              "Sign Up",
                              style: GoogleFonts.poppins(
                                fontSize: SizeConfig.blockHeight * 1.8,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 1.8),

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
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockHeight * .8),

                  Image.asset(
                    "assets/Login_Images/pic1.jpg",
                    fit: BoxFit.cover,
                  ),

                  SizedBox(height: SizeConfig.blockHeight * .12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.poppins(
                          fontSize: SizeConfig.blockHeight * 1.7,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          "Log In",
                          style: GoogleFonts.poppins(
                            color: AppColors.primary,
                            fontSize: SizeConfig.blockHeight * 1.8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
