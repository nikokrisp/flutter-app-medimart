import 'package:flutter/material.dart';

class InboxPage extends StatelessWidget {
  final double screenHeight;

  const InboxPage({
    super.key,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Inbox Page Placeholder\nScreen Height: $screenHeight'),
      ),
    );
  }
}
