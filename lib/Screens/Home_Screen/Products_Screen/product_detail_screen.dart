import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Circular_progressindicator/progress_indicator.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';
import 'package:grocery_app/Datastore/shared_pref.dart';
import 'package:grocery_app/Models/Product_Model/product_detail_model.dart';
import 'package:grocery_app/Providers/Buynow_provider/buynow_provider.dart';
import 'package:grocery_app/Providers/Cart_providers/addto_cart.dart';
import 'package:grocery_app/Screens/Home_Screen/Cart_Screen/placeorder.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductDetailModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  final PageController _pageController = PageController();

  void increment() => setState(() => quantity++);
  void decrement() => setState(() => quantity > 1 ? quantity-- : quantity);

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Details',
          style: GoogleFonts.poppins(
            color: AppColors.secondary,
            fontSize: SizeConfig.blockHeight * 2,
            fontWeight: FontWeight.w600,
          ),
        ),

        toolbarHeight: SizeConfig.blockHeight * 8,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: SizeConfig.blockHeight * 2.8,
            weight: SizeConfig.blockWidth * 5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: SizeConfig.blockHeight * 30,
              child: PageView.builder(
                controller: _pageController,
                itemCount: product.images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        product.images[index],
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.error),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: SizeConfig.blockHeight * 1.5),
            Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: product.images.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.black87,
                  dotColor: Colors.grey.shade300,
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockHeight * 1.5),

            Row(
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: GoogleFonts.poppins(
                      fontSize: SizeConfig.blockHeight * 1.9,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2, // Allow up to 2 lines
                    overflow:
                        TextOverflow.ellipsis, // Show "..." if text is too long
                  ),
                ),
              ],
            ),

            SizedBox(height: SizeConfig.blockHeight * 1.7),
            Text(
              "Weight: ${product.weight}",
              style: GoogleFonts.poppins(
                fontSize: SizeConfig.blockHeight * 1.6,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: SizeConfig.blockHeight * 2),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: SizeConfig.blockHeight * 4,
                  width: SizeConfig.blockWidth * 28,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "Price:  ₹${(double.tryParse(product.price) ?? 0.0)}",
                      style: GoogleFonts.poppins(
                        fontSize: SizeConfig.blockHeight * 1.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: SizeConfig.blockHeight * 4),

                Container(
                  height: SizeConfig.blockHeight * 4,
                  width: SizeConfig.blockWidth * 28,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        iconSize: SizeConfig.blockHeight * 2.2,
                        onPressed: decrement,
                      ),
                      Text(
                        quantity.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: SizeConfig.blockHeight * 2,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        iconSize: SizeConfig.blockHeight * 2.2,
                        onPressed: increment,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: SizeConfig.blockHeight * 2),

            Text(
              "Description",
              style: GoogleFonts.poppins(
                fontSize: SizeConfig.blockHeight * 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: SizeConfig.blockHeight * 1),
            Text(
              product.description,
              style: GoogleFonts.poppins(
                fontSize: SizeConfig.blockHeight * 1.5,
              ),
            ),

            SizedBox(height: SizeConfig.blockHeight * 4),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: SizeConfig.blockHeight * 4.5,
                  width: SizeConfig.blockWidth * 42,
                  child: ElevatedButton(
                    onPressed: () async {
                      final cartProvider = Provider.of<AddToCartProvider>(
                        context,
                        listen: false,
                      );

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(child: CustomLoader()),
                      );

                      try {
                        final message = await cartProvider.addToCart(
                          product.id.toString(),
                          quantity,
                        );

                        if (!context.mounted) return;
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(
                              child: Text(
                                message,
                                style: TextStyle(
                                  fontSize: SizeConfig.blockHeight * 1.6,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(
                              child: Text(
                                '$e',
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
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Add To Cart",
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontSize: SizeConfig.blockHeight * 1.8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockHeight * 4.5,
                  width: SizeConfig.blockWidth * 42,
                  child: ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(child: CustomLoader()),
                      );

                      try {
                        final userName =
                            await SharedPrefs.getUsername() ?? 'Customer';
                        final userEmail =
                            await SharedPrefs.getUserEmail() ??
                            'customer@email.com';
                        final userPhone =
                            await SharedPrefs.getUserPhone() ?? '9876543210';
                        final userId =
                            await SharedPrefs.getUserId() ?? 'default_user';

                        // 2. Call BuyNow API
                        final buyNowProvider = Provider.of<BuyNowProvider>(
                          context,
                          listen: false,
                        );

                        await buyNowProvider.buyNow(
                          product.id.toString(),
                          quantity, // Use the quantity from state
                        );

                        if (!context.mounted) return;

                        // Close the loader
                        Navigator.of(context).pop();

                        // 3. Check if BuyNow was successful
                        if (buyNowProvider.hasError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 2),
                              content: Center(
                                child: Text(
                                  buyNowProvider.errorMessage!,
                                  style: TextStyle(
                                    fontSize: SizeConfig.blockHeight * 1.6,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }

                        if (!buyNowProvider.isOrderSuccessful) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 2),
                              content: Center(
                                child: Text(
                                  'Failed to create order',
                                  style: TextStyle(
                                    fontSize: SizeConfig.blockHeight * 1.6,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }

                        final orderId = buyNowProvider.orderId;
                        final merchantKey = buyNowProvider.merchantKey;

                        if (orderId == null || merchantKey == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 2),
                              content: Center(
                                child: Text(
                                  'Order data missing',
                                  style: TextStyle(
                                    fontSize: SizeConfig.blockHeight * 1.6,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Placeorder(
                              amount: (double.tryParse(product.price) ?? 0.0)
                                  .toDouble(),
                              userName: userName,
                              userEmail: userEmail,
                              userPhone: userPhone,
                              userId: userId,
                              orderid: orderId,
                              merchantKey: merchantKey,
                            ),
                          ),
                        );
                      } catch (e) {
                        if (!context.mounted) return;

                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 2),
                            content: Center(
                              child: Text(
                                'Error: ${e.toString()}',
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Buy Now",
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontSize: SizeConfig.blockHeight * 1.8,
                        fontWeight: FontWeight.w600,
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
  }
}
