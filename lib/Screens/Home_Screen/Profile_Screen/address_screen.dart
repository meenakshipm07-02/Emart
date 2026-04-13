import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Address_Card/address_card.dart';
import 'package:grocery_app/Common_Widgets/Circular_progressindicator/progress_indicator.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';
import 'package:grocery_app/Providers/Address_providers/remove_addressprovider.dart';
import 'package:grocery_app/Providers/Address_providers/view_addressprovider.dart';
import 'package:provider/provider.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  List<String> addresses = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ViewAddressProvider>(context, listen: false).fetchAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: SizeConfig.blockHeight * 8,
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        title: Text(
          'Saved Address',
          style: GoogleFonts.poppins(
            fontSize: SizeConfig.blockHeight * 1.9,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Consumer<ViewAddressProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CustomLoader());
            }

            if (provider.errorMessage != null) {
              return Center(
                child: Text(
                  "Error: ${provider.errorMessage}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final addresses = provider.addressResponse?.addresses ?? [];

            return Column(
              children: [
                Container(
                  height: SizeConfig.blockHeight * 48,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: addresses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/Loading_images/no_data.png',
                                height: SizeConfig.blockHeight * 15,
                              ),
                              Text(
                                "You do not have any saved address",
                                style: GoogleFonts.poppins(
                                  fontSize: SizeConfig.blockHeight * 1.8,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: addresses.map((address) {
                              return AddressCard(
                                id: address.addressid,
                                addressType: address.addressType,
                                address: address.address,
                                pincode: address.pincode,

                                onDelete: () async {
                                  final removeProvider =
                                      Provider.of<RemoveAddressProvider>(
                                        context,
                                        listen: false,
                                      );
                                  final viewProvider =
                                      Provider.of<ViewAddressProvider>(
                                        context,
                                        listen: false,
                                      );

                                  try {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => const Center(
                                        child: CustomLoader(
                                          color: AppColors.error,
                                        ),
                                      ),
                                    );

                                    await removeProvider.removeAddress(
                                      address.addressid,
                                    );

                                    Navigator.pop(context);

                                    final response = removeProvider.response;

                                    if (response?['status'] == 'success') {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          backgroundColor: AppColors.primary,
                                          content: Center(
                                            child: Text(
                                              response?['message'] ??
                                                  'Address deleted',
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

                                      await viewProvider.fetchAddresses();
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          backgroundColor: AppColors.error,
                                          content: Center(
                                            child: Text(
                                              response?['message'] ??
                                                  'Failed to delete',
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
                                    }
                                  } catch (e) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: AppColors.error,
                                        content: Center(
                                          child: Text(
                                            'Error: $e',
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
                                },
                              );
                            }).toList(),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
