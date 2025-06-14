// lib/favorites_manager.dart
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {
  static const _favoritesKey = 'favorite_dishes';

  static Future<void> addFavorite(String dishName) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    if (!favorites.contains(dishName)) {
      favorites.add(dishName);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  static Future<void> removeFavorite(String dishName) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    if (favorites.contains(dishName)) {
      favorites.remove(dishName);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  static Future<bool> isFavorite(String dishName) async {
    final favorites = await getFavorites();
    return favorites.contains(dishName);
  }
}