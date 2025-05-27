import 'package:flutter/material.dart';
import 'package:flutter_medimart/page/product_detail.dart';
import 'package:flutter_medimart/page/result_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_medimart/data/item_category.dart';
import 'package:flutter_medimart/page/categories_page.dart';
import 'package:flutter_medimart/widget/build_filter.dart';

class HomePage extends StatelessWidget {
  final double screenHeight;

  const HomePage({
    super.key,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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

                // Scrollable row - categories
                SizedBox(
                  height: screenHeight * 0.12,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: itemCategories.length, // Use the itemCategories list
                    itemBuilder: (context, index) {
                      final borderColors = [Colors.red, Colors.yellow, Colors.blue, Colors.green];
                      final borderColor = borderColors[index % borderColors.length]; // Cycle through colors
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoriesPage(
                                categoryName: itemCategories[index].name,
                                initialNavIndex: 0,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: screenWidth * 0.24,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.12 * 0.1),
                                child: Container(
                                  height: screenHeight * 0.12 * 0.6, // 60% of the container height
                                  width: screenHeight * 0.12 * 0.6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: borderColor,
                                      width: 10.0,
                                      strokeAlign: BorderSide.strokeAlignOutside,
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage('images/Placeholder_image.png'), // Example image asset
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Expanded(
                                child: Text(
                                  itemCategories[index].name, // Use the category name
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),

                // Top and bottom grids - promotion boxes
                Column(
                  children: [
                    // Top full-width box
                    Container(
                      height: screenHeight * 0.2, // 2/3 of 0.333 screenHeight
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                spacing: 8,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Drugs of the Month',
                                    style: GoogleFonts.lora(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.blue[600],
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    '50% off',
                                    style: TextStyle(fontSize: 20, color: Colors.black),
                                  ),
                                  SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetail(),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0, // Increased horizontal padding
                                        vertical: 12.0, // Increased vertical padding
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Text(
                                      'Buy now',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16, // Increased font size
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(height: screenHeight * 0.03),
                                Container(
                                  height: screenHeight * 0.11,
                                  width: screenWidth * 0.36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: AssetImage('images/Placeholder_image.png'),
                                      fit: BoxFit.fill,
                                    ),
                                    shape: BoxShape.rectangle,
                                  ),
                                ), // Example image asset
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Bottom two equal-sized boxes with updated discount tags
                    Row(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: screenHeight * 0.14,
                                width: screenWidth * 0.45, // 1/2 of 0.5 screenWidth
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Image.asset('images/Placeholder_image.png', fit: BoxFit.fill), // Example image asset
                              ),
                              Positioned(
                                top: 10,
                                left: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(16.0),
                                      bottomRight: Radius.circular(16.0),
                                    ), // Square on the left, half-circle on the right
                                  ),
                                  child: Text(
                                    '30%',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8), // Add spacing between the two boxes
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: screenHeight * 0.14,
                                width: screenWidth * 0.45, // 1/2 of 0.5 screenWidth
                                margin: const EdgeInsets.only(left: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.purple[100],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Image.asset('images/Placeholder_image.png', fit: BoxFit.fill),
                              ),
                              Positioned(
                                top: 10,
                                left: 9,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(16.0),
                                      bottomRight: Radius.circular(16.0),
                                    ), // Square on the left, half-circle on the right
                                  ),
                                  child: Text(
                                    '30%',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // "Beli lagi" container
                SizedBox(
                  height: screenHeight * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Beli lagi',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle "view all" action
                        },
                        child: Text(
                          'View all',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Scrollable list view - beli lagi items
                SizedBox(
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
                          color: Colors.grey[200],
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
                                style: GoogleFonts.lora(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
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
                                style: GoogleFonts.lora(
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
                                      color: Colors.black,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}