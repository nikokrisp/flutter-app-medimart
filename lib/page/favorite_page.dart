import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  final double screenHeight;

  const FavoritePage({
    super.key,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Favorite Page Placeholder\nScreen Height: $screenHeight'),
      ),
    );
  }
}
