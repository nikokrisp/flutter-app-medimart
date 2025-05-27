import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_medimart/page/account_page.dart';
import 'package:flutter_medimart/page/checkout_page.dart';
import 'package:flutter_medimart/page/favorite_page.dart';
import 'package:flutter_medimart/page/home_page.dart';
import 'package:flutter_medimart/page/inbox_page.dart';
import 'package:flutter_medimart/page/login_page.dart';
import 'package:flutter_medimart/page/search_page.dart';
import 'package:flutter_medimart/provider/page_index_provider.dart';
import 'package:flutter_medimart/provider/theme_provider.dart';
import 'package:flutter_medimart/widget/build_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]) // Restrict to portrait mode
      .then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PageIndexProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()), // Add ThemeProvider
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light().copyWith(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue[900],
          unselectedItemColor: Colors.grey[400],
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.blue[300],
          unselectedItemColor: Colors.grey[600],
        ),
      ),
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Add GlobalKey
  bool _isLoggedIn = true;
  String _username = 'Admin';

  void _login(String username) {
    setState(() {
      _isLoggedIn = true;
      _username = username;
    });
  }

  void _logout() {
    setState(() {
      _isLoggedIn = false;
      _username = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageIndexProvider = Provider.of<PageIndexProvider>(context);
    final currentIndex = pageIndexProvider.currentIndex;

    final appBarHeight = AppBar().preferredSize.height;
    final paddingTop = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height - appBarHeight - paddingTop;
    final screenHeightWithoutNav = MediaQuery.of(context).size.height - appBarHeight - paddingTop - kBottomNavigationBarHeight;

    return _isLoggedIn
        ? Scaffold(
            key: _scaffoldKey, // Assign GlobalKey to Scaffold
            appBar: AppBar(
              title: Text(
                currentIndex == 0
                    ? 'Beranda'
                    : currentIndex == 1
                        ? 'Cari'
                        : currentIndex == 2
                            ? 'Favorit'
                        : currentIndex == 3
                            ? 'Inbox'
                            : 'Profil User',
                style: GoogleFonts.lora(fontWeight: FontWeight.w700),
              ),
              actions: currentIndex == 4 // Check if the current page is AccountPage
                  ? [
                      IconButton(
                        icon: Icon(Icons.edit), // Pencil icon
                        onPressed: () {
                          // Handle edit action
                        },
                      ),
                    ]
                  : [
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
                            _scaffoldKey.currentState?.openEndDrawer(); // Use GlobalKey to open the end drawer
                          },
                          child: CircleAvatar(
                            backgroundImage: AssetImage('images/profile pic.jpg'), // Profile picture
                          ),
                        ),
                      ),
                    ],
            ),
            endDrawer: buildDrawer(
              username: _username,
              onLogout: _logout,
            ),
            body: IndexedStack(
              index: currentIndex,
              children: [
                HomePage(screenHeight: screenHeight,),
                SearchPage(screenHeight: screenHeight),
                FavoritePage(screenHeight: screenHeight),
                InboxPage(screenHeight: screenHeight),
                AccountPage(screenHeight: screenHeightWithoutNav),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                pageIndexProvider.setPageIndex(index);
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
          )
        : LoginPage(
            onLogin: _login,
          );
  }
}
