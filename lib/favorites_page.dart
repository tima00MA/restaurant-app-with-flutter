import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'favorites_manager.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> _favoriteDishes = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Starters', 'Main Courses', 'Desserts', 'Drinks'];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await FavoritesManager.getFavorites();
    setState(() {
      _favoriteDishes = favorites;
      _isLoading = false;
    });
  }

  List<String> get _filteredFavorites {
    return _favoriteDishes.where((dish) {
      final matchesSearch = dish.toLowerCase().contains(_searchQuery.toLowerCase());
      // In a real app, you would filter by actual category here
      final matchesCategory = _selectedCategory == 'All' || 
          dish.toLowerCase().contains(_selectedCategory.toLowerCase());
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Favorite'),
        content: Text('Remove ${_filteredFavorites[index]} from favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _removeFavorite(_filteredFavorites[index]);
            },
            child: Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _removeFavorite(String dishName) async {
    await FavoritesManager.removeFavorite(dishName);
    _loadFavorites();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$dishName" removed from favorites'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () async {
            await FavoritesManager.addFavorite(dishName);
            _loadFavorites();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Favorites'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          if (_favoriteDishes.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (value) => _selectedCategory == value ? null : setState(() => _selectedCategory = value),
              itemBuilder: (context) => _categories.map((category) {
                return PopupMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: _selectedCategory == category ? Colors.teal : Colors.transparent,
                      ),
                      SizedBox(width: 8),
                      Text(category),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildFavoritesContent(),
    );
  }

  Widget _buildFavoritesContent() {
    if (_favoriteDishes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the heart icon on dishes to add them here',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (_filteredFavorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No matching favorites',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _selectedCategory = 'All';
                });
              },
              child: Text('Reset filters'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (_selectedCategory != 'All' || _searchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Chip(
              label: Text('Showing ${_filteredFavorites.length} of ${_favoriteDishes.length}'),
              backgroundColor: Colors.teal.withOpacity(0.2),
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadFavorites,
            child: ListView.builder(
              itemCount: _filteredFavorites.length,
              itemBuilder: (context, index) {
                final dishName = _filteredFavorites[index];
                return Dismissible(
                  key: Key(dishName),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      await _removeFavorite(dishName);
                      return false; // We handle deletion in the method
                    }
                    return false;
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(_getDishImage(dishName)),
                        child: Icon(Icons.food_bank, color: Colors.white),
                      ),
                      title: Text(dishName, style: TextStyle(fontSize: 16)),
                      subtitle: Text(_getDishCategory(dishName)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.grey),
                        onPressed: () => _showDeleteConfirmation(index),
                      ),
                      onTap: () => _showDishDetails(dishName),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  String _getDishImage(String dishName) {
    // In a real app, you would get this from your data model
    if (dishName.toLowerCase().contains('chicken')) {
      return 'assets/images/grilled_chicken.png';
    } else if (dishName.toLowerCase().contains('cake')) {
      return 'assets/images/chocolate_cake.png';
    }
    return 'assets/images/default_dish.png';
  }

  String _getDishCategory(String dishName) {
    // In a real app, you would get this from your data model
    if (dishName.toLowerCase().contains('chicken')) {
      return 'Main Course';
    } else if (dishName.toLowerCase().contains('cake')) {
      return 'Dessert';
    }
    return 'Unknown Category';
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search Favorites'),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: 'Search by dish name...'),
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _searchQuery = '');
              Navigator.pop(context);
            },
            child: Text('Reset'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDishDetails(String dishName) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        height: 300,
        child: Column(
          children: [
            Text(dishName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(_getDishImage(dishName)),
            ),
            SizedBox(height: 16),
            Text(_getDishCategory(dishName), style: TextStyle(color: Colors.teal)),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                await _removeFavorite(dishName);
                Navigator.pop(context);
              },
              child: Text('Remove from Favorites'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}