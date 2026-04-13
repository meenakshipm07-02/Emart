import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Circular_progressindicator/progress_indicator.dart';
import 'package:grocery_app/Common_Widgets/Profile%20_Card/profile_card.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';
import 'package:grocery_app/Datastore/shared_pref.dart';
import 'package:grocery_app/Providers/Profile_providers/editprofile_provider.dart';
import 'package:grocery_app/Providers/Profile_providers/profile_provider.dart';
import 'package:grocery_app/Screens/Home_Screen/Favourite_Screen/favourite_screen.dart';
import 'package:grocery_app/Screens/Home_Screen/Profile_Screen/address_screen.dart';
import 'package:grocery_app/Screens/Welcome_Screen/welcome_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        toolbarHeight: SizeConfig.blockHeight * 8,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: SizeConfig.blockHeight * 1.9,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CustomLoader(color: AppColors.success),
              );
            }

            if (provider.errorMessage != null) {
              return Center(child: Text(provider.errorMessage!));
            }

            final profile = provider.profileModel?.profile;
            if (profile == null) {
              return const Center(child: Text("No profile data found"));
            }
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockWidth * 2,
                vertical: SizeConfig.blockHeight * 1,
              ),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.blockHeight * .5),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockWidth * 1,
                      vertical: SizeConfig.blockHeight * 1,
                    ),
                    padding: EdgeInsets.all(SizeConfig.blockHeight * 1.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: SizeConfig.blockHeight * 7.5,
                          height: SizeConfig.blockHeight * 7.5,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary),
                            color: AppColors.subtitle.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person,
                              size: SizeConfig.blockHeight * 3,
                              color: AppColors.black.withOpacity(0.8),
                            ),
                          ),
                        ),

                        SizedBox(width: SizeConfig.blockWidth * 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.name,
                                style: GoogleFonts.poppins(
                                  fontSize: SizeConfig.blockHeight * 1.8,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: SizeConfig.blockHeight * 0.5),
                              Text(
                                profile.email,
                                style: GoogleFonts.poppins(
                                  fontSize: SizeConfig.blockHeight * 1.4,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockWidth * 2,
                          vertical: SizeConfig.blockHeight * 1,
                        ),
                        child: Text(
                          "Personal Information",
                          style: GoogleFonts.poppins(
                            fontSize: SizeConfig.blockHeight * 2,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.subtitle.withOpacity(0.5),
                            ),

                            padding: EdgeInsets.all(
                              SizeConfig.screenWidth * 0.01,
                            ),
                            child: Column(
                              children: [
                                ProfileCard(
                                  title: 'Edit Profile',
                                  leftIcon: Icons.edit,
                                  onTap: () {
                                    final nameController =
                                        TextEditingController(
                                          text: profile.name,
                                        );
                                    final emailController =
                                        TextEditingController(
                                          text: profile.email,
                                        );
                                    final phoneController =
                                        TextEditingController(
                                          text: profile.phone,
                                        );

                                    final editkey = GlobalKey<FormState>();

                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (context) {
                                        final editProvider =
                                            Provider.of<EditProfileProvider>(
                                              context,
                                              listen: false,
                                            );
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(
                                              context,
                                            ).viewInsets.bottom,
                                            left: SizeConfig.blockWidth * 5,
                                            right: SizeConfig.blockWidth * 5,
                                            top: SizeConfig.blockHeight * 3,
                                          ),
                                          child: Form(
                                            key: editkey,

                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Header
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Edit Profile',
                                                      style: GoogleFonts.poppins(
                                                        fontSize:
                                                            SizeConfig
                                                                .blockHeight *
                                                            2.2,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                SizedBox(
                                                  height:
                                                      SizeConfig.blockHeight *
                                                      2,
                                                ),

                                                // Name Field
                                                Text(
                                                  'Full Name',
                                                  style: GoogleFonts.poppins(
                                                    fontSize:
                                                        SizeConfig.blockHeight *
                                                        1.6,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      SizeConfig.blockHeight *
                                                      0.8,
                                                ),
                                                TextFormField(
                                                  controller: nameController,
                                                  enabled: true,
                                                  decoration: InputDecoration(
                                                    hintText: 'Enter your name',
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      borderSide: BorderSide(
                                                        color:
                                                            Colors.grey[300]!,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: Colors
                                                                    .grey[300]!,
                                                              ),
                                                        ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: AppColors
                                                                    .primary,
                                                              ),
                                                        ),
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                          horizontal:
                                                              SizeConfig
                                                                  .blockWidth *
                                                              4,
                                                          vertical:
                                                              SizeConfig
                                                                  .blockHeight *
                                                              1.5,
                                                        ),
                                                  ),
                                                  style: GoogleFonts.poppins(
                                                    fontSize:
                                                        SizeConfig.blockHeight *
                                                        1.6,
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter your name';
                                                    }
                                                    return null;
                                                  },
                                                ),

                                                SizedBox(
                                                  height:
                                                      SizeConfig.blockHeight *
                                                      2,
                                                ),

                                                // Email Field
                                                Text(
                                                  'Email Address',
                                                  style: GoogleFonts.poppins(
                                                    fontSize:
                                                        SizeConfig.blockHeight *
                                                        1.6,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      SizeConfig.blockHeight *
                                                      0.8,
                                                ),
                                                TextFormField(
                                                  controller: emailController,
                                                  enabled: true,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Enter your email',
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      borderSide: BorderSide(
                                                        color:
                                                            Colors.grey[300]!,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: Colors
                                                                    .grey[300]!,
                                                              ),
                                                        ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: AppColors
                                                                    .primary,
                                                              ),
                                                        ),
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                          horizontal:
                                                              SizeConfig
                                                                  .blockWidth *
                                                              4,
                                                          vertical:
                                                              SizeConfig
                                                                  .blockHeight *
                                                              1.5,
                                                        ),
                                                  ),
                                                  style: GoogleFonts.poppins(
                                                    fontSize:
                                                        SizeConfig.blockHeight *
                                                        1.6,
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter your email';
                                                    }
                                                    if (!RegExp(
                                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                                    ).hasMatch(value)) {
                                                      return 'Please enter a valid email';
                                                    }
                                                    return null;
                                                  },
                                                ),

                                                SizedBox(
                                                  height:
                                                      SizeConfig.blockHeight *
                                                      2,
                                                ),

                                                // Phone Field
                                                Text(
                                                  'Phone Number',
                                                  style: GoogleFonts.poppins(
                                                    fontSize:
                                                        SizeConfig.blockHeight *
                                                        1.6,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      SizeConfig.blockHeight *
                                                      0.8,
                                                ),
                                                TextFormField(
                                                  controller: phoneController,
                                                  enabled: true,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Enter your phone number',
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      borderSide: BorderSide(
                                                        color:
                                                            Colors.grey[300]!,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: Colors
                                                                    .grey[300]!,
                                                              ),
                                                        ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: AppColors
                                                                    .primary,
                                                              ),
                                                        ),
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                          horizontal:
                                                              SizeConfig
                                                                  .blockWidth *
                                                              4,
                                                          vertical:
                                                              SizeConfig
                                                                  .blockHeight *
                                                              1.5,
                                                        ),
                                                  ),
                                                  style: GoogleFonts.poppins(
                                                    fontSize:
                                                        SizeConfig.blockHeight *
                                                        1.6,
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter your phone number';
                                                    }
                                                    if (value.length < 10) {
                                                      return 'Phone number must be at least 10 digits';
                                                    }
                                                    return null;
                                                  },
                                                ),

                                                SizedBox(
                                                  height:
                                                      SizeConfig.blockHeight *
                                                      4,
                                                ),

                                                SizedBox(
                                                  width: double.infinity,
                                                  height:
                                                      SizeConfig.blockHeight *
                                                      6,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          AppColors.primary,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                      elevation: 0,
                                                    ),
                                                    onPressed:
                                                        editProvider.isLoading
                                                        ? null
                                                        : () async {
                                                            if (editkey
                                                                .currentState!
                                                                .validate()) {
                                                              // Get providers
                                                              final profileProvider =
                                                                  Provider.of<
                                                                    ProfileProvider
                                                                  >(
                                                                    context,
                                                                    listen:
                                                                        false,
                                                                  );

                                                              try {
                                                                // Call editProfile
                                                                final success = await editProvider.editProfile(
                                                                  name:
                                                                      nameController
                                                                          .text,
                                                                  email:
                                                                      emailController
                                                                          .text,
                                                                  phone:
                                                                      phoneController
                                                                          .text,
                                                                );

                                                                if (success) {
                                                                  // Close bottom sheet
                                                                  Navigator.pop(
                                                                    context,
                                                                  );

                                                                  // Show success message
                                                                  ScaffoldMessenger.of(
                                                                    context,
                                                                  ).showSnackBar(
                                                                    SnackBar(
                                                                      backgroundColor:
                                                                          AppColors
                                                                              .success,
                                                                      content: Text(
                                                                        editProvider.successMessage ??
                                                                            'Profile updated successfully!',
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              SizeConfig.blockHeight *
                                                                              1.6,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );

                                                                  // Refresh profile data
                                                                  profileProvider
                                                                      .fetchProfile();
                                                                } else {
                                                                  // Show error message (keep bottom sheet open)
                                                                  ScaffoldMessenger.of(
                                                                    context,
                                                                  ).showSnackBar(
                                                                    SnackBar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      content: Text(
                                                                        editProvider.errorMessage ??
                                                                            'Failed to update profile',
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              SizeConfig.blockHeight *
                                                                              1.6,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                              } catch (e) {
                                                                // Show error message
                                                                ScaffoldMessenger.of(
                                                                  context,
                                                                ).showSnackBar(
                                                                  SnackBar(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    content: Text(
                                                                      'An error occurred: ${e.toString()}',
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            SizeConfig.blockHeight *
                                                                            1.6,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                          },
                                                    child:
                                                        editProvider.isLoading
                                                        ? CircularProgressIndicator(
                                                            color: Colors.white,
                                                            strokeWidth: 2,
                                                          )
                                                        : Text(
                                                            'Save Changes',
                                                            style: GoogleFonts.poppins(
                                                              fontSize:
                                                                  SizeConfig
                                                                      .blockHeight *
                                                                  1.8,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                  ),
                                                ),

                                                SizedBox(
                                                  height:
                                                      SizeConfig.blockHeight *
                                                      2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),

                                ProfileCard(
                                  title: 'Saved Address',
                                  leftIcon: Icons.dataset,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SavedAddressesScreen(),
                                      ),
                                    );
                                  },
                                ),
                                ProfileCard(
                                  title: 'Favourites',
                                  leftIcon: Icons.favorite,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FavouriteScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: SizeConfig.blockHeight * 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.blockWidth * 2,
                                  vertical: SizeConfig.blockHeight * 1,
                                ),
                                child: Text(
                                  "Settings",
                                  style: GoogleFonts.poppins(
                                    fontSize: SizeConfig.blockHeight * 2,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.subtitle.withOpacity(0.5),
                            ),

                            padding: EdgeInsets.all(
                              SizeConfig.screenWidth * 0.01,
                            ),
                            child: Column(
                              children: [
                                ProfileCard(
                                  title: 'About',
                                  leftIcon: Icons.info,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.all(
                                          20,
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "About",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize:
                                                    SizeConfig.blockHeight *
                                                    2.5,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  SizeConfig.blockHeight * 1,
                                            ),
                                            Text(
                                              "This App helps you shop fresh fruits, "
                                              "vegetables, and daily essentials online. "
                                              "Get fast delivery, save time, and enjoy exclusive deals "
                                              "right at your doorstep.",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize:
                                                    SizeConfig.blockHeight *
                                                    1.5,
                                                color: Colors.grey,
                                                height:
                                                    SizeConfig.blockHeight *
                                                    0.18,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  SizeConfig.blockHeight * 3,
                                            ),
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
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text(
                                                "Close",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                // HELP & SUPPORT CARD
                                ProfileCard(
                                  title: 'Help & Support',
                                  leftIcon: Icons.headphones,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(seconds: 1),
                                        backgroundColor: AppColors.primary,
                                        content: Center(
                                          child: Text(
                                            'On progress',
                                            style: TextStyle(
                                              fontSize:
                                                  SizeConfig.blockHeight * 1.6,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                ProfileCard(
                                  title: 'Log Out',
                                  leftIcon: Icons.exit_to_app,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.all(
                                          20,
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Confirm Logout",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize:
                                                    SizeConfig.blockHeight *
                                                    2.5,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  SizeConfig.blockHeight * 1,
                                            ),
                                            Text(
                                              "Are you sure you want to log out?",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize:
                                                    SizeConfig.blockHeight *
                                                    1.5,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  SizeConfig.blockHeight * 3,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                            255,
                                                            5,
                                                            143,
                                                            47,
                                                          ),
                                                      minimumSize: Size(
                                                        double.infinity,
                                                        SizeConfig.screenWidth *
                                                            0.1,
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      SizeConfig.blockWidth * 2,
                                                ),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                            255,
                                                            186,
                                                            56,
                                                            47,
                                                          ),
                                                      minimumSize: Size(
                                                        double.infinity,
                                                        SizeConfig.screenWidth *
                                                            0.1,
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
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
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
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
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
