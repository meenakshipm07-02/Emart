// import 'package:flutter/material.dart';
// import 'package:grocery_app/Common_Widgets/Catogorielist_card/products_card.dart';
// import 'package:grocery_app/Common_Widgets/Circular_progressindicator/progress_indicator.dart';
// import 'package:grocery_app/Common_Widgets/Common_search/common_search.dart';
// import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
// import 'package:grocery_app/Providers/Cart_providers/addto_cart.dart';
// import 'package:grocery_app/Providers/Favourite_providers/addto_fav.dart';
// import 'package:grocery_app/Providers/product_detail_provider.dart';
// import 'package:grocery_app/Providers/products_provider.dart';
// import 'package:grocery_app/Providers/Favourite_providers/remove_fav.dart';
// import 'package:grocery_app/Screens/Home_Screen/Products_Screen/product_detail_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ProductListScreen extends StatefulWidget {
//   final String categoryName;

//   const ProductListScreen({Key? key, required this.categoryName})
//     : super(key: key);

//   @override
//   State<ProductListScreen> createState() => _ProductListScreenState();
// }

// class _ProductListScreenState extends State<ProductListScreen> {
//   final search_controller = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<ProductlistProvider>(context);

//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: AppBar(
//         toolbarHeight: SizeConfig.blockHeight * 8,
//         backgroundColor: Colors.white,
//         elevation: 0.5,
//         centerTitle: true,
//         title: Text(
//           widget.categoryName,
//           style: GoogleFonts.poppins(
//             color: AppColors.primary,
//             fontSize: SizeConfig.blockHeight * 2.2,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         leading: Padding(
//           padding: EdgeInsets.all(8),

//           child: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(
//               Icons.arrow_back_ios_new,
//               size: SizeConfig.blockHeight * 2.2,
//               color: AppColors.black,
//             ),
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: SizeConfig.blockWidth * 3,
//             vertical: SizeConfig.blockHeight * 1.5,
//           ),
//           child: Column(
//             children: [
//               CommonSearchBar(
//                 controller: search_controller,
//                 hintText: "Search ${widget.categoryName} ...",
//                 onChanged: provider.filterProducts,
//               ),
//               SizedBox(height: SizeConfig.blockHeight * 2),
//               Expanded(
//                 child: provider.isLoading
//                     ? const Center(
//                         child: CustomLoader(color: AppColors.success),
//                       )
//                     : provider.errorMessage != null
//                     ? Center(child: Text(provider.errorMessage!))
//                     : provider.products.isEmpty
//                     ? const Center(child: Text("No products found"))
//                     : GridView.builder(
//                         padding: const EdgeInsets.only(top: 9),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                           crossAxisSpacing: 10,
//                           mainAxisSpacing: 15,
//                           childAspectRatio: 0.8,
//                           mainAxisExtent: SizeConfig.blockHeight * 24.5,
//                         ),
//                         itemCount: provider.products.length,
//                         itemBuilder: (context, index) {
//                           final product = provider.products[index];
//                           return ProductCard(
//                             name: product.name,
//                             imageUrl: product.image,
//                             price: product.price,
//                             onAdd: () async {
//                               final cartProvider =
//                                   Provider.of<AddToCartProvider>(
//                                     context,
//                                     listen: false,
//                                   );

//                               showDialog(
//                                 context: context,
//                                 barrierDismissible: false,
//                                 builder: (_) =>
//                                     const Center(child: CustomLoader()),
//                               );

//                               try {
//                                 final message = await cartProvider.addToCart(
//                                   product.id.toString(),
//                                   1,
//                                 );

//                                 if (!context.mounted) return;
//                                 Navigator.of(context).pop();

//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Center(
//                                       child: Text(
//                                         message,
//                                         style: TextStyle(
//                                           fontSize:
//                                               SizeConfig.blockHeight * 1.6,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                     backgroundColor: AppColors.primary,
//                                   ),
//                                 );
//                               } catch (e) {
//                                 if (!context.mounted) return;
//                                 Navigator.of(context).pop();

//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Center(
//                                       child: Text(
//                                         e.toString(),
//                                         style: TextStyle(
//                                           fontSize:
//                                               SizeConfig.blockHeight * 1.6,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                     backgroundColor: AppColors.error,
//                                   ),
//                                 );
//                               }
//                             },

//                             initiallyFavourite: product.isFavourite,
//                             onFavorite: (isSelected) async {
//                               final favProvider =
//                                   Provider.of<AddFavouriteProvider>(
//                                     context,
//                                     listen: false,
//                                   );
//                               final removeFavProvider =
//                                   Provider.of<RemoveFavouriteProvider>(
//                                     context,
//                                     listen: false,
//                                   );

//                               String message = '';

//                               try {
//                                 if (isSelected) {
//                                   await favProvider.addFavourite(product.id);
//                                   message = favProvider.isError
//                                       ? '${favProvider.message}'
//                                       : (favProvider.message ??
//                                             'Added to favourites');
//                                 } else {
//                                   await removeFavProvider.removeFavourite(
//                                     product.id,
//                                   );
//                                   message = removeFavProvider.isError
//                                       ? '${removeFavProvider.message}'
//                                       : (removeFavProvider.message ??
//                                             'Removed from favourites');
//                                 }

//                                 if (!context.mounted) return;

//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Center(
//                                       child: Text(
//                                         message,
//                                         style: TextStyle(
//                                           fontSize:
//                                               SizeConfig.blockHeight * 1.6,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                     backgroundColor: AppColors.error,

//                                     duration: const Duration(seconds: 1),
//                                   ),
//                                 );
//                               } catch (e) {
//                                 if (!context.mounted) return;
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Center(
//                                       child: Text(
//                                         'Something went wrong',
//                                         style: TextStyle(
//                                           fontSize:
//                                               SizeConfig.blockHeight * 1.6,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                     backgroundColor: AppColors.error,
//                                     duration: const Duration(seconds: 1),
//                                   ),
//                                 );
//                               }
//                             },

//                             onTap: () async {
//                               final detailProvider =
//                                   Provider.of<ProductDetailProvider>(
//                                     context,
//                                     listen: false,
//                                   );

//                               showDialog(
//                                 context: context,
//                                 barrierDismissible: false,
//                                 builder: (_) => const Center(
//                                   child: CustomLoader(color: AppColors.success),
//                                 ),
//                               );

//                               try {
//                                 await detailProvider.fetchProductDetail(
//                                   product.id.toString(),
//                                 );

//                                 if (!context.mounted) return;

//                                 Navigator.of(context).pop();

//                                 if (detailProvider.product != null) {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => ProductDetailScreen(
//                                         product: detailProvider.product!,
//                                       ),
//                                     ),
//                                   );
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Center(
//                                         child: Text(
//                                           'Product details not found',
//                                           style: TextStyle(
//                                             fontSize:
//                                                 SizeConfig.blockHeight * 1.6,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ),
//                                       backgroundColor: AppColors.error,
//                                     ),
//                                   );
//                                 }
//                               } catch (e) {
//                                 if (!context.mounted) return;
//                                 Navigator.of(context).pop();
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Center(
//                                       child: Text(
//                                         'Error: $e',
//                                         style: TextStyle(
//                                           fontSize:
//                                               SizeConfig.blockHeight * 1.6,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                     backgroundColor: AppColors.error,
//                                   ),
//                                 );
//                               }
//                             },
//                           );
//                         },
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
