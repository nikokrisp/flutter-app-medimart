import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_medimart/page/feedback_form.dart';

class PendingPage extends StatefulWidget {
  final Map<String, dynamic> paymentMethod; // Accept payment method as a parameter
  final int totalPrice; // Accept total price as a parameter

  const PendingPage({super.key, required this.paymentMethod, required this.totalPrice});

  @override
  State<PendingPage> createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  int _pendingStatus = 0; // 0: Loading, 1: Failed, 2: Success
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startStatusTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startStatusTimer() {
    _timer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _pendingStatus = Random().nextInt(4) < 3 ? 2 : 1; // 75% success, 25% failure
      });
    });
  }

  void _refreshStatus() {
    setState(() {
      _pendingStatus = 0; // Reset to loading
    });
    _startStatusTimer();
  }

  @override
  Widget build(BuildContext context) {
    final int tax = (widget.totalPrice * 0.1).round(); // Calculate 10% tax
    final int totalWithTax = widget.totalPrice + tax;

    // Define colors and icons based on status
    final Map<int, Color> statusColors = {
      0: Colors.amber,
      1: Colors.red,
      2: Colors.green,
    };

    final Map<int, IconData> statusIcons = {
      0: Icons.refresh_outlined, // Clock icon
      1: Icons.close_outlined, // Cross icon
      2: Icons.check_outlined, // Checkmark icon
    };

    final Color currentColor = statusColors[_pendingStatus]!;
    final IconData currentIcon = statusIcons[_pendingStatus]!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Status Icon
            CircleAvatar(
              backgroundColor: currentColor,
              radius: 40,
              child: Icon(
                currentIcon,
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Pembayaran Sedang Dikelola",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 5),
            Text(
              "Mohon tunggu sebentar, pembayaran anda sedang dikelola",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 20),

            // Payment Details Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildPaymentDetailRow("Subtotal", "Rp ${widget.totalPrice}"),
                    _buildPaymentDetailRow("Pajak (10%)", "Rp $tax"),
                    _buildPaymentDetailRow("Ongkir", "Rp 0"),
                    Divider(),
                    _buildPaymentMethodRow(
                      widget.paymentMethod["type"],
                      widget.paymentMethod["lastDigits"],
                      widget.paymentMethod["image"],
                    ),
                    Divider(),
                    _buildTotalRow("Rp $totalWithTax", currentColor, _pendingStatus == 0 ? "Loading" : _pendingStatus == 1 ? "Gagal" : "Berhasil"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Refresh Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _pendingStatus == 0 ? Colors.amber : _pendingStatus == 1 ? Colors.red : Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: _refreshStatus,
                icon: Icon(Icons.refresh, color: Colors.white),
                label: Text("Refresh", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),

            SizedBox(height: 10),

            // Back to Home Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _pendingStatus == 2 ? Colors.blue : Colors.grey, // Disable button if status is not 2
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: _pendingStatus == 2
                    ? () {
                        Navigator.of(context).popUntil((route) => route.isFirst); // Pop all pages back to the homepage
                        Future.delayed(const Duration(milliseconds: 5), () {
                          if (mounted) { // Check if the widget is still mounted
                            showDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              builder: (context) => Material(
                                type: MaterialType.transparency, // Ensure Material widget wraps the FeedbackForm
                                child: FeedbackForm(),
                              ),
                            );
                          }
                        });
                      }
                    : null, // Disable button action if status is not 2
                icon: Icon(Icons.home, color: Colors.white),
                label: Text("Back to Home", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodRow(String type, String lastDigits, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items to opposite sides
        children: [
          Text(
            "Metode",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Row(
            children: [
              Text(
                "****** $lastDigits",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(width: 10),
              Image.asset(imagePath, width: 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String totalAmount, Color boxColor, String boxText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(boxText, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
              SizedBox(width: 5),
              Text(
                totalAmount,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
