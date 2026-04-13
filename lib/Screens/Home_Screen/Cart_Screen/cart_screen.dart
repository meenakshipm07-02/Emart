import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Circular_progressindicator/progress_indicator.dart';
import 'package:grocery_app/Datastore/shared_pref.dart';
import 'package:grocery_app/Providers/Razorpay_keyproviders/razorpay_keyprovider.dart';
import 'package:grocery_app/Providers/product_detail_provider.dart';
import 'package:grocery_app/Providers/Cart_providers/remove_cartproduct.dart';
import 'package:grocery_app/Providers/Cart_providers/update_cartprovider.dart';
import 'package:grocery_app/Providers/Cart_providers/view_cart.dart';
import 'package:grocery_app/Screens/Home_Screen/Cart_Screen/placeorder.dart';
import 'package:grocery_app/Screens/Home_Screen/Products_Screen/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/Common_Widgets/Cart_card/cart_card.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final CartProvider provider;
  bool _isCheckingOut = false;

  @override
  void initState() {
    super.initState();
    provider = CartProvider()..fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).fetchCart();
    });
    return ChangeNotifierProvider<CartProvider>.value(
      value: provider,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          toolbarHeight: SizeConfig.blockHeight * 8,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "My Cart",
            style: GoogleFonts.poppins(
              color: AppColors.secondary,
              fontSize: SizeConfig.blockHeight * 1.9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Consumer<CartProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CustomLoader(color: AppColors.success),
              );
            }

            if (provider.error.isNotEmpty) {
              return Center(child: Text(provider.error));
            }

            if (provider.cartItems.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockWidth * 4.5,
                  vertical: SizeConfig.blockHeight * 0.3,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/Loading_images/emptycart.png",
                      height: SizeConfig.blockHeight * 20,
                    ),
                    SizedBox(height: SizeConfig.blockHeight * 0.5),
                    Text(
                      "Your Cart is empty",
                      style: TextStyle(
                        fontSize: SizeConfig.blockHeight * 2,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockHeight * 1),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockHeight * 5,
                      ),
                      child: Text(
                        "Fill up your cart with your liked products. Start shopping now!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: SizeConfig.blockHeight * 1.7,
                          color: AppColors.subtitle,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                SizedBox(
                  height: SizeConfig.blockHeight * 37,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: provider.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = provider.cartItems[index];
                      return CartCard(
                        imageUrl: item.image,
                        itemName: item.name,
                        itemWeight: item.weight ?? 'N/A',
                        itemPrice: '₹${item.price}',
                        initialQuantity: item.quantity,
                        onRemove: () async {
                          final removecartProvider =
                              Provider.of<RemoveCartproductProvider>(
                                context,
                                listen: false,
                              );
                          final cartlist = Provider.of<CartProvider>(
                            context,
                            listen: false,
                          );

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(child: CustomLoader()),
                          );

                          try {
                            await removecartProvider.removecartitem(
                              item.productId,
                            );

                            if (!context.mounted) return;
                            Navigator.of(context).pop();

                            if (!removecartProvider.isError) {
                              await cartlist.fetchCart();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(
                                    child: Text(
                                      removecartProvider.message ??
                                          'Removed successfully',
                                      style: TextStyle(
                                        fontSize: SizeConfig.blockHeight * 1.6,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(
                                    child: Text(
                                      removecartProvider.message ??
                                          'Failed to remove item',
                                      style: TextStyle(
                                        fontSize: SizeConfig.blockHeight * 1.6,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                            }
                          } catch (e) {
                            if (!context.mounted) return;
                            Navigator.of(context).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(
                                  child: Text(
                                    e.toString(),
                                    style: TextStyle(
                                      fontSize: SizeConfig.blockHeight * 1.6,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        },

                        onTap: () async {
                          final detailProvider =
                              Provider.of<ProductDetailProvider>(
                                context,
                                listen: false,
                              );

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(
                              child: CustomLoader(color: AppColors.success),
                            ),
                          );

                          try {
                            await detailProvider.fetchProductDetail(
                              item.productId.toString(),
                            );

                            if (!context.mounted) return;

                            Navigator.of(context).pop();

                            if (detailProvider.product != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailScreen(
                                    product: detailProvider.product!,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(
                                    child: Text(
                                      'Product details not found',
                                      style: TextStyle(
                                        fontSize: SizeConfig.blockHeight * 1.6,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                            }
                          } catch (e) {
                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(
                                  child: Text(
                                    'Error: $e',
                                    style: TextStyle(
                                      fontSize: SizeConfig.blockHeight * 1.6,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        },
                        onDecrement: (newQuantity) async {
                          final cartUpdateProvider =
                              Provider.of<UpdateCartProvider>(
                                context,
                                listen: false,
                              );
                          final cartlist = Provider.of<CartProvider>(
                            context,
                            listen: false,
                          );

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(child: CustomLoader()),
                          );

                          try {
                            await cartUpdateProvider.updateCart(
                              item.productId,
                              newQuantity,
                            );

                            if (!context.mounted) return;
                            Navigator.of(context).pop();

                            final message =
                                cartUpdateProvider.message ??
                                'Cart updated successfully';
                            final isError =
                                message.toLowerCase().contains('error') ||
                                message.toLowerCase().contains('fail');

                            if (!isError) {
                              await cartlist.fetchCart();
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                                backgroundColor: isError
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            Navigator.of(context).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(
                                  child: Text(
                                    'Error: $e',
                                    style: TextStyle(
                                      fontSize: SizeConfig.blockHeight * 1.6,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        },

                        onIncrement: (newQuantity) async {
                          final cartUpdateProvider =
                              Provider.of<UpdateCartProvider>(
                                context,
                                listen: false,
                              );
                          final cartlist = Provider.of<CartProvider>(
                            context,
                            listen: false,
                          );

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(child: CustomLoader()),
                          );

                          try {
                            await cartUpdateProvider.updateCart(
                              item.productId,
                              newQuantity,
                            );

                            if (!context.mounted) return;
                            Navigator.of(context).pop();

                            final message =
                                cartUpdateProvider.message ??
                                'Cart updated successfully';
                            final isError =
                                message.toLowerCase().contains('error') ||
                                message.toLowerCase().contains('fail');

                            if (!isError) {
                              await cartlist.fetchCart();
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                                backgroundColor: isError
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            Navigator.of(context).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(
                                  child: Text(
                                    'Error: $e',
                                    style: TextStyle(
                                      fontSize: SizeConfig.blockHeight * 1.6,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: SizeConfig.blockHeight * 5),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Container(
                //     height: SizeConfig.blockHeight * 7.5,
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black.withOpacity(0.08),
                //           blurRadius: 8,
                //           spreadRadius: 2,
                //           offset: const Offset(0, 3),
                //         ),
                //       ],
                //       borderRadius: BorderRadius.circular(10),
                //     ),

                //     margin: EdgeInsets.symmetric(horizontal: 0),

                //     child: Padding(
                //       padding: EdgeInsets.symmetric(
                //         vertical: SizeConfig.blockHeight * 1.5,
                //         horizontal: SizeConfig.blockWidth * 3,
                //       ),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: <Widget>[
                //           Expanded(
                //             child: Row(
                //               children: [
                //                 Container(
                //                   width: SizeConfig.blockWidth * 10,
                //                   height: SizeConfig.blockWidth * 10,
                //                   decoration: BoxDecoration(
                //                     color: Colors.grey.shade100,
                //                     borderRadius: BorderRadius.circular(10),
                //                   ),
                //                   child: Icon(
                //                     Icons.percent,
                //                     color: const Color.fromARGB(
                //                       255,
                //                       5,
                //                       143,
                //                       47,
                //                     ),
                //                     size: SizeConfig.blockWidth * 5.5,
                //                   ),
                //                 ),

                //                 SizedBox(width: SizeConfig.blockWidth * 3),

                //                 Text(
                //                   'Apply a promo code',
                //                   style: TextStyle(
                //                     fontSize: SizeConfig.blockWidth * 3.8,
                //                     color: Colors.black87,
                //                     fontWeight: FontWeight.w500,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),

                //           ElevatedButton(
                //             onPressed: () {
                //               print('Promo code applied!');
                //             },
                //             style: ElevatedButton.styleFrom(
                //               backgroundColor: const Color.fromARGB(
                //                 255,
                //                 5,
                //                 143,
                //                 47,
                //               ),
                //               foregroundColor: Colors.white,
                //               minimumSize: Size(
                //                 SizeConfig.blockWidth * 20,
                //                 SizeConfig.blockHeight * 4,
                //               ),
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(10),
                //               ),
                //               padding: EdgeInsets.symmetric(
                //                 horizontal: SizeConfig.blockWidth * 5,
                //               ),
                //             ),
                //             child: Text(
                //               'Apply',
                //               style: TextStyle(
                //                 fontSize: SizeConfig.blockHeight * 1.8,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.blockHeight * 2,
                      horizontal: SizeConfig.blockWidth * 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subtotal :",
                              style: GoogleFonts.poppins(
                                fontSize: SizeConfig.blockWidth * 3.5,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '₹ ${provider.total.toDouble().toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontSize: SizeConfig.blockWidth * 3.6,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.blockHeight * 1),
                        Divider(thickness: 1, color: Colors.grey.shade300),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delivery :",
                              style: GoogleFonts.poppins(
                                fontSize: SizeConfig.blockWidth * 3.5,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "₹ 00.00",
                              style: GoogleFonts.poppins(
                                fontSize: SizeConfig.blockWidth * 3.6,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.blockHeight * 1),
                        Divider(thickness: 1, color: Colors.grey.shade300),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Cost :",
                              style: GoogleFonts.poppins(
                                fontSize: SizeConfig.blockWidth * 3.8,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹ ${provider.total.toDouble().toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontSize: SizeConfig.blockWidth * 3.8,
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: SizeConfig.blockHeight * 1.5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SizedBox(
                      width: SizeConfig.blockHeight * 30,
                      height: SizeConfig.blockHeight * 5.2,
                      child: ElevatedButton(
                        onPressed: _isCheckingOut
                            ? null
                            : () async {
                                setState(() {
                                  _isCheckingOut = true;
                                });

                                try {
                                  final userName =
                                      await SharedPrefs.getUsername() ??
                                      'Customer';
                                  final userEmail =
                                      await SharedPrefs.getUserEmail() ??
                                      'customer@email.com';
                                  final userPhone =
                                      await SharedPrefs.getUserPhone() ??
                                      '9876543210';
                                  final userId =
                                      await SharedPrefs.getUserId() ??
                                      'default_user';

                                  final formattedAmount = double.parse(
                                    provider.total.toStringAsFixed(2),
                                  );

                                  await Provider.of<RazorpayKeyProvider>(
                                    context,
                                    listen: false,
                                  ).fetchRazorpayKey();
                                  final razorpayKeyProvider =
                                      Provider.of<RazorpayKeyProvider>(
                                        context,
                                        listen: false,
                                      );
                                  if (razorpayKeyProvider.error.isNotEmpty) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Failed to initialize payment: ${razorpayKeyProvider.error}',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      setState(() {
                                        _isCheckingOut = false;
                                      });
                                    }
                                    return;
                                  }

                                  if (razorpayKeyProvider.razorpayKey == null ||
                                      razorpayKeyProvider
                                          .razorpayKey!
                                          .key
                                          .isEmpty) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Failed to get payment key',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      setState(() {
                                        _isCheckingOut = false;
                                      });
                                    }
                                    return;
                                  }
                                  final String razorpayKey =
                                      razorpayKeyProvider.razorpayKey!.key;
                                  if (mounted) {
                                    Navigator.of(context)
                                        .push(
                                          MaterialPageRoute(
                                            builder: (context) => Placeorder(
                                              orderid: provider.orderId,
                                              amount: formattedAmount,
                                              merchantKey: razorpayKey,
                                              userName: userName,
                                              userEmail: userEmail,
                                              userPhone: userPhone,
                                              userId: userId,
                                            ),
                                          ),
                                        )
                                        .then((_) {
                                          if (mounted) {
                                            setState(() {
                                              _isCheckingOut = false;
                                            });
                                          }
                                        });
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: ${e.toString()}'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    setState(() {
                                      _isCheckingOut = false;
                                    });
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            5,
                            143,
                            47,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isCheckingOut
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CustomLoader(color: Colors.white),
                              )
                            : Text(
                                "Checkout Now",
                                style: GoogleFonts.poppins(
                                  fontSize: SizeConfig.blockHeight * 1.8,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
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
