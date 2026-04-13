import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';
import 'package:grocery_app/Datastore/shared_pref.dart';
import 'package:grocery_app/Screens/Welcome_Screen/welcome_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? name;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    name = await SharedPrefs.getUsername();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth * 0.65,
      child: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
        ),
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            SizedBox(height: SizeConfig.blockHeight * 5),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 5, 143, 47),
                        width: 3,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: SizeConfig.blockHeight * 4,
                      backgroundImage: AssetImage('assets/Icons/person.png'),
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 2),
                  Text(
                    '$name',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: SizeConfig.blockHeight * 1.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 0.5),
                  Text(
                    'customer',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: SizeConfig.blockHeight * 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 2),
                  Divider(endIndent: 7, indent: 5),
                  ListTile(
                    leading: Icon(
                      size: SizeConfig.screenHeight * 0.03,
                      Icons.info_outline,
                      color: const Color.fromARGB(255, 13, 56, 55),
                    ),
                    title: Text(
                      'About',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "About",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: SizeConfig.blockHeight * 2.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: SizeConfig.blockHeight * 1),
                              Text(
                                "This App helps you shop fresh fruits, "
                                "vegetables, and daily essentials online. "
                                "Get fast delivery, save time, and enjoy exclusive deals "
                                "right at your doorstep.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: SizeConfig.blockHeight * 1.5,
                                  color: Colors.grey,
                                  height: SizeConfig.blockHeight * 0.18,
                                ),
                              ),
                              SizedBox(height: SizeConfig.blockHeight * 3),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    5,
                                    143,
                                    47,
                                  ),
                                  minimumSize: Size(
                                    double.infinity,
                                    SizeConfig.screenWidth * 0.1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "Close",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 1),
                  ListTile(
                    leading: Icon(
                      size: SizeConfig.screenHeight * 0.03,
                      Icons.history_sharp,
                      color: Color.fromARGB(255, 13, 56, 55),
                    ),
                    title: Text(
                      'Order History',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          backgroundColor: AppColors.primary,
                          content: Center(
                            child: Text(
                              'On progress',
                              style: TextStyle(
                                fontSize: SizeConfig.blockHeight * 1.6,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 1),
                  ListTile(
                    leading: Icon(
                      size: SizeConfig.screenHeight * 0.03,
                      Icons.money,
                      color: Color.fromARGB(255, 13, 56, 55),
                    ),
                    title: Text(
                      'Payment History',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          backgroundColor: AppColors.primary,
                          content: Center(
                            child: Text(
                              'On progress',
                              style: TextStyle(
                                fontSize: SizeConfig.blockHeight * 1.6,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 1),

                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      size: SizeConfig.screenHeight * 0.03,
                      color: const Color.fromARGB(255, 13, 56, 55),
                    ),
                    title: Text(
                      'Logout',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Confirm Logout",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: SizeConfig.blockHeight * 2.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: SizeConfig.blockHeight * 1),
                              Text(
                                "Are you sure you want to log out?",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: SizeConfig.blockHeight * 1.5,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: SizeConfig.blockHeight * 3),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          5,
                                          143,
                                          47,
                                        ),
                                        minimumSize: Size(
                                          double.infinity,
                                          SizeConfig.screenWidth * 0.1,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.blockWidth * 2),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          186,
                                          56,
                                          47,
                                        ),
                                        minimumSize: Size(
                                          double.infinity,
                                          SizeConfig.screenWidth * 0.1,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        Navigator.pop(context);

                                        await SharedPrefs.clearAll();

                                        Navigator.of(
                                          context,
                                        ).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const WelcomeScreen(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      child: const Text(
                                        "Logout",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
