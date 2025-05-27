import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_medimart/provider/theme_provider.dart';

Drawer buildDrawer({
  required String username,
  required VoidCallback onLogout,
}) {
  return Drawer(
    child: Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Column(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              color: isDarkMode ? Colors.black : Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("images/profile pic.jpg"),
                  ),
                  Text(
                    username,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.terrain_outlined, color: isDarkMode ? Colors.white : Colors.black),
              title: Text(
                "Dark Theme",
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: isDarkMode ? Colors.white : Colors.black),
              title: Text(
                "Logout",
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onTap: onLogout,
            ),
          ],
        );
      },
    ),
  );
}