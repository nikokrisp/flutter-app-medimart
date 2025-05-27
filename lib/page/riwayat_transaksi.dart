// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_medimart/provider/page_index_provider.dart';
import 'package:flutter_medimart/widget/build_drawer.dart';
import 'package:provider/provider.dart';

class RiwayatTransaksi extends StatefulWidget {
  final double screenHeight;
  const RiwayatTransaksi({super.key, required this.screenHeight});

  @override
  _RiwayatTransaksiState createState() => _RiwayatTransaksiState();
}

class _RiwayatTransaksiState extends State<RiwayatTransaksi> {
  int selectedTab = 0; // Index for active tab

  final List<Map<String, dynamic>> transactions = [
    {
      "name": "Obat A",
      "price": "Rp 210.000",
      "status": "Pesanan Gagal",
      "statusColor": Colors.red,
      "icon": Icons.cancel,
      "iconColor": Colors.red,
    },
    {
      "name": "Obat B",
      "price": "Rp 210.000",
      "status": "Sedang Dikirim",
      "statusColor": Colors.orange,
      "icon": Icons.local_shipping,
      "iconColor": Colors.orange,
    },
    {
      "name": "Obat C",
      "price": "Rp 210.000",
      "status": "Terkirim",
      "statusColor": Colors.green,
      "icon": Icons.check_circle,
      "iconColor": Colors.green,
    },
    {
      "name": "Obat D",
      "price": "Rp 210.000",
      "status": "Terkirim",
      "statusColor": Colors.green,
      "icon": Icons.check_circle,
      "iconColor": Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final pageIndexProvider = Provider.of<PageIndexProvider>(context);
    final currentIndex = pageIndexProvider.currentIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Transaksi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).openEndDrawer();
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('images/profile pic.jpg'), // Profile picture
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
      body: Column(
        children: [
          SizedBox(height: widget.screenHeight * 0.05), // Adjust for status bar
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: widget.screenHeight * 0.08, // Stretch search bar height
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(height: 16),

          // Tab Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ["Terkini", "Terdahulu", "Gagal", "Terkirim"]
                  .asMap()
                  .entries
                  .map(
                    (entry) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = entry.key;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: selectedTab == entry.key ? Colors.lightBlue[100] : Colors.transparent,
                          borderRadius: BorderRadius.circular(20), // Pill-shaped highlight
                        ),
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            fontWeight: selectedTab == entry.key ? FontWeight.bold : FontWeight.normal,
                            color: selectedTab == entry.key ? Colors.blue : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          SizedBox(height: 16),

          // List of Transactions
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                var item = transactions[index];
                return Container(
                  height: widget.screenHeight * 0.15, // Set item height
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Placeholder for Image
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.image, color: Colors.grey[600]),
                      ),
                      SizedBox(width: 12),

                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: widget.screenHeight * 0.02), // Adjust for screen height
                            Text(
                              item["name"],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: widget.screenHeight * 0.04), // Adjust for screen height
                            Row(
                              children: [
                                Icon(
                                  item["icon"],
                                  color: item["iconColor"],
                                  size: 20,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  item["status"],
                                  style: TextStyle(
                                    color: item["statusColor"],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Price
                      Text(
                        item["price"],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // See All Button
          Padding(
            padding: EdgeInsets.symmetric(vertical: widget.screenHeight * 0.02), // Adjust for screen height
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "See all",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 45),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          pageIndexProvider.setPageIndex(index);
          Navigator.pop(context); // Navigate back to the selected page
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
    );
  }
}