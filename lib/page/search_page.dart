import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  final double screenHeight;

  const SearchPage({
    super.key,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Search Page Placeholder\nScreen Height: $screenHeight'),
      ),
    );
  }
}
