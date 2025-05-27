import 'package:flutter/material.dart';
import 'package:flutter_medimart/data/account_manager.dart';
import 'package:flutter_medimart/page/signup_page.dart';

class LoginPage extends StatefulWidget {
  final Function(String) onLogin;
  const LoginPage({super.key, required this.onLogin});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  void _handleLogin() {
    if (AccountManager.validateLogin(_usernameController.text, _passwordController.text)) {
      widget.onLogin(_usernameController.text);
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid username or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.2;
    final isDarkTheme = theme.brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Allow resizing when the keyboard appears
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth - 2 * horizontalPadding,
                height: screenWidth - 2 * horizontalPadding,
                child: Image.asset(
                  isDarkTheme ? 'images/dark medimart logo.png' : 'images/medimart logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: screenHeight * 0.1),
              Container(
                margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      }, 
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off
                      ),
                    ),
                  ),
                  obscureText: _obscureText,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleLogin,
                child: Text('Login'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account yet? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                    child: Text(
                      "Make an account.",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}