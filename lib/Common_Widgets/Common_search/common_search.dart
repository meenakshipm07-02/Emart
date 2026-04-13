import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';

class CommonSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const CommonSearchBar({
    Key? key,
    required this.controller,
    this.hintText = "",
    this.onChanged,
  }) : super(key: key);

  @override
  State<CommonSearchBar> createState() => _CommonSearchBarState();
}

class _CommonSearchBarState extends State<CommonSearchBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            height: SizeConfig.blockHeight * 5.2,
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockWidth * 4,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Image.asset(
                  "assets/Icons/search.png",
                  height: SizeConfig.blockHeight * 2.4,
                  width: SizeConfig.blockHeight * 3,
                  color: const Color.fromARGB(255, 114, 113, 113),
                ),
                SizedBox(width: SizeConfig.blockWidth * 3),
                Expanded(
                  child: TextField(
                    style: GoogleFonts.poppins(
                      fontSize: SizeConfig.blockHeight * 1.6,
                      color: Colors.black.withOpacity(0.7),
                    ),
                    controller: widget.controller,
                    onChanged: widget.onChanged,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                      hintStyle: TextStyle(
                        color: const Color.fromARGB(255, 114, 114, 114),
                        fontSize: SizeConfig.blockHeight * 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                      hintText: widget.hintText,
                      border: InputBorder.none,
                      suffixIcon: widget.controller.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                widget.controller.clear();
                                if (widget.onChanged != null) {
                                  widget.onChanged!("");
                                }
                              },
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
