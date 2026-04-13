import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Circular_progressindicator/progress_indicator.dart';
import 'package:grocery_app/Common_Widgets/Favourite_Card/favouritescreen_card.dart';
import 'package:grocery_app/Providers/Cart_providers/addto_cart.dart';
import 'package:grocery_app/Providers/Favourite_providers/favouritelist_provider.dart';
import 'package:grocery_app/Providers/product_detail_provider.dart';
import 'package:grocery_app/Providers/Favourite_providers/remove_fav.dart';
import 'package:grocery_app/Screens/Home_Screen/Products_Screen/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavouriteListProvider>(
        context,
        listen: false,
      ).fetchFavourites();
    });
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        toolbarHeight: SizeConfig.blockHeight * 8,
        backgroundColor: Colors.white,

        centerTitle: true,
        title: Text(
          "Favourites",
          style: GoogleFonts.poppins(
            color: AppColors.secondary,
            fontSize: SizeConfig.blockHeight * 1.9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Consumer<FavouriteListProvider>(
        builder: (context, favlist, child) {
          if (favlist.isLoading) {
            return const Center(child: CustomLoader(color: AppColors.success));
          }

          if (favlist.errorMessage != null) {
            return Center(
              child: Text(
                favlist.errorMessage!,
                style: TextStyle(
                  fontSize: SizeConfig.blockHeight * 1.6,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (favlist.favourites.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockWidth * 4.5,
                vertical: SizeConfig.blockHeight * 0.3,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/Loading_images/no_fav.png",
                    height: SizeConfig.blockHeight * 20,
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 1),
                  Text(
                    "No Favourites Here",
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
                      "Fill up your fav with your liked products. Start shopping now!",
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
                height: SizeConfig.blockHeight * 42,
                child: Stack(
                  children: [
                    GridView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: favlist.favourites.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 0,
                        childAspectRatio: 0.8,
                        mainAxisExtent: SizeConfig.blockHeight * 12.5,
                      ),
                      itemBuilder: (context, index) {
                        final product = favlist.favourites[index];
                        return FavouriteCard(
                          weight: product.weight ?? 'N/A',
                          name: product.name,
                          imageUrl: product.image,
                          price: product.price,
                          initiallyFavourite: product.isFavourite,
                          onAddToCart: () async {
                            final cartProvider = Provider.of<AddToCartProvider>(
                              context,
                              listen: false,
                            );

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) =>
                                  const Center(child: CustomLoader()),
                            );

                            try {
                              final message = await cartProvider.addToCart(
                                product.productId.toString(),
                                1,
                              );
                              if (!context.mounted) return;
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 1),
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
                                  duration: Duration(seconds: 1),
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
                          },
                          onRemoveFavourite: () async {
                            final removeFavProvider =
                                Provider.of<RemoveFavouriteProvider>(
                                  context,
                                  listen: false,
                                );
                            final favListProvider =
                                Provider.of<FavouriteListProvider>(
                                  context,
                                  listen: false,
                                );

                            await removeFavProvider.removeFavourite(
                              product.productId,
                            );
                            await favListProvider.fetchFavourites();
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
                                product.productId.toString(),
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
                                          fontSize:
                                              SizeConfig.blockHeight * 1.6,
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
                        );
                      },
                    ),

                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey.shade500,
                          size: SizeConfig.blockHeight * 3.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
