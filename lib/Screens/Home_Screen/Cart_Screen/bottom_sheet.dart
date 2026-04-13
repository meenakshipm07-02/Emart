import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';
import 'package:grocery_app/Common_Widgets/Circular_progressindicator/progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/Providers/Address_providers/add_addressprovider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class AddAddressBottomSheet extends StatefulWidget {
  final VoidCallback onAddressAdded;

  const AddAddressBottomSheet({super.key, required this.onAddressAdded});

  @override
  State<AddAddressBottomSheet> createState() => _AddAddressBottomSheetState();
}

class _AddAddressBottomSheetState extends State<AddAddressBottomSheet> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedAddressType = "Home";
  bool _isFetchingLocation = false;

  @override
  void dispose() {
    addressController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check location permission
      final permission = await Permission.location.request();

      if (permission.isGranted) {
        // Set loading state to true
        setState(() {
          _isFetchingLocation = true;
        });

        // Get current position
        final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // Get address from coordinates
        final List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final Placemark placemark = placemarks.first;

          // Build address string WITHOUT pincode
          String address = '';
          if (placemark.street != null && placemark.street!.isNotEmpty) {
            address += '${placemark.street}, ';
          }
          if (placemark.subLocality != null &&
              placemark.subLocality!.isNotEmpty) {
            address += '${placemark.subLocality}, ';
          }
          if (placemark.locality != null && placemark.locality!.isNotEmpty) {
            address += '${placemark.locality}, ';
          }
          if (placemark.administrativeArea != null &&
              placemark.administrativeArea!.isNotEmpty) {
            address += '${placemark.administrativeArea}';
          }

          // Remove trailing comma and space
          address = address.replaceAll(RegExp(r', $'), '');

          // Update the form fields
          setState(() {
            addressController.text = address;
            if (placemark.postalCode != null &&
                placemark.postalCode!.isNotEmpty) {
              pincodeController.text = placemark.postalCode!;
            }
          });

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: AppColors.success,
              content: Center(
                child: Text(
                  'Location fetched successfully!',
                  style: TextStyle(
                    fontSize: SizeConfig.blockHeight * 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }
      } else if (permission.isDenied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.error,
            content: Center(
              child: Text(
                'Location permission denied',
                style: TextStyle(
                  fontSize: SizeConfig.blockHeight * 1.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      } else if (permission.isPermanentlyDenied) {
        if (!mounted) return;
        _showLocationPermissionDialog();
      }
    } catch (e) {
      debugPrint('Location error: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.error,
          content: Center(
            child: Text(
              'Failed to get location: $e',
              style: TextStyle(
                fontSize: SizeConfig.blockHeight * 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    } finally {
      // Set loading state to false when done (whether success or error)
      if (mounted) {
        setState(() {
          _isFetchingLocation = false;
        });
      }
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Location Permission Required'),
        content: Text(
          'Please enable location permission in app settings to use this feature.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 25,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.subtitle,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Add Address",
                  style: GoogleFonts.poppins(
                    color: AppColors.secondary,
                    fontSize: SizeConfig.blockHeight * 2.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // LOCATION BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isFetchingLocation ? null : _getCurrentLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: AppColors.primary),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.blockHeight * 1.5,
                    ),
                  ),
                  icon: _isFetchingLocation
                      ? CustomLoader(
                          color: AppColors.primary,
                          size: SizeConfig.blockHeight * 2.0,
                          strokeWidth: 2,
                        )
                      : Icon(
                          Icons.location_on,
                          size: SizeConfig.blockHeight * 2.0,
                        ),
                  label: _isFetchingLocation
                      ? Text(
                          "Fetching Location...",
                          style: GoogleFonts.poppins(
                            fontSize: SizeConfig.blockHeight * 1.6,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : Text(
                          "Use Current Location",
                          style: GoogleFonts.poppins(
                            fontSize: SizeConfig.blockHeight * 1.6,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              SizedBox(height: SizeConfig.blockHeight * 2),

              Text(
                'Address Type',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.blockHeight * 1.7,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      value: "Home",
                      groupValue: selectedAddressType,
                      onChanged: (value) {
                        setState(() {
                          selectedAddressType = value;
                        });
                      },
                      activeColor: AppColors.primary,
                      title: Text(
                        "Home",
                        style: TextStyle(
                          fontSize: SizeConfig.blockHeight * 1.7,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      value: "Work",
                      groupValue: selectedAddressType,
                      onChanged: (value) {
                        setState(() {
                          selectedAddressType = value;
                        });
                      },
                      activeColor: AppColors.primary,
                      title: Text(
                        "Work",
                        style: TextStyle(
                          fontSize: SizeConfig.blockHeight * 1.7,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Address',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.blockHeight * 1.7,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: addressController,
                style: TextStyle(fontSize: SizeConfig.blockHeight * 1.7),
                decoration: InputDecoration(
                  hintText: "Full Address",
                  hintStyle: TextStyle(fontSize: SizeConfig.blockHeight * 1.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Address cannot be empty";
                  }
                  return null;
                },
                maxLines: 2,
              ),
              const SizedBox(height: 15),
              Text(
                'Pin Code',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.blockHeight * 1.7,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: pincodeController,
                decoration: InputDecoration(
                  hintText: "Pin Code",
                  hintStyle: TextStyle(fontSize: SizeConfig.blockHeight * 1.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Pincode cannot be empty";
                  } else if (value.trim().length != 6) {
                    return "Pincode must be 6 digits";
                  } else if (int.tryParse(value.trim()) == null) {
                    return "Only numbers are allowed";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                maxLines: 1,
              ),
              SizedBox(height: SizeConfig.blockHeight * 4),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Consumer<AddAddressProvider>(
                      builder: (context, provider, child) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: provider.isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    await provider.addAddress(
                                      address: addressController.text.trim(),
                                      pincode: pincodeController.text.trim(),
                                      addressType:
                                          selectedAddressType ?? "Home",
                                    );

                                    if (provider.errorMessage != null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 1),
                                          backgroundColor: AppColors.error,
                                          content: Center(
                                            child: Text(
                                              provider.errorMessage!,
                                              style: TextStyle(
                                                fontSize:
                                                    SizeConfig.blockHeight *
                                                    1.6,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (provider.addressResponse !=
                                        null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 1),
                                          backgroundColor: AppColors.primary,
                                          content: Center(
                                            child: Text(
                                              "Address added successfully!",
                                              style: TextStyle(
                                                fontSize:
                                                    SizeConfig.blockHeight *
                                                    1.6,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                      widget.onAddressAdded();
                                      addressController.clear();
                                      pincodeController.clear();
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                          child: provider.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CustomLoader(color: AppColors.success),
                                )
                              : const Text(
                                  "Add",
                                  style: TextStyle(color: Colors.white),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.blockHeight * 3),
            ],
          ),
        ),
      ),
    );
  }
}
