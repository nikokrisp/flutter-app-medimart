// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Import Firebase Core and Auth
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Import flutter_login
// Import the generated Firebase options file
import 'firebase_options.dart'; // Make sure this file path is correct

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

Future<void> main() async { // Make main function async
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      // The home widget uses a StreamBuilder to decide which screen to show
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
           // Show a loading indicator while checking auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // If snapshot.hasData is true, a user is logged in
          if (snapshot.hasData) {
            // User is logged in, show the main application content
            // Pass the user object down if needed by child widgets
            return MainAppScaffoldContent(user: snapshot.data);
          } else {
            // User is NOT logged in, show the LoginPage (which contains the flutter_login UI)
            return const LoginPage();
          }
        },
      ),
    );
  }
}


// This widget contains the main application UI when the user is logged in
// It was previously part of your MainScaffold's 'true' branch
class MainAppScaffoldContent extends StatefulWidget {
  // Receive the logged-in user object
  final User? user;
  const MainAppScaffoldContent({super.key, this.user});

  @override
  State<MainAppScaffoldContent> createState() => _MainAppScaffoldContentState();
}

class _MainAppScaffoldContentState extends State<MainAppScaffoldContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Keep GlobalKey here

  // --- Firebase Sign Out Logic (Lives here as it's part of the main content) ---
  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      debugPrint('User signed out');
      // The StreamBuilder in MyApp's home will detect this and show the LoginPage
    } catch (e) {
      debugPrint('Error signing out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the PageIndexProvider here as it's used by the main content
    final pageIndexProvider = Provider.of<PageIndexProvider>(context);
    final currentIndex = pageIndexProvider.currentIndex;

    // Get current logged-in user details for the drawer
    final currentUser = widget.user ?? FirebaseAuth.instance.currentUser; // Use passed user or get current
    final currentUserDisplayName = currentUser?.displayName ?? currentUser?.email ?? 'User';
    final currentUserPhotoUrl = currentUser?.photoURL;

    // Calculate screen dimensions (needed for your page widgets)
    final appBarHeight = AppBar().preferredSize.height;
    final paddingTop = MediaQuery.of(context).padding.top;
    // kBottomNavigationBarHeight is available from material.dart
    final screenHeight = MediaQuery.of(context).size.height - appBarHeight - paddingTop;
    final screenHeightWithoutNav = MediaQuery.of(context).size.height - appBarHeight - paddingTop - kBottomNavigationBarHeight;


    return Scaffold(
      key: _scaffoldKey, // Assign GlobalKey to Scaffold
      appBar: AppBar(
        title: Text(
          currentIndex == 0 ? 'Beranda'
              : currentIndex == 1 ? 'Cari'
              : currentIndex == 2 ? 'Favorit'
              : currentIndex == 3 ? 'Inbox'
              : 'Profil User',
          style: GoogleFonts.lora(fontWeight: FontWeight.w700),
        ),
        actions: currentIndex == 4
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    debugPrint('Edit account button pressed');
                  },
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
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
                      _scaffoldKey.currentState?.openEndDrawer(); // Use the key here
                    },
                    child: CircleAvatar(
                      backgroundImage: currentUserPhotoUrl != null
                          ? NetworkImage(currentUserPhotoUrl) as ImageProvider
                          : const AssetImage('images/profile pic.jpg'),
                    ),
                  ),
                ),
              ],
      ),
      endDrawer: buildDrawer(
        username: currentUserDisplayName, // Pass user info
        onLogout: _logout, // Pass the sign out function within this State
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomePage(screenHeight: screenHeight,),
          SearchPage(screenHeight: screenHeight),
          FavoritePage(screenHeight: screenHeight),
          InboxPage(screenHeight: screenHeight),
          // Pass the user to the AccountPage if it needs user-specific data
          AccountPage(screenHeight: screenHeightWithoutNav),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          pageIndexProvider.setPageIndex(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Akun'),
        ],
        type: BottomNavigationBarType.fixed, // Ensure all labels are shown
        selectedFontSize: 16,
        unselectedFontSize: 14,
        selectedItemColor: Colors.blue[900],
        unselectedItemColor: Colors.grey[400],
        selectedIconTheme: IconThemeData(size: 30, color: Colors.blue[900]),
        unselectedIconTheme: IconThemeData(size: 28, color: Colors.grey[400]),
        showUnselectedLabels: true, // Explicitly show all labels
      ),
    );
  }
}