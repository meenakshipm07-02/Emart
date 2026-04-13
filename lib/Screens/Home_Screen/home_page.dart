import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Carousal_screen/carousal.dart';
import 'package:grocery_app/Common_Widgets/Catogorielist_card/recentproducts_card.dart';
import 'package:grocery_app/Common_Widgets/Circular_progressindicator/progress_indicator.dart';
import 'package:grocery_app/Common_Widgets/Common_search/common_search.dart';
import 'package:grocery_app/Common_Widgets/Custom_drawer/drawer.dart';
import 'package:grocery_app/Common_Widgets/Rich_text/rich_text.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';
import 'package:grocery_app/Datastore/shared_pref.dart';
import 'package:grocery_app/Providers/Buynow_provider/buynow_provider.dart';
import 'package:grocery_app/Providers/Cart_providers/addto_cart.dart';
import 'package:grocery_app/Providers/Favourite_providers/addto_fav.dart';
import 'package:grocery_app/Providers/allproducts_provider.dart';
import 'package:grocery_app/Providers/catogorieslist_provider.dart';
import 'package:grocery_app/Providers/location_provider.dart';
import 'package:grocery_app/Providers/product_detail_provider.dart';
import 'package:grocery_app/Providers/recentproducts_provider.dart';
import 'package:grocery_app/Providers/Favourite_providers/remove_fav.dart';
import 'package:grocery_app/Screens/Home_Screen/Cart_Screen/placeorder.dart';
import 'package:grocery_app/Screens/Home_Screen/Products_Screen/product_detail_screen.dart';

import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _productsearchController =
      TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllData();
    });
  }

  @override
  void dispose() {
    _productsearchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );
    final recentProvider = Provider.of<RecentProductsProvider>(
      context,
      listen: false,
    );
    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );
    final productProvider = Provider.of<AllproductsProvider>(
      context,
      listen: false,
    );

    await Future.wait([
      categoryProvider.fetchCategories(),
      recentProvider.fetchRecentProducts(),
      locationProvider.fetchLocation(),
      productProvider.fetchAllProducts(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final recentProvider = Provider.of<RecentProductsProvider>(context);
    final productProvider = Provider.of<AllproductsProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      drawer: const CustomDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(SizeConfig.blockHeight * 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.18),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockWidth * 4.5,
                vertical: SizeConfig.blockHeight * .30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) => GestureDetector(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color.fromARGB(255, 14, 98, 17),
                              ),
                              color: Colors.white,
                            ),
                            child: Image.asset(
                              'assets/Icons/menu.png',
                              width: SizeConfig.blockWidth * 5.5,
                              height: SizeConfig.blockHeight * 5.1,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.black,
                            size: SizeConfig.blockHeight * 2.5,
                          ),
                          SizedBox(width: SizeConfig.blockWidth * 2),
                          Consumer<LocationProvider>(
                            builder: (context, locationProvider, child) {
                              return Text(
                                locationProvider.location,
                                style: GoogleFonts.poppins(
                                  fontSize: SizeConfig.blockHeight * 1.8,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromARGB(255, 14, 98, 17),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color.fromARGB(255, 14, 98, 17),
                            ),
                            color: Colors.white,
                          ),
                          child: Image.asset(
                            'assets/Icons/notify.png',
                            width: SizeConfig.blockWidth * 5.5,
                            height: SizeConfig.blockHeight * 5.1,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 0.7),
                  CommonSearchBar(
                    controller: _productsearchController,
                    hintText: "Search products....",
                    onChanged: (value) {
                      final productProvider = Provider.of<AllproductsProvider>(
                        context,
                        listen: false,
                      );
                      productProvider.searchProducts(value);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadAllData,
        color: AppColors.success,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(10, 16, 10, 20),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockWidth * 2,
                      vertical: SizeConfig.blockHeight * 0.2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CommonRichText(
                      fontSize: SizeConfig.blockHeight * 2.5,
                      firstText: 'Delivery within ',
                      secondText: '1 Hr',
                      firstColor: Colors.black,
                      secondColor: Colors.red,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 1),
                  PromoCarouselPage(),
                  SizedBox(height: SizeConfig.blockHeight * 1.5),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockWidth * 2,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.blockHeight * 0.3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CommonRichText(
                        fontSize: SizeConfig.blockHeight * 2.1,
                        firstText: 'All  Products',
                        secondText: '...',
                        firstColor: Colors.black,
                        secondColor: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 0.5),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: SizeConfig.blockHeight * 0.5),
                      if (productProvider.isLoading)
                        const Center(
                          child: CustomLoader(color: AppColors.success),
                        )
                      else if (productProvider.hasError)
                        Center(
                          child: Text(
                            productProvider.errorMessage,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: SizeConfig.blockHeight * 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      else if (productProvider.products.isEmpty)
                        Center(
                          child: Text(
                            "No products found.",
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: SizeConfig.blockHeight * 21.5,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: productProvider.products.length,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.68,
                                  mainAxisExtent: SizeConfig.blockHeight * 19.5,
                                ),
                            itemBuilder: (context, index) {
                              final product = productProvider.products[index];
                              return RecentproductsCard(
                                onBuyNow: () async {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) =>
                                        const Center(child: CustomLoader()),
                                  );

                                  try {
                                    // 1. GET USER DATA FROM SHAREDPREFERENCES FIRST
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

                                    // 2. Call BuyNow API
                                    final buyNowProvider =
                                        Provider.of<BuyNowProvider>(
                                          context,
                                          listen: false,
                                        );

                                    await buyNowProvider.buyNow(product.id, 1);

                                    if (!context.mounted) return;

                                    // Close the loader
                                    Navigator.of(context).pop();

                                    // 3. Check if BuyNow was successful
                                    if (buyNowProvider.hasError) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          duration: const Duration(seconds: 2),
                                          content: Center(
                                            child: Text(
                                              buyNowProvider.errorMessage!,
                                              style: TextStyle(
                                                fontSize:
                                                    SizeConfig.blockHeight *
                                                    1.6,
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
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          duration: const Duration(seconds: 2),
                                          content: Center(
                                            child: Text(
                                              'Failed to create order',
                                              style: TextStyle(
                                                fontSize:
                                                    SizeConfig.blockHeight *
                                                    1.6,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          backgroundColor: AppColors.error,
                                        ),
                                      );
                                      return;
                                    }

                                    // 4. Get data from BuyNow response
                                    final orderId = buyNowProvider.orderId;
                                    final merchantKey =
                                        buyNowProvider.merchantKey;

                                    if (orderId == null ||
                                        merchantKey == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          duration: const Duration(seconds: 2),
                                          content: Center(
                                            child: Text(
                                              'Order data missing',
                                              style: TextStyle(
                                                fontSize:
                                                    SizeConfig.blockHeight *
                                                    1.6,
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
                                          amount:
                                              (double.tryParse(
                                                product.newPrice,
                                              ) ??
                                              0),
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
                                },

                                name: product.name,
                                imageUrl: product.image,
                                price: double.tryParse(product.newPrice) ?? 0,
                                initiallyFavourite: false,
                                onAdd: () async {
                                  final cartProvider =
                                      Provider.of<AddToCartProvider>(
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
                                    final message = await cartProvider
                                        .addToCart(product.id, 1);

                                    if (!context.mounted) return;
                                    Navigator.of(context).pop();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Center(
                                          child: Text(
                                            message,
                                            style: TextStyle(
                                              fontSize:
                                                  SizeConfig.blockHeight * 1.6,
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
                                      child: CustomLoader(
                                        color: AppColors.success,
                                      ),
                                    ),
                                  );

                                  try {
                                    await detailProvider.fetchProductDetail(
                                      product.id,
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
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Center(
                                            child: Text(
                                              'Product details not found',
                                              style: TextStyle(
                                                fontSize:
                                                    SizeConfig.blockHeight *
                                                    1.6,
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
                                            '$e',
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
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 1.2),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockWidth * 2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockHeight * 0.3,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CommonRichText(
                                  fontSize: SizeConfig.blockHeight * 2.1,
                                  firstText: 'Recently  Added',
                                  secondText: '...',
                                  firstColor: Colors.black,
                                  secondColor: Colors.black,
                                ),
                              ),
                              SizedBox(height: SizeConfig.blockHeight * 1.3),
                              if (recentProvider.isLoading)
                                const Center(
                                  child: CustomLoader(color: AppColors.success),
                                )
                              else if (recentProvider.errorMessage != null)
                                Center(
                                  child: Text(
                                    recentProvider.errorMessage!,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: SizeConfig.blockHeight * 1.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              else if (recentProvider.recentProducts.isEmpty)
                                Center(
                                  child: Text(
                                    "No recent products found.",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              else
                                SizedBox(
                                  height: SizeConfig.blockHeight * 21.5,
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount:
                                        recentProvider.recentProducts.length,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 5,
                                    ),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                          childAspectRatio: 0.68,
                                          mainAxisExtent:
                                              SizeConfig.blockHeight * 19.5,
                                        ),
                                    itemBuilder: (context, index) {
                                      final product =
                                          recentProvider.recentProducts[index];
                                      return RecentproductsCard(
                                        onBuyNow: () async {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (_) => const Center(
                                              child: CustomLoader(),
                                            ),
                                          );

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

                                            final buyNowProvider =
                                                Provider.of<BuyNowProvider>(
                                                  context,
                                                  listen: false,
                                                );

                                            await buyNowProvider.buyNow(
                                              product.productId.toString(),
                                              1,
                                            );

                                            if (!context.mounted) return;

                                            Navigator.of(context).pop();

                                            if (buyNowProvider.hasError) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  duration: const Duration(
                                                    seconds: 2,
                                                  ),
                                                  content: Center(
                                                    child: Text(
                                                      buyNowProvider
                                                          .errorMessage!,
                                                      style: TextStyle(
                                                        fontSize:
                                                            SizeConfig
                                                                .blockHeight *
                                                            1.6,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      AppColors.error,
                                                ),
                                              );
                                              return;
                                            }

                                            if (!buyNowProvider
                                                .isOrderSuccessful) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  duration: const Duration(
                                                    seconds: 2,
                                                  ),
                                                  content: Center(
                                                    child: Text(
                                                      'Failed to create order',
                                                      style: TextStyle(
                                                        fontSize:
                                                            SizeConfig
                                                                .blockHeight *
                                                            1.6,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      AppColors.error,
                                                ),
                                              );
                                              return;
                                            }

                                            final orderId =
                                                buyNowProvider.orderId;
                                            final merchantKey =
                                                buyNowProvider.merchantKey;

                                            if (orderId == null ||
                                                merchantKey == null) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  duration: const Duration(
                                                    seconds: 2,
                                                  ),
                                                  content: Center(
                                                    child: Text(
                                                      'Order data missing',
                                                      style: TextStyle(
                                                        fontSize:
                                                            SizeConfig
                                                                .blockHeight *
                                                            1.6,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      AppColors.error,
                                                ),
                                              );
                                              return;
                                            }

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => Placeorder(
                                                  amount: product.price
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

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                duration: const Duration(
                                                  seconds: 2,
                                                ),
                                                content: Center(
                                                  child: Text(
                                                    'Error: ${e.toString()}',
                                                    style: TextStyle(
                                                      fontSize:
                                                          SizeConfig
                                                              .blockHeight *
                                                          1.6,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    AppColors.error,
                                              ),
                                            );
                                          }
                                        },

                                        name: product.name,
                                        imageUrl: product.image,
                                        price: product.price.toDouble(),
                                        initiallyFavourite: product.isFavourite,
                                        onFavorite: (isSelected) async {
                                          final favProvider =
                                              Provider.of<AddFavouriteProvider>(
                                                context,
                                                listen: false,
                                              );
                                          final removeFavProvider =
                                              Provider.of<
                                                RemoveFavouriteProvider
                                              >(context, listen: false);

                                          String message = '';
                                          try {
                                            if (isSelected) {
                                              await favProvider.addFavourite(
                                                product.productId,
                                              );
                                              message = favProvider.isError
                                                  ? 'Error: ${favProvider.message}'
                                                  : (favProvider.message ??
                                                        'Added to favourites');
                                            } else {
                                              await removeFavProvider
                                                  .removeFavourite(
                                                    product.productId,
                                                  );
                                              message =
                                                  removeFavProvider.isError
                                                  ? 'Error: ${removeFavProvider.message}'
                                                  : (removeFavProvider
                                                            .message ??
                                                        'Removed from favourites');
                                            }
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(message),
                                                backgroundColor: isSelected
                                                    ? Colors.green
                                                    : Colors.red,
                                                duration: const Duration(
                                                  seconds: 1,
                                                ),
                                              ),
                                            );
                                          } catch (e) {
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Center(
                                                  child: Text(
                                                    'Something went wrong',
                                                    style: TextStyle(
                                                      fontSize:
                                                          SizeConfig
                                                              .blockHeight *
                                                          1.6,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    AppColors.error,
                                                duration: Duration(seconds: 1),
                                              ),
                                            );
                                          }
                                        },
                                        onAdd: () async {
                                          final cartProvider =
                                              Provider.of<AddToCartProvider>(
                                                context,
                                                listen: false,
                                              );

                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (_) => const Center(
                                              child: CustomLoader(),
                                            ),
                                          );

                                          try {
                                            final message = await cartProvider
                                                .addToCart(
                                                  product.productId.toString(),
                                                  1,
                                                );

                                            if (!context.mounted) return;
                                            Navigator.of(context).pop();

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                duration: Duration(seconds: 1),
                                                content: Center(
                                                  child: Text(
                                                    message,
                                                    style: TextStyle(
                                                      fontSize:
                                                          SizeConfig
                                                              .blockHeight *
                                                          1.6,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    AppColors.primary,
                                              ),
                                            );
                                          } catch (e) {
                                            if (!context.mounted) return;
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                duration: Duration(seconds: 1),
                                                content: Center(
                                                  child: Text(
                                                    '$e',
                                                    style: TextStyle(
                                                      fontSize:
                                                          SizeConfig
                                                              .blockHeight *
                                                          1.6,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    AppColors.error,
                                              ),
                                            );
                                          }
                                        },
                                        onTap: () async {
                                          final detailProvider =
                                              Provider.of<
                                                ProductDetailProvider
                                              >(context, listen: false);

                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (_) => const Center(
                                              child: CustomLoader(
                                                color: AppColors.success,
                                              ),
                                            ),
                                          );

                                          try {
                                            await detailProvider
                                                .fetchProductDetail(
                                                  product.productId.toString(),
                                                );

                                            if (!context.mounted) return;

                                            Navigator.of(context).pop();

                                            if (detailProvider.product !=
                                                null) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      ProductDetailScreen(
                                                        product: detailProvider
                                                            .product!,
                                                      ),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Center(
                                                    child: Text(
                                                      'Product details not found',
                                                      style: TextStyle(
                                                        fontSize:
                                                            SizeConfig
                                                                .blockHeight *
                                                            1.6,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      AppColors.error,
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            if (!context.mounted) return;
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Center(
                                                  child: Text(
                                                    '$e',
                                                    style: TextStyle(
                                                      fontSize:
                                                          SizeConfig
                                                              .blockHeight *
                                                          1.6,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    AppColors.error,
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
