// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_medimart/page/checkout_page.dart';
import 'package:flutter_medimart/page/result_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_medimart/provider/page_index_provider.dart';
import 'package:flutter_medimart/widget/build_drawer.dart';
import 'package:flutter_medimart/widget/build_filter.dart'; // Import buildFilter

class CategoriesPage extends StatefulWidget {
  final String categoryName;
  final int initialNavIndex;

  const CategoriesPage({super.key, required this.categoryName, required this.initialNavIndex});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _selectedTabIndex = 0; // Track the selected tab index
  int _currentImageIndex = 0; // Track the current image index for the carousel
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Add GlobalKey

  final List<String> _carouselImages = [
    'images/Placeholder_image.png', // Replace with actual image paths
    'images/Placeholder_image.png',
    'images/Placeholder_image.png',
    'images/Placeholder_image.png',
  ];


  @override
  Widget build(BuildContext context) {
    final pageIndexProvider = Provider.of<PageIndexProvider>(context);
    final TextEditingController searchController = TextEditingController();
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final paddingTop = MediaQuery.of(context).padding.top;
    final bottomNavBarHeight = screenHeight * 0.1; // Reserve 10% for the BottomNavigationBar
    final availableHeight = screenHeight - appBarHeight - paddingTop - bottomNavBarHeight - 48; // Adjust for padding and spacing

    return Scaffold(
      key: _scaffoldKey, // Assign GlobalKey to Scaffold
      resizeToAvoidBottomInset: false, // Prevent resizing when the keyboard appears
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: GoogleFonts.lora(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CheckoutPage()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState?.openEndDrawer(); // Use GlobalKey to open the drawer
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('images/profile pic.jpg'),
              ),
            ),
          ),
        ],
      ),
      endDrawer: buildDrawer(
        username: 'Admin',
        onLogout: () {
          Navigator.pop(context); // Handle logout action
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar with filter button
            SizedBox(
              height: screenHeight * 0.06,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onSubmitted: (query) {
                        if (query.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultPage(searchQuery: query),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuildFilter(),
                        ),
                      );
                    },
                    child: Icon(Icons.filter_list),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Categories
            Row(
              spacing: MediaQuery.of(context).size.width * 0.5,
              children: [
                Text(
                  "Categories",
                  style: GoogleFonts.lora(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        "See all",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16), // Adjusted spacing to match tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                3,
                (index) {
                  final borderColors = [Colors.red.shade100, Colors.yellow.shade100, Colors.blue.shade100];
                  final borderColor = borderColors[index % borderColors.length]; // Cycle through lighter colors
                  return Container(
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: borderColor,
                        width: 15.0,
                        strokeAlign: BorderSide.strokeAlignOutside
                      ),
                    ),
                    child: Icon(Icons.image, color: Colors.grey),
                  );
                },
              ),
            ),
            SizedBox(height: 24), 

            // Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Match alignment with categories
              children: [
                _buildTab("Best Sales", 0),
                _buildTab("Best Matched", 1),
                _buildTab("Popular", 2),
              ],
            ),
            SizedBox(height: 16),

            // Product List
            SizedBox(
              height: availableHeight * 0.4,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                itemCount: 4,
                itemBuilder: (context, index) {
                  return _buildProductCard("${widget.categoryName} ${String.fromCharCode(65 + index)}");
                },
              ),
            ),

            // See All Button with Gray Background
            Container(
              height: screenHeight * 0.03, // Use 3% of the screen height
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey[200],
              ),
              child: Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text("See all", style: TextStyle(color: Colors.grey[800])),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Swipeable Image Carousel
            Center(
              child: SizedBox(
                height: availableHeight * 0.2,
                width: MediaQuery.of(context).size.width * 0.9,
                child: PageView.builder(
                  itemCount: _carouselImages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        _carouselImages[index],
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _carouselImages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: _currentImageIndex == index ? 20.0 : 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: _currentImageIndex == index ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: bottomNavBarHeight, // Set height dynamically
        child: BottomNavigationBar(
          currentIndex: widget.initialNavIndex,
          onTap: (index) {
            pageIndexProvider.setPageIndex(index);
            Navigator.pop(context);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Cari',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inbox),
              label: 'Inbox',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Akun',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 16,
          unselectedFontSize: 14,
          selectedItemColor: Colors.blue[900],
          unselectedItemColor: Colors.grey[400],
          selectedIconTheme: IconThemeData(size: 30, color: Colors.blue[900]),
          unselectedIconTheme: IconThemeData(size: 28, color: Colors.grey[400]),
          showUnselectedLabels: true,
        ),
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final bool isActive = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index; // Update the selected tab index
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isActive ? Colors.lightBlue[100] : Colors.transparent, // Highlight color for active tab
          borderRadius: BorderRadius.circular(20.0), // Pill-shaped highlight
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal, // Bold text for active tab
            color: isActive ? Colors.blue[400] : Colors.black, // Text color based on active state
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(String title) {
    final double rating = 4.5; // Example dynamic rating value
    final int totalStars = 10;
    final int yellowStars = (rating / 0.5).floor();
    final int greyStars = totalStars - yellowStars;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16), // Increased padding for taller height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.image, color: Colors.grey),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                Row(
                  children: [
                    // Full yellow stars
                    for (int i = 0; i < yellowStars ~/ 2; i++)
                      Icon(Icons.star, color: Colors.orange, size: 16),
                    // Half yellow star
                    if (yellowStars % 2 == 1)
                      Icon(Icons.star_half, color: Colors.orange, size: 16),
                    // Grey stars
                    for (int i = 0; i < greyStars ~/ 2; i++)
                      Icon(Icons.star_border, color: Colors.grey, size: 16),
                  ],
                ),
              ],
            ),
          ),
          Text("Rp 210.000", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
