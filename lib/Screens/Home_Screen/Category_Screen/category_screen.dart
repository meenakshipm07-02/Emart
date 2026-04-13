// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:grocery_app/Common_Widgets/Catogorielist_card/catogorie_card.dart';
// import 'package:grocery_app/Common_Widgets/Circular_progressindicator/progress_indicator.dart';
// import 'package:grocery_app/Common_Widgets/Common_search/common_search.dart';
// import 'package:grocery_app/Common_Widgets/Rich_text/rich_text.dart';
// import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
// import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';
// import 'package:grocery_app/Providers/catogorieslist_provider.dart';
// import 'package:grocery_app/Providers/products_provider.dart';
// import 'package:grocery_app/Screens/Home_Screen/Products_Screen/productslist_screen.dart';
// import 'package:provider/provider.dart';

// class CategoriesScreen extends StatefulWidget {
//   const CategoriesScreen({super.key});

//   @override
//   State<CategoriesScreen> createState() => _CategoriesScreenState();
// }

// class _CategoriesScreenState extends State<CategoriesScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final categoryProvider = Provider.of<CategoryProvider>(context);

//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         toolbarHeight: SizeConfig.blockHeight * 8,
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: Text(
//           "Categories",
//           style: GoogleFonts.poppins(
//             color: AppColors.secondary,
//             fontSize: SizeConfig.blockHeight * 1.9,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: SizeConfig.blockWidth * 3,
//               vertical: SizeConfig.blockHeight * 2,
//             ),
//             child: CommonSearchBar(
//               controller: _searchController,
//               hintText: "Search Categories...",
//               onChanged: (value) {
//                 categoryProvider.filterCategories(value);
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: SizeConfig.blockWidth * 3,
//               vertical: SizeConfig.blockHeight * 2,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     vertical: SizeConfig.blockHeight * 0.5,
//                   ),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: CommonRichText(
//                     fontSize: SizeConfig.blockHeight * 2.2,
//                     firstText: 'Shop By Category',
//                     secondText: '...',
//                     firstColor: Colors.black,
//                     secondColor: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: SizeConfig.blockHeight * 57, // Fixed height
//             padding: EdgeInsets.symmetric(
//               horizontal: SizeConfig.blockWidth * 3,
//             ),
//             child: categoryProvider.isLoading
//                 ? const Center(child: CustomLoader(color: AppColors.success))
//                 : categoryProvider.errorMessage != null
//                 ? Center(child: Text(categoryProvider.errorMessage!))
//                 : categoryProvider.categories.isEmpty
//                 ? const Center(child: Text('No categories found.'))
//                 : GridView.builder(
//                     padding: const EdgeInsets.only(top: 9),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                       crossAxisSpacing: 12,
//                       mainAxisSpacing: 12,
//                       childAspectRatio: 0.8,
//                       mainAxisExtent: SizeConfig.blockHeight * 17.2,
//                     ),
//                     itemCount: categoryProvider.categories.length,
//                     itemBuilder: (context, index) {
//                       final category = categoryProvider.categories[index];
//                       return ItemCard(
//                         title: category.name,
//                         imageUrl: category.image,
//                         onTap: () {
//                           Provider.of<ProductlistProvider>(
//                             context,
//                             listen: false,
//                           ).fetchProductsByCategory(category.id);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => ProductListScreen(
//                                 categoryName: category.name,
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Catogorielist_card/products_card.dart';
import 'package:grocery_app/Common_Widgets/Circular_progressindicator/progress_indicator.dart';
import 'package:grocery_app/Common_Widgets/Common_search/common_search.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';
import 'package:grocery_app/Datastore/shared_pref.dart';
import 'package:grocery_app/Providers/Buynow_provider/buynow_provider.dart';
import 'package:grocery_app/Providers/catogorieslist_provider.dart';
import 'package:grocery_app/Providers/products_provider.dart';
import 'package:grocery_app/Providers/Cart_providers/addto_cart.dart';
import 'package:grocery_app/Providers/Favourite_providers/addto_fav.dart';
import 'package:grocery_app/Providers/product_detail_provider.dart';
import 'package:grocery_app/Providers/Favourite_providers/remove_fav.dart';
import 'package:grocery_app/Screens/Home_Screen/Cart_Screen/placeorder.dart';
import 'package:grocery_app/Screens/Home_Screen/Products_Screen/product_detail_screen.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;
  String? _selectedCategoryId;
  bool _isInitialLoading = true;
  bool _isProductsLoading = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;

    setState(() {
      _isInitialLoading = true;
    });

    try {
      final categoryProvider = context.read<CategoryProvider>();

      await categoryProvider.fetchCategories();

      if (categoryProvider.categories.isNotEmpty && mounted) {
        setState(() {
          _selectedCategoryId = categoryProvider.categories.first.id;
        });

        // Load products for first category
        await context.read<ProductlistProvider>().fetchProductsByCategory(
          _selectedCategoryId!,
        );
      }
    } catch (e) {
      print('Error loading initial data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    final categoryProvider = context.read<CategoryProvider>();
    final productProvider = context.read<ProductlistProvider>();

    try {
      // Refresh both categories and products
      await categoryProvider.fetchCategories();

      if (_selectedCategoryId != null) {
        await productProvider.fetchProductsByCategory(_selectedCategoryId!);
      } else if (categoryProvider.categories.isNotEmpty) {
        final firstCategoryId = categoryProvider.categories.first.id;
        setState(() {
          _selectedCategoryId = firstCategoryId;
        });
        await productProvider.fetchProductsByCategory(firstCategoryId);
      }
    } catch (e) {
      print('Error refreshing data: $e');
    }
  }

  void _selectCategory(int index, String categoryId) async {
    setState(() {
      _selectedCategoryIndex = index;
      _selectedCategoryId = categoryId;
      _isProductsLoading = true; // Show loading for products
    });

    try {
      // Load products for selected category
      await context.read<ProductlistProvider>().fetchProductsByCategory(
        categoryId,
      );
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProductsLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildCategoriesList(CategoryProvider categoryProvider) {
    return Container(
      width: SizeConfig.blockWidth * 30,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey[300]!, width: 1),
          bottom: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: SizeConfig.blockHeight * 5,
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockWidth * 2,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ), // Added bottom border
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Categories',
                style: GoogleFonts.poppins(
                  color: AppColors.black,
                  fontSize: SizeConfig.blockHeight * 1.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          Expanded(
            child: categoryProvider.isLoading && _isInitialLoading
                ? const Center(child: CustomLoader(color: AppColors.success))
                : categoryProvider.errorMessage != null
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.blockWidth * 3),
                      child: Text(
                        categoryProvider.errorMessage!,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: categoryProvider.categories.length,
                    itemExtent: SizeConfig.blockHeight * 12,
                    itemBuilder: (context, index) {
                      final category = categoryProvider.categories[index];
                      final isSelected = _selectedCategoryIndex == index;

                      return GestureDetector(
                        onTap: () => _selectCategory(index, category.id),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockWidth * 2,
                            vertical: SizeConfig.blockHeight * 1,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.subtitle.withOpacity(0.2)
                                : Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[200]!,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Category Image (Small Square)
                              Container(
                                width: SizeConfig.blockWidth * 13,
                                height: SizeConfig.blockWidth * 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[100],
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: category.image.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          category.image,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.category,
                                                  size:
                                                      SizeConfig.blockHeight *
                                                      2.5,
                                                  color: Colors.grey[400],
                                                );
                                              },
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.success,
                                                strokeWidth: 2,
                                                value:
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Icon(
                                        Icons.category,
                                        size: SizeConfig.blockHeight * 2.5,
                                        color: Colors.grey[400],
                                      ),
                              ),

                              SizedBox(height: SizeConfig.blockHeight * 1),

                              // Category Name (Centered below image)
                              Text(
                                category.name,
                                style: GoogleFonts.poppins(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.black87,
                                  fontSize: SizeConfig.blockHeight * 1.2,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid() {
    final productProvider = context.watch<ProductlistProvider>();

    return Expanded(
      child: Column(
        children: [
          // Products Header with bottom border
          Container(
            height: SizeConfig.blockHeight * 5,
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockWidth * 3,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Products',
                  style: GoogleFonts.poppins(
                    color: AppColors.black,
                    fontSize: SizeConfig.blockHeight * 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar Below Header with bottom border
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockWidth * 3,
              vertical: SizeConfig.blockHeight * 1.5,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            child: CommonSearchBar(
              controller: _searchController,
              hintText: "Search products...",
              onChanged: productProvider.filterProducts,
            ),
          ),

          // Products Grid
          Expanded(
            child: _isInitialLoading
                ? const Center(child: CustomLoader(color: AppColors.success))
                : _isProductsLoading
                ? const Center(child: CustomLoader(color: AppColors.primary))
                : productProvider.errorMessage != null
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.blockWidth * 3),
                      child: Text(
                        productProvider.errorMessage!,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : productProvider.products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: SizeConfig.blockHeight * 8,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: SizeConfig.blockHeight * 2),
                        Text(
                          'No products found',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: SizeConfig.blockHeight * 1.8,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(SizeConfig.blockWidth * 3),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: SizeConfig.blockWidth * 2,
                      mainAxisSpacing: SizeConfig.blockHeight * 1,
                      childAspectRatio: 0.8,
                      mainAxisExtent: SizeConfig.blockHeight * 21,
                    ),
                    itemCount: productProvider.products.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.products[index];
                      return ProductCard(
                        name: product.name,
                        imageUrl: product.image,
                        price: product.price,
                        onBuyNow: () async {
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
                                await SharedPrefs.getUserPhone() ??
                                '9876543210';
                            final userId =
                                await SharedPrefs.getUserId() ?? 'default_user';

                            final buyNowProvider = context
                                .read<BuyNowProvider>();

                            await buyNowProvider.buyNow(
                              product.id.toString(),
                              1,
                            );

                            if (!context.mounted) return;

                            Navigator.of(context).pop();

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
                                  amount: (product.price.toDouble()),
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
                        onAdd: () async {
                          final cartProvider = context
                              .read<AddToCartProvider>();

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(child: CustomLoader()),
                          );

                          try {
                            final message = await cartProvider.addToCart(
                              product.id.toString(),
                              1,
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
                        initiallyFavourite: product.isFavourite,
                        onFavorite: (isSelected) async {
                          final favProvider = context
                              .read<AddFavouriteProvider>();
                          final removeFavProvider = context
                              .read<RemoveFavouriteProvider>();

                          String message = '';

                          try {
                            if (isSelected) {
                              await favProvider.addFavourite(product.id);
                              message = favProvider.isError
                                  ? '${favProvider.message}'
                                  : (favProvider.message ??
                                        'Added to favourites');
                            } else {
                              await removeFavProvider.removeFavourite(
                                product.id,
                              );
                              message = removeFavProvider.isError
                                  ? '${removeFavProvider.message}'
                                  : (removeFavProvider.message ??
                                        'Removed from favourites');
                            }

                            if (!context.mounted) return;

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
                                backgroundColor: AppColors.error,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(
                                  child: Text(
                                    'Something went wrong',
                                    style: TextStyle(
                                      fontSize: SizeConfig.blockHeight * 1.6,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                backgroundColor: AppColors.error,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        onTap: () async {
                          final detailProvider = context
                              .read<ProductDetailProvider>();

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(
                              child: CustomLoader(color: AppColors.success),
                            ),
                          );

                          try {
                            await detailProvider.fetchProductDetail(
                              product.id.toString(),
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        toolbarHeight: SizeConfig.blockHeight * 8,
        backgroundColor: Colors.grey[50],
        centerTitle: true,
        title: Text(
          "All Categories",
          style: GoogleFonts.poppins(
            color: AppColors.secondary,
            fontSize: SizeConfig.blockHeight * 1.9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isInitialLoading
          ? const Center(child: CustomLoader(color: AppColors.success))
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refreshData,
              color: AppColors.success,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoriesList(categoryProvider),

                  _buildProductsGrid(),
                ],
              ),
            ),
    );
  }
}
