import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/Providers/Address_providers/add_addressprovider.dart';
import 'package:grocery_app/Providers/Address_providers/remove_addressprovider.dart';
import 'package:grocery_app/Providers/Address_providers/view_addressprovider.dart';
import 'package:grocery_app/Providers/Buynow_provider/buynow_provider.dart';
import 'package:grocery_app/Providers/Forgot_Passproviders/recover_password.dart';
import 'package:grocery_app/Providers/Forgot_Passproviders/verify%20_password.dart';
import 'package:grocery_app/Providers/Placeorder_providers/placeorde_provider.dart';
import 'package:grocery_app/Providers/Profile_providers/editprofile_provider.dart';
import 'package:grocery_app/Providers/Profile_providers/profile_provider.dart';
import 'package:grocery_app/Providers/Cart_providers/addto_cart.dart';
import 'package:grocery_app/Providers/Favourite_providers/addto_fav.dart';
import 'package:grocery_app/Providers/Razorpay_keyproviders/razorpay_keyprovider.dart';
import 'package:grocery_app/Providers/allproducts_provider.dart';
import 'package:grocery_app/Providers/catogorieslist_provider.dart';
import 'package:grocery_app/Providers/createacc_provider.dart';
import 'package:grocery_app/Providers/Favourite_providers/favouritelist_provider.dart';
import 'package:grocery_app/Providers/location_provider.dart';
import 'package:grocery_app/Providers/product_detail_provider.dart';
import 'package:grocery_app/Providers/products_provider.dart';
import 'package:grocery_app/Providers/recentproducts_provider.dart';
import 'package:grocery_app/Providers/Cart_providers/remove_cartproduct.dart';
import 'package:grocery_app/Providers/Favourite_providers/remove_fav.dart';
import 'package:grocery_app/Providers/Cart_providers/update_cartprovider.dart';
import 'package:grocery_app/Providers/Cart_providers/view_cart.dart';
import 'package:grocery_app/Screens/Splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/Providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => CreateaccProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => FavouriteListProvider()),
        ChangeNotifierProvider(create: (_) => ProductlistProvider()),
        ChangeNotifierProvider(create: (_) => AddFavouriteProvider()),
        ChangeNotifierProvider(create: (_) => RemoveFavouriteProvider()),
        ChangeNotifierProvider(create: (_) => ProductDetailProvider()),
        ChangeNotifierProvider(create: (_) => AddToCartProvider()),
        ChangeNotifierProvider(create: (_) => RecentProductsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => RemoveCartproductProvider()),
        ChangeNotifierProvider(create: (_) => UpdateCartProvider()),
        ChangeNotifierProvider(create: (_) => RecoverPasswordProvider()),
        ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
        ChangeNotifierProvider(create: (_) => AddAddressProvider()),
        ChangeNotifierProvider(create: (_) => ViewAddressProvider()),
        ChangeNotifierProvider(create: (_) => RemoveAddressProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => AllproductsProvider()),
        ChangeNotifierProvider(create: (_) => EditProfileProvider()),
        ChangeNotifierProvider(create: (_) => BuyNowProvider()),
        ChangeNotifierProvider(create: (_) => RazorpayKeyProvider()),
        ChangeNotifierProvider(create: (_) => PlaceOrderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.green),
        home: const SplashScreen(),
      ),
    );
  }
}
