import 'package:flutter/material.dart';
import 'package:flutter_medimart/page/checkout_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_medimart/widget/build_drawer.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _currentImageIndex = 0; // Track the current image index for the carousel

  final List<String> _carouselImages = [
    'images/Placeholder_image.png', // Replace with actual image paths
    'images/Placeholder_image.png',
    'images/Placeholder_image.png',
    'images/Placeholder_image.png',
  ];

  // Icon states for the description section
  final Map<String, bool> _featureStates = {
    "Melayani instan": false,
    "Bebas pengembalian": false,
    "Baik": false,
    "Resmi": false,
  };

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey, // Assign GlobalKey to Scaffold
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        title: Text(
          "Ibuprofen", // Keep the title text dynamic
          style: GoogleFonts.lora(
            fontWeight: FontWeight.w700,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: isDarkMode ? Colors.white : Colors.black),
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
        username: 'Admin', // Replace with dynamic username if available
        onLogout: () {
          Navigator.pop(context); // Handle logout action
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Carousel
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4, // Max height constrained by padding
                  width: MediaQuery.of(context).size.height * 0.4, // Width equal to height
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) {
                      setState(() {
                        if (details.velocity.pixelsPerSecond.dx > 0) {
                          // Swipe right
                          _currentImageIndex = (_currentImageIndex - 1 + _carouselImages.length) % _carouselImages.length;
                        } else if (details.velocity.pixelsPerSecond.dx < 0) {
                          // Swipe left
                          _currentImageIndex = (_currentImageIndex + 1) % _carouselImages.length;
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        _carouselImages[_currentImageIndex],
                        fit: BoxFit.cover,
                      ),
                    ),
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
              SizedBox(height: 16), // Increased spacing

              // Price & Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rp 34.000",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 20), // Larger star icon
                      Text(
                        " 4.5 (99 reviews)",
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Description
              Text(
                "Description",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.grey, fontSize: 16),
              ),
              SizedBox(height: 16),

              // Feature Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _featureStates.keys.map((feature) {
                  final isActive = _featureStates[feature]!;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _featureStates[feature] = !isActive; // Toggle active state
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          isActive ? _getFilledIcon(feature) : _getOutlinedIcon(feature),
                          color: isActive ? Colors.blue : Colors.grey,
                        ),
                        SizedBox(height: 4),
                        Text(
                          feature,
                          style: TextStyle(
                            fontSize: 12,
                            color: isActive ? Colors.blue : (isDarkMode ? Colors.white : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 24), // Increased spacing

              // Reviews
              _buildSectionHeader("Reviews"),
              _buildReview("User A", "Kira-kira it works 4 me yah", "A day ago", isDarkMode),
              _buildReview("User B", "Magna Cumlaude", "3 days ago", isDarkMode),
              SizedBox(height: 24),

              // Relevant Products
              _buildSectionHeader("Relevant products"),
              _buildRelevantProducts(isDarkMode),
              SizedBox(height: 24),

              // Notification Toggle
              _buildNotificationToggle(),
              SizedBox(height: 24),

              // Cart and Buy Now Buttons
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildCartButton(),
                  ),
                  SizedBox(width: 8), // Spacing between the buttons
                  Expanded(
                    flex: 17,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 16), // Increased padding
                      ),
                      onPressed: () {},
                      child: Text(
                        "Beli Sekarang",
                        style: TextStyle(color: Colors.white, fontSize: 18), // Larger font size
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getFilledIcon(String feature) {
    switch (feature) {
      case "Melayani instan":
        return Icons.local_shipping;
      case "Bebas pengembalian":
        return Icons.refresh;
      case "Baik":
        return Icons.thumb_up;
      case "Resmi":
        return Icons.verified;
      default:
        return Icons.help; // Default fallback
    }
  }

  IconData _getOutlinedIcon(String feature) {
    switch (feature) {
      case "Melayani instan":
        return Icons.local_shipping_outlined;
      case "Bebas pengembalian":
        return Icons.refresh_outlined;
      case "Baik":
        return Icons.thumb_up_outlined;
      case "Resmi":
        return Icons.verified_outlined;
      default:
        return Icons.help_outline; // Default fallback
    }
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text("See all", style: TextStyle(color: Colors.blue)),
      ],
    );
  }


  Widget _buildReview(String username, String comment, String time, bool isDarkMode) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: Colors.grey[300]),
      title: Text(
        username,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      subtitle: Text(
        comment,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.grey),
      ),
      trailing: Text(
        time,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.grey),
      ),
    );
  }

  Widget _buildRelevantProducts(bool isDarkMode) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.22,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10, // Example item count
        itemBuilder: (context, index) {
          final price = 10000 + index * 1000;
          final formattedPrice = price.toString().replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
            (match) => '${match.group(1)}.',
          );

          return Container(
            width: screenWidth * 0.3,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            padding: const EdgeInsets.all(8.0), // Thin edge padding
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image box (50% height)
                Container(
                  height: screenHeight * 0.2 * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage('images/Placeholder_image.png'), // Example image asset
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.2 * 0.06), // Padding (6% height)

                // Text: "Obat ${index + 1}" (12% height)
                SizedBox(
                  height: screenHeight * 0.2 * 0.12,
                  width: screenWidth * 0.3,
                  child: Text(
                    'Obat ${index + 1}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),

                // Text: "RP. $formattedPrice" (12% height)
                SizedBox(
                  height: screenHeight * 0.2 * 0.12,
                  width: screenWidth * 0.3,
                  child: Text(
                    'RP. $formattedPrice',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.2 * 0.05), // Padding (5% height)

                // Row: Star icon and rating text (15% height)
                SizedBox(
                  height: screenHeight * 0.2 * 0.15,
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '4.5', // Example rating
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationToggle() {
    // ignore: no_leading_underscores_for_local_identifiers
    bool _isNotificationOn = false; // Track the toggle state

    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _isNotificationOn = !_isNotificationOn; // Toggle the state
            });
          },
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 40, // Slightly smaller than the container height
                      width: 40, // Maintain a 1:1 ratio
                      decoration: BoxDecoration(
                        color: _isNotificationOn ? Colors.blue : Colors.white,
                        border: Border.all(color: _isNotificationOn ? Colors.blue : Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: _isNotificationOn ? Colors.white : Colors.blue,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Nyalakan Notifikasi Promo",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _isNotificationOn,
                  onChanged: (bool value) {
                    setState(() {
                      _isNotificationOn = value; // Update the state
                    });
                  },
                  activeColor: Colors.blue,
                  activeTrackColor: Colors.blue[100],
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CheckoutPage()),
        );
      },
      child: Container(
        height: 40, // Set height equal to width
        width: 40, // Maintain a 1:1 ratio
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.shopping_cart_outlined,
          color: Colors.blue,
        ),
      ),
    );
  }
}
