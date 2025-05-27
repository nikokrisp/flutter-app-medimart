import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_medimart/page/riwayat_transaksi.dart';

class AccountPage extends StatelessWidget {
  final double screenHeight;

  const AccountPage({super.key, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Column(
        children: [
          SizedBox(height: 40), // Adjust for status bar

          // Profile Section
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/profile pic.jpg'), // Replace with real image
                ),
                SizedBox(height: 10),
                Text(
                  "Jeneng",
                  style: GoogleFonts.lora(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  "0810-xxxx-xxxx",
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.08),

          // Menu Options
          ProfileMenuItem(
            icon: Icons.history,
            text: "Riwayat Transaksi",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RiwayatTransaksi(screenHeight: screenHeight)),
              );
            },
            height: screenHeight * 0.1,
            isDarkMode: isDarkMode,
          ),
          SizedBox(height: screenHeight * 0.05),
          ProfileMenuItem(
            icon: Icons.confirmation_number,
            text: "Voucher",
            onTap: () {},
            height: screenHeight * 0.1,
            isDarkMode: isDarkMode,
          ),
          SizedBox(height: screenHeight * 0.05),
          ProfileMenuItem(
            icon: Icons.settings,
            text: "Pengaturan",
            onTap: () {},
            height: screenHeight * 0.1,
            isDarkMode: isDarkMode,
          ),
          SizedBox(height: screenHeight * 0.05),
          ProfileMenuItem(
            icon: Icons.help_outline,
            text: "Bantuan",
            onTap: () {},
            height: screenHeight * 0.1,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }
}

// Widget for profile menu items
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final double height;
  final bool isDarkMode;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    required this.height,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: isDarkMode ? Colors.blue[300] : Colors.blue),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.lora(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: isDarkMode ? Colors.grey[400] : Colors.grey),
          ],
        ),
      ),
    );
  }
}
