import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'reservation_page.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'favorites_manager.dart';
import 'favorites_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Menu',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedDrawerIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    MenuPage(),
    ContactPage(),
    FavoritesPage(),
  ];

  void _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Restaurant Menu")),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.teal),
                child: Text('Navigation', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                title: Text("Home"),
                leading: Icon(Icons.home),
                onTap: () => _onSelectItem(0),
              ),
              ListTile(
                title: Text("Menu"),
                leading: Icon(Icons.restaurant_menu),
                onTap: () => _onSelectItem(1),
              ),
              ListTile( // Add this new ListTile
                title: Text("Favorites"),
                leading: Icon(Icons.favorite),
                onTap: () => _onSelectItem(3),
              ),
              ListTile(
                title: Text("Contact / About"),
                leading: Icon(Icons.contact_mail),
                onTap: () => _onSelectItem(2),
              ),
            ],
          ),
        ),
      body: _pages[_selectedDrawerIndex],
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image de couverture
          Container(
            width: double.infinity,
            height: 200,
            child: Image.asset(
              'assets/images/restaurant_cover1.png',
              fit: BoxFit.cover,
            ),
          ),

          // Contenu principal
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre principal
                Text(
                  '🍽️ Gourmet Restaurant',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
                SizedBox(height: 10),

                // Description
                Text(
                  'Bienvenue dans notre restaurant raffiné où chaque plat est un voyage culinaire. Nous utilisons des ingrédients frais et des recettes authentiques.',
                  style: TextStyle(fontSize: 16),
                ),

                SizedBox(height: 20),

                // Infos en cartes
                Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.location_on, color: Colors.teal),
                    title: Text('123 Main Street, Casablanca, Morocco'),
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.phone, color: Colors.teal),
                    title: Text('+212 600-000000'),
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.access_time, color: Colors.teal),
                    title: Text('12:00 PM - 11:00 PM'),
                  ),
                ),

                SizedBox(height: 20),

                // Nos Services
                Text(
                  '⭐ Nos Services',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal[700]),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _serviceItem(Icons.delivery_dining, "Livraison"),
                    _serviceItem(Icons.local_dining, "Dîner sur place"),
                    _serviceItem(Icons.takeout_dining, "À emporter"),
                  ],
                ),

                SizedBox(height: 25),

                // Citation inspirante
                Center(
                  child: Text(
                    '“La cuisine, c’est l’art d’utiliser la nourriture pour créer du bonheur.”',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey[700]),
                  ),
                ),

                SizedBox(height: 25),

                // Galerie horizontale
                Text(
                  '📸 Quelques plats populaires',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _galleryImage('assets/images/plat1.png'),
                      _galleryImage('assets/images/plat2.png'),
                      _galleryImage('assets/images/plat3.png'),
                      _galleryImage('assets/images/plat4.png'),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // Boutons d'action
                Center(
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          DefaultTabController.of(context)?.animateTo(1);
                        },
                        icon: Icon(Icons.restaurant_menu),
                        label: Text("Voir le Menu"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ReservationPage()),
                          );
                        },
                        icon: Icon(Icons.book_online),
                        label: Text("Réserver une table"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade700,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget service
  Widget _serviceItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.teal),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  // Widget image pour la galerie
  Widget _galleryImage(String path) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          path,
          width: 120,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}


class MenuPage extends StatelessWidget {
  final List<String> categories = ['Starters', 'Main Courses', 'Desserts', 'Drinks'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange.shade800,
          title: Text('Our Menu', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.yellow.shade600,
            labelColor: Colors.yellow.shade600,
            unselectedLabelColor: Colors.orange.shade200,
            tabs: categories.map((cat) => Tab(text: cat)).toList(),
          ),
        ),
        body: TabBarView(
          children: categories.map((cat) => MenuCategory(category: cat)).toList(),
        ),
      ),
    );
  }
}

class MenuCategory extends StatefulWidget {
  final String category;
  MenuCategory({required this.category});

  @override
  _MenuCategoryState createState() => _MenuCategoryState();
}

class _MenuCategoryState extends State<MenuCategory> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> sampleDishes = [
  {
    'name': 'Grilled Chicken',
    'description': 'Juicy grilled chicken served with fresh veggies and a side of rice.',
    'price': '20.00',
    'image': 'assets/images/grilled_chicken.png',
    'likes': 20,
    'dislikes': 2,
    'comments': ['Delicious!', 'Too spicy.'],
    'liked': false,
    'disliked': false,
    'isFavorite': false, 
  },
  {
    'name': 'Chocolate Cake',
    'description': 'Rich and creamy chocolate cake topped with ganache.',
    'price': '6.50',
    'image': 'assets/images/chocolate_cake.png',
    'likes': 15,
    'dislikes': 0,
    'comments': ['Yummy!', 'Perfect dessert.'],
    'liked': false,
    'disliked': false,
    'isFavorite': false, 
  },
];
  final Map<int, TextEditingController> _commentControllers = {};

  @override
  void dispose() {
    _commentControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _toggleLike(int index) {
    setState(() {
      if (sampleDishes[index]['liked'] == true) {
        sampleDishes[index]['liked'] = false;
        sampleDishes[index]['likes']--;
      } else {
        sampleDishes[index]['liked'] = true;
        sampleDishes[index]['likes']++;
        if (sampleDishes[index]['disliked'] == true) {
          sampleDishes[index]['disliked'] = false;
          sampleDishes[index]['dislikes']--;
        }
      }
    });
  }

  void _toggleDislike(int index) {
    setState(() {
      if (sampleDishes[index]['disliked'] == true) {
        sampleDishes[index]['disliked'] = false;
        sampleDishes[index]['dislikes']--;
      } else {
        sampleDishes[index]['disliked'] = true;
        sampleDishes[index]['dislikes']++;
        if (sampleDishes[index]['liked'] == true) {
          sampleDishes[index]['liked'] = false;
          sampleDishes[index]['likes']--;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: sampleDishes.length,
      itemBuilder: (context, index) {
        var dish = sampleDishes[index];
        _commentControllers.putIfAbsent(index, () => TextEditingController());

        return Card(
          margin: EdgeInsets.only(bottom: 20),
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          shadowColor: Colors.orange.shade300,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            offset: Offset(0, 6),
                            blurRadius: 10,
                          ),
                        ]),
                        child: Image.network(
                          dish['image'],
                          height: 400,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              height: 400,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 200,
                            color: Colors.grey.shade200,
                            child: Icon(Icons.broken_image, size: 80, color: Colors.grey.shade400),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: IconButton(
                        icon: Icon(
                          dish['isFavorite'] == true 
                              ? Icons.favorite 
                              : Icons.favorite_border,
                          color: dish['isFavorite'] == true 
                              ? Colors.red 
                              : Colors.white,
                          size: 30,
                        ),
                        onPressed: () => _toggleFavorite(index),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  dish['name'],
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange.shade900),
                ),
                SizedBox(height: 8),
                Text(
                  dish['description'],
                  style: GoogleFonts.openSans(fontSize: 16, height: 1.4, color: Colors.grey.shade800),
                ),
                SizedBox(height: 12),
                Chip(
                  backgroundColor: Colors.orange.shade100,
                  label: Text(
                    '\$${dish['price']}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade900,
                      fontSize: 16,
                    ),
                  ),
                  avatar: Icon(Icons.attach_money, color: Colors.orange.shade700),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _toggleLike(index),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: dish['liked'] ? Colors.green.shade200 : Colors.grey.shade200,
                        ),
                        child: Icon(
                          Icons.thumb_up,
                          color: dish['liked'] ? Colors.green.shade700 : Colors.grey.shade600,
                          size: 28,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('${dish['likes']}', style: GoogleFonts.poppins(fontSize: 16)),
                    SizedBox(width: 24),
                    GestureDetector(
                      onTap: () => _toggleDislike(index),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: dish['disliked'] ? Colors.red.shade200 : Colors.grey.shade200,
                        ),
                        child: Icon(
                          Icons.thumb_down,
                          color: dish['disliked'] ? Colors.red.shade700 : Colors.grey.shade600,
                          size: 28,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('${dish['dislikes']}', style: GoogleFonts.poppins(fontSize: 16)),
                  ],
                ),
                SizedBox(height: 16),
                Divider(color: Colors.orange.shade200),
                SizedBox(height: 8),
                Text("Comments", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.orange.shade900)),
                SizedBox(height: 8),
                Container(
                  constraints: BoxConstraints(maxHeight: 140),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: dish['comments'].length,
                    separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300),
                    itemBuilder: (context, cIndex) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        "- ${dish['comments'][cIndex]}",
                        style: GoogleFonts.openSans(fontSize: 14, color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _commentControllers[index],
                  decoration: InputDecoration(
                    labelText: 'Add a comment',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send, color: Colors.orange.shade700),
                      onPressed: () {
                        final val = _commentControllers[index]?.text.trim() ?? '';
                        if (val.isNotEmpty) {
                          setState(() {
                            dish['comments'].add(val);
                            _commentControllers[index]?.clear();
                          });
                        }
                      },
                    ),
                  ),
                  onSubmitted: (val) {
                    if (val.trim().isEmpty) return;
                    setState(() {
                      dish['comments'].add(val.trim());
                      _commentControllers[index]?.clear();
                    });
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
  // for favorite page 

  @override
  void initState() {
  super.initState();
  _loadFavoritesStatus();
}

Future<void> _loadFavoritesStatus() async {
  for (var dish in sampleDishes) {
    dish['isFavorite'] = await FavoritesManager.isFavorite(dish['name']);
  }
  if (mounted) setState(() {});
}

void _toggleFavorite(int index) async {
  final dish = sampleDishes[index];
  final isCurrentlyFavorite = dish['isFavorite'] ?? false;
  
  setState(() {
    dish['isFavorite'] = !isCurrentlyFavorite;
  });

  if (!isCurrentlyFavorite) {
    await FavoritesManager.addFavorite(dish['name']);
  } else {
    await FavoritesManager.removeFavorite(dish['name']);
  }
}

}



// NOTE: Localization is skeleton only here, just for demonstration
Map<String, Map<String, String>> localizedStrings = {
  'en': {
    'contactUs': 'Contact Us',
    'callUs': 'Call Us',
    'sendEmail': 'Send Email',
    'whatsapp': 'WhatsApp',
    'ourLocation': 'Our Location',
    'aboutUs': 'About Us',
    'faq': 'FAQ',
    'reviews': 'Reviews',
    'saveContact': 'Save Contact',
    'followUs': 'Follow Us',
    'share': 'Share',
    'errorLaunch': 'Could not launch',
  },
  // Add other languages here ...
};

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final String phone = '+212600000000';
  final String email = 'contact@restaurant.com';
  final String address = '123 Main Street, Casablanca, Morocco';
  final String whatsapp = '+212600000000';

  // Language code (for demo, fixed to 'en')
  String langCode = 'en';

  // Sample FAQ data
  final List<Map<String, String>> faqs = [
    {
      'q': 'What are your opening hours?',
      'a': 'We are open from 12:00 PM to 11:00 PM every day.'
    },
    {
      'q': 'Do you offer vegetarian dishes?',
      'a': 'Yes, we have a variety of vegetarian options on the menu.'
    },
  ];

  // Sample reviews
  final List<Map<String, String>> reviews = [
    {
      'user': 'Alice',
      'comment': 'Amazing food and cozy atmosphere!'
    },
    {
      'user': 'Bob',
      'comment': 'Great service and delicious desserts.'
    }
  ];

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _launchUrlWithFeedback(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        showSnackBar('${localizedStrings[langCode]!['errorLaunch']}: $url');
      }
    } catch (e) {
      showSnackBar('${localizedStrings[langCode]!['errorLaunch']}: $url');
    }
  }

  void _launchPhone() async {
    final Uri url = Uri.parse('tel:$phone');
    await _launchUrlWithFeedback(url);
  }

  void _launchEmail() async {
    final Uri url = Uri.parse(
        'mailto:$email?subject=Inquiry from app&body=Hello, I would like to know more about your restaurant.');
    await _launchUrlWithFeedback(url);
  }

  void _launchWhatsApp() async {
    final Uri url = Uri.parse('https://wa.me/$whatsapp');
    await _launchUrlWithFeedback(url);
  }

  void _launchMap() async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
    await _launchUrlWithFeedback(url);
  }

  Future<void> _saveContact() async {
    // Request permission first
    var permissionStatus = await Permission.contacts.request();
    if (!permissionStatus.isGranted) {
      showSnackBar('Contacts permission denied');
      return;
    }

    // Create and save contact
    Contact newContact = Contact(
      givenName: 'Restaurant',
      phones: [Item(label: 'mobile', value: phone)],
      emails: [Item(label: 'work', value: email)],
      postalAddresses: [
        PostalAddress(label: 'work', street: address),
      ],
    );
    await ContactsService.addContact(newContact);
    showSnackBar('Contact saved!');
  }

  void _shareApp() {
    Share.share(
      'Check out this amazing restaurant at $address! Contact: $phone, $email',
      subject: 'Restaurant Info',
    );
  }

  bool _isDarkMode(BuildContext context) =>
      MediaQuery.of(context).platformBrightness == Brightness.dark;

  // For Google Maps
  late GoogleMapController _mapController;
  final LatLng _restaurantLatLng = LatLng(33.5731, -7.5898); // Casablanca approx

  @override
  Widget build(BuildContext context) {
    var colors = {
      'bg': _isDarkMode(context) ? Colors.grey[900]! : Colors.yellow[50]!,
      'primary': _isDarkMode(context) ? Colors.orange[300]! : Colors.orange[900]!,
      'card': _isDarkMode(context) ? Colors.grey[800]! : Colors.white,
      'text': _isDarkMode(context) ? Colors.white : Colors.black87,
      'icon': _isDarkMode(context) ? Colors.amber[300]! : Colors.amber[700]!,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(localizedStrings[langCode]!['contactUs']!),
        backgroundColor: colors['primary'],
      ),
      backgroundColor: colors['bg'],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(Icons.contact_page, size: 60, color: colors['icon']),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                localizedStrings[langCode]!['contactUs']!,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colors['primary'],
                ),
              ),
            ),
            SizedBox(height: 30),

            // Contact cards with animation
            _buildAnimatedCard(
              elevation: 6,
              child: ListTile(
                leading: Icon(Icons.phone, color: colors['icon']),
                title: Text(localizedStrings[langCode]!['callUs']!),
                subtitle: Text(phone),
                onTap: _launchPhone,
              ),
            ),
            _buildAnimatedCard(
              elevation: 6,
              child: ListTile(
                leading: Icon(Icons.email, color: colors['icon']),
                title: Text(localizedStrings[langCode]!['sendEmail']!),
                subtitle: Text(email),
                onTap: _launchEmail,
              ),
            ),
            _buildAnimatedCard(
              elevation: 6,
              child: ListTile(
                leading: Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
                title: Text(localizedStrings[langCode]!['whatsapp']!),
                subtitle: Text(whatsapp),
                onTap: _launchWhatsApp,
              ),
            ),
            _buildAnimatedCard(
              elevation: 6,
              child: ListTile(
                leading: Icon(Icons.location_on, color: colors['icon']),
                title: Text(localizedStrings[langCode]!['ourLocation']!),
                subtitle: Text(address),
                onTap: _launchMap,
              ),
            ),

            SizedBox(height: 10),

            // Google Map Embed
            Container(
              height: 180,
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.hardEdge,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _restaurantLatLng,
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('restaurant'),
                    position: _restaurantLatLng,
                    infoWindow: InfoWindow(title: 'Our Restaurant'),
                  )
                },
                onMapCreated: (controller) => _mapController = controller,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
              ),
            ),

            SizedBox(height: 20),

            // About Us Section
            Text(
              localizedStrings[langCode]!['aboutUs']!,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colors['primary'],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Welcome to our cozy restaurant where tradition meets taste. '
              'We use only fresh ingredients and authentic recipes to ensure your satisfaction. '
              'Whether you’re visiting for a quick lunch or a long dinner, we’ll make sure you feel right at home.',
              style: TextStyle(fontSize: 16, height: 1.5, color: colors['text']),
            ),

            SizedBox(height: 30),

            // FAQ Accordion
            Text(
              localizedStrings[langCode]!['faq']!,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colors['primary'],
              ),
            ),
            ...faqs.map((faq) => ExpansionTile(
                  title: Text(faq['q']!, style: TextStyle(color: colors['text'])),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(faq['a']!, style: TextStyle(color: colors['text'])),
                    ),
                  ],
                )),

            SizedBox(height: 30),

            // Reviews Section
            Text(
              localizedStrings[langCode]!['reviews']!,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colors['primary'],
              ),
            ),
            ...reviews.map((rev) => ListTile(
                  leading: CircleAvatar(
                    child: Text(rev['user']![0]),
                    backgroundColor: colors['icon'],
                    foregroundColor: colors['bg'],
                  ),
                  title: Text(rev['user']!, style: TextStyle(color: colors['text'])),
                  subtitle: Text(rev['comment']!, style: TextStyle(color: colors['text'])),
                )),

            SizedBox(height: 20),

            // Save Contact Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _saveContact,
                icon: Icon(Icons.save),
                label: Text(localizedStrings[langCode]!['saveContact']!),
                style: ElevatedButton.styleFrom(
                backgroundColor: colors['primary'],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Social & Share Buttons
            Center(
              child: Text(
                localizedStrings[langCode]!['followUs']!,
                style: TextStyle(
                    fontSize: 18,
                    color: colors['text'],
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.indigo),
                  onPressed: () =>
                      _launchUrlWithFeedback(Uri.parse('https://facebook.com/yourpage')),
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.instagram, color: Colors.purple),
                  onPressed: () =>
                      _launchUrlWithFeedback(Uri.parse('https://instagram.com/yourpage')),
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.twitter, color: Colors.lightBlue),
                  onPressed: () =>
                      _launchUrlWithFeedback(Uri.parse('https://twitter.com/yourpage')),
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.globe, color: Colors.green),
                  onPressed: () =>
                      _launchUrlWithFeedback(Uri.parse('https://yourwebsite.com')),
                ),
              ],
            ),

            SizedBox(height: 10),

            Center(
              child: ElevatedButton.icon(
                onPressed: _shareApp,
                icon: Icon(Icons.share),
                label: Text(localizedStrings[langCode]!['share']!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors['primary'],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Wrap card with a simple scale animation
  Widget _buildAnimatedCard({required Widget child, double elevation = 2}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ScaleAnimatedWidget.tween(
        duration: Duration(milliseconds: 300),
        scaleDisabled: 1,
        scaleEnabled: 1.05,
        child: Card(
          elevation: elevation,
          child: child,
        ),
      ),
    );
  }
}
