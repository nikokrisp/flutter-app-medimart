import 'package:flutter/material.dart';
// Import Firebase Auth
import 'package:firebase_auth/firebase_auth.dart';
// Import flutter_login
import 'package:flutter_login/flutter_login.dart';

// We don't need imports for the main app content pages (HomePage, etc.)
// or providers like PageIndexProvider, ThemeProvider, etc. in this file.
// AccountManager and SignupPage imports should also be removed if they were used previously.

class LoginPage extends StatefulWidget {
  // This widget's only job is to show the login UI.
  // Authentication state is handled outside this widget (in main.dart).
  // We no longer need the onLogin callback here.
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  // No state variables related to the main app content needed here.
  // No text controllers from the old custom UI needed.

  // --- Firebase Auth Callbacks for flutter_login ---
  // These functions are called by the FlutterLogin widget when a user submits a form.
  // They interact with Firebase Authentication and return an error message (String)
  // or null if successful.

  Future<String?> _authUser(LoginData data) async {
    debugPrint('Login Attempt: ${data.name}');
    try {
      // Call the Firebase Auth sign-in method
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data.name.trim(), // Use data.name for the email
        password: data.password,
      );
      // If the above line completes without throwing an error, login was successful.
      debugPrint('Login Successful for ${data.name}');
      return null; // Return null on success, flutter_login handles the transition
    } on FirebaseAuthException catch (e) {
      // Catch specific Firebase Auth errors and return a user-friendly message
      debugPrint('Firebase Auth Login Error: ${e.code}'); // Log the error code for debugging
       if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
         return 'The email address is not valid.';
      } else if (e.code == 'user-disabled') {
         return 'This user account has been disabled.';
      } else if (e.code == 'network-request-failed') {
         return 'Network error. Please check your connection.';
      }
       // Add more specific error codes as needed
      else {
        // Fallback for any other unexpected Firebase Auth errors
        return e.message ?? 'An unknown error occurred during login.';
      }
    } catch (e) {
       // Catch any other unexpected errors
       debugPrint('Unexpected Login Error: ${e.toString()}'); // Log unexpected errors
       return 'An unexpected error occurred: ${e.toString()}';
    }
  }

  Future<String?> _signupUser(SignupData data) async {
     debugPrint('Signup Attempt: ${data.name}');
     // Basic validation: check if password is provided
      if (data.password == null || data.password!.isEmpty) {
       return 'Password cannot be empty.';
     }
     // You might add more validation here (e.g., password complexity)

     try {
       // Call the Firebase Auth create user method
       await FirebaseAuth.instance.createUserWithEmailAndPassword(
         email: data.name!.trim(), // Use data.name for the email
         password: data.password!, // Use data.password
       );
       // If successful, user is created and automatically logged in by Firebase Auth.
       // The StreamBuilder in main.dart will detect this state change.
       debugPrint('Signup Successful for ${data.name}');
       return null; // Return null on success
     } on FirebaseAuthException catch (e) {
       // Catch specific Firebase Auth errors during signup
       debugPrint('Firebase Auth Signup Error: ${e.code}'); // Log the error code
       if (e.code == 'weak-password') {
         return 'The password provided is too weak.';
       } else if (e.code == 'email-already-in-use') {
         return 'An account already exists for that email.';
       } else if (e.code == 'invalid-email') {
         return 'The email address is not valid.';
       } else if (e.code == 'operation-not-allowed') {
          return 'Email/Password sign-up is not enabled. Check Firebase console.'; // Important reminder!
       }
       // Add more specific error codes as needed
       else {
         // Fallback for any other unexpected Firebase Auth errors
         return e.message ?? 'An unknown error occurred during signup.';
       }
     } catch (e) {
       // Catch any other unexpected errors
       debugPrint('Unexpected Signup Error: ${e.toString()}'); // Log unexpected errors
       return 'An unexpected error occurred: ${e.toString()}';
     }
  }

  Future<String?> _recoverPassword(String email) async {
     debugPrint('Recover password attempt for email: $email');
     try {
       // Call the Firebase Auth send password reset email method
       await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
       debugPrint('Password reset email sent to $email');
       // Return null to indicate success (flutter_login will close the dialog)
       // You could also return a success message if you prefer flutter_login
       // to display it after closing the dialog: return 'Password reset link sent!';
       return null;
     } on FirebaseAuthException catch (e) {
       // Catch specific Firebase Auth errors during password recovery
       debugPrint('Firebase Auth Recover Password Error: ${e.code}'); // Log the error code
        if (e.code == 'user-not-found') {
          return 'No user found for that email.';
        } else if (e.code == 'invalid-email') {
          return 'The email address is not valid.';
        } else if (e.code == 'network-request-failed') {
           return 'Network error. Please check your connection.';
        }
       // Add more specific error codes as needed
       else {
         // Fallback for any other unexpected Firebase Auth errors
         return e.message ?? 'An unknown error occurred during password recovery.';
       }
     } catch (e) {
       // Catch any other unexpected errors
       debugPrint('Unexpected Recover Password Error: ${e.toString()}'); // Log unexpected errors
       return 'An unexpected error occurred: ${e.toString()}';
     }
  }

  // --- Build method ---
  @override
  Widget build(BuildContext context) {
    // This widget ONLY displays the FlutterLogin UI.
    // It does NOT contain the StreamBuilder or the main app Scaffold.
    // The decision of whether to show *this* widget or the main app content
    // is made in main.dart using the StreamBuilder.
    return FlutterLogin(
      onLogin: _authUser, // Pass your Firebase login function
      onSignup: _signupUser, // Pass your Firebase signup function
      onRecoverPassword: _recoverPassword, // Pass your Firebase password recovery function
      // onSubmitAnimationCompleted is called *after* a successful login animation.
      // Since main.dart's StreamBuilder is listening to auth state changes,
      // the UI will automatically switch to the main app content when a user
      // logs in or signs up successfully. No explicit navigation needed here.
      onSubmitAnimationCompleted: () {
        debugPrint('Login animation complete from LoginPage!');
        // The state change should now be picked up by the StreamBuilder in main.dart
      },
      // Customize appearance, text, etc. here
      theme: LoginTheme(
        // You can customize colors, shapes, etc. using your app's theme context
        logoWidth: 1, // Adjust logo width
        primaryColor: Theme.of(context).primaryColor,
        accentColor: Theme.of(context).colorScheme.secondary,
        buttonTheme: LoginButtonTheme(
          backgroundColor: Colors.blue[900],
          highlightColor: Colors.blue[700],
          splashColor: Colors.blue[500],
        ),
        cardTheme: CardTheme(
          color: Theme.of(context).cardColor.withAlpha((0.8 * 255).toInt()),
        ),
        // Add more theme customizations if needed
      ),
      // Optional: Customize text messages shown in the UI
      messages: LoginMessages(
        loginButton: 'LOG IN',
        signupButton: 'SIGN UP',
        forgotPasswordButton: 'Forgot Password?',
      ),
      children: [
        Builder(
          builder: (context) {
            final screenHeight = MediaQuery.of(context).size.height;

            return Positioned(
              top: screenHeight * 0.15,
              left: 0,
              right: 0,
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1500),
                tween: Tween(begin: -50.0, end: 0.0),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: (value + 50) / 50, // Fade from 0 to 1
                    child: Transform.translate(
                      offset: Offset(0, value),
                      child: child,
                    ),
                  );
                },
                child: Hero(
                  tag: 'flutter_login_logo',
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'images/dark medimart logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
       // Optional: Add custom input validators if needed
      //  emailValidator: (value) { /* return error string or null */ },
      //  passwordValidator: (value) { /* return error string or null */ },
    );
  }
}
