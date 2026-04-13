import 'package:flutter/material.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';

class LoginTextformfield extends StatefulWidget {
  final TextEditingController controller;
  final String hinttext;

  final bool isPassword;
  final bool readonly;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const LoginTextformfield({
    Key? key,
    required this.controller,
    required this.hinttext,
    this.isPassword = false,
    this.validator,
    this.readonly = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  State<LoginTextformfield> createState() => _LoginTextformfieldState();
}

class _LoginTextformfieldState extends State<LoginTextformfield> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      readOnly: widget.readonly,
      keyboardType: widget.keyboardType,
      style: TextStyle(
        fontSize: SizeConfig.blockHeight * 2,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      ),
      decoration: InputDecoration(
        isDense: true,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary,
            width: SizeConfig.screenWidth * 0.002,
          ),
        ),
        filled: true,
        fillColor: AppColors.white,
        hintText: widget.hinttext,
        hintStyle: TextStyle(
          fontSize: SizeConfig.blockHeight * 1.8,
          color: AppColors.subtitle.withOpacity(0.5),
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.black,
                  size: SizeConfig.screenHeight * 0.03,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        contentPadding: EdgeInsets.symmetric(
          vertical: SizeConfig.blockHeight * 1.7,
          horizontal: SizeConfig.screenWidth * 0,
        ),
      ),
      validator: widget.validator,
    );
  }
}
