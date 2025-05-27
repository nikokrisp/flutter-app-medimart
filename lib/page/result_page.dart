import 'package:flutter/material.dart';
import 'package:flutter_medimart/page/checkout_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_medimart/provider/page_index_provider.dart';
import 'package:flutter_medimart/widget/build_drawer.dart';
import 'package:flutter_medimart/widget/build_filter.dart'; // Import buildFilter

class ResultPage extends StatefulWidget {
  final String searchQuery;

  const ResultPage({super.key, required this.searchQuery});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final List<String> _carouselImages = [
    'images/Placeholder_image.png', // Replace with actual image paths
    'images/Placeholder_image.png',
    'images/Placeholder_image.png',
    'images/Placeholder_image.png',
  ];

  int _currentImageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Add GlobalKey

  @override
  Widget build(BuildContext context) {
    final pageIndexProvider = Provider.of<PageIndexProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final appBarHeight = AppBar().preferredSize.height;
    final paddingTop = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height - appBarHeight - paddingTop;
    final bottomNavBarHeight = screenHeight * 0.1;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey, // Assign GlobalKey to Scaffold
      appBar: AppBar(
        title: Text(
          'Hasil Pencarian',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search TextField
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: widget.searchQuery),
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
            SizedBox(height: 16),

            // Swipeable Image Carousel
            Center(
              child: SizedBox(
                height: screenHeight * 0.15,
                width: screenWidth * 0.75,
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
            SizedBox(height: 16),

            // Product GridView (2x2)
            SizedBox(
              height: 0.3 * screenHeight,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.6,
                ),
                itemCount: 4, // Example product count
                itemBuilder: (context, index) {
                  final double rating = 4.5; // Example dynamic rating value
                  final int totalStars = 10;
                  final int yellowStars = (rating / 0.5).floor();
                  final int greyStars = totalStars - yellowStars;

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 5)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
                      children: [
                        Container(
                          height: screenHeight * 0.096,
                          width: screenWidth * 0.46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(_carouselImages[index], fit: BoxFit.fill),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text('Product ${index + 1}', style: GoogleFonts.lora(fontWeight: FontWeight.w700, color: Colors.black)),
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
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
                              SizedBox(width: screenWidth * 0.12),
                              Text('Rp 100.000', style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8),

            // See All Button
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
            SizedBox(height: 8),


            // Relevant products Row
            Row(
              spacing: screenWidth * 0.45,
              children: [
                Text(
                  "Relevant products",
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
            SizedBox(height: 8),

            // Product ListView (only 2 items)
            SizedBox(
              height: screenHeight * 0.22,
              child: ListView.builder(
                itemCount: 2, // Only show 2 items
                itemBuilder: (context, index) {
                  final double rating = 4.2; // Example dynamic rating value
                  final int totalStars = 10;
                  final int yellowStars = (rating / 0.5).floor();
                  final int greyStars = totalStars - yellowStars;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 5)],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 75,
                          width: 75,
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
                              Text('Relevant Product ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                              SizedBox(height: 16),
                              Row(
                                children: [
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
                                  SizedBox(width: screenWidth * 0.42,),
                                  Text('Rp 150.000', style: TextStyle(color: Colors.blue)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: bottomNavBarHeight, // Set height dynamically
        child: BottomNavigationBar(
          currentIndex: pageIndexProvider.currentIndex,
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
}
