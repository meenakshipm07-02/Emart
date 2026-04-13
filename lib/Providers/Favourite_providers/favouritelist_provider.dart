import 'package:flutter/material.dart';
import 'package:grocery_app/API/main_api.dart';
import 'package:grocery_app/Models/Favourite_Model/favourite_model.dart';

class FavouriteListProvider with ChangeNotifier {
  final Main_Apis _api = Main_Apis();

  List<Favourite> _favourites = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _totalFavourites = 0;
  String? _userId;

  List<Favourite> get favourites => _favourites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalFavourites => _totalFavourites;
  String? get userId => _userId;

  Future<void> fetchFavourites() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.getFavourites();

      if (response['status'] == 'success') {
        _userId = response['user_id']?.toString();
        _totalFavourites =
            int.tryParse(response['total_favourites'].toString()) ?? 0;

        final List<dynamic>? favList = response['favourites'];
        if (favList != null && favList.isNotEmpty) {
          _favourites = favList.map((e) => Favourite.fromJson(e)).toList();
        } else {
          _favourites = [];
        }
      } else {
        _favourites = [];
        _errorMessage = response['message'] ?? 'Failed to load favourites';
      }
    } catch (e) {
      _favourites = [];
      final errorText = e.toString().replaceAll('Exception: ', '').trim();
      _errorMessage = errorText.isEmpty
          ? 'Something went wrong while fetching favourites.'
          : '$errorText';
    }

    _isLoading = false;
    notifyListeners();
  }

  void removeFavourite(int favId) {
    _favourites.removeWhere((item) => item.favouriteId == favId);
    _totalFavourites = _favourites.length;
    notifyListeners();
  }

  bool isProductFavourite(int productId) {
    return _favourites.any((item) => item.productId == productId);
  }
}
