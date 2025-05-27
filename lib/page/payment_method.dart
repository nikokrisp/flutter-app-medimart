import 'package:flutter/material.dart';
import 'package:flutter_medimart/page/pending_page.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethodPage extends StatefulWidget {
  final int totalPrice; // Accept total price as a parameter

  const PaymentMethodPage({super.key, required this.totalPrice});

  @override
  PaymentMethodPageState createState() => PaymentMethodPageState();
}

class PaymentMethodPageState extends State<PaymentMethodPage> {
  // List of available payment methods
  final List<Map<String, dynamic>> paymentMethods = [
    {"type": "Visa", "lastDigits": "2334", "image": "images/visa.png"},
    {"type": "MasterCard", "lastDigits": "3774", "image": "images/mastercard.png"},
    {"type": "OVO", "lastDigits": "5064", "image": "images/ovo.jpg"},
  ];

  int _selectedPaymentIndex = 0; // Default selected payment method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Pembayaran", style: GoogleFonts.lora(fontWeight: FontWeight.w700, fontSize: 20),)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "TOTAL",
              style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              "Rp ${widget.totalPrice}", // Use the total price passed from CheckoutPage
              style: GoogleFonts.roboto(fontSize: 32, fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 20),

            // Payment Methods List
            Column(
              children: List.generate(paymentMethods.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPaymentIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedPaymentIndex == index ? Colors.blue : Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Image.asset(paymentMethods[index]["image"], width: 40),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "****** ${paymentMethods[index]["lastDigits"]}",
                            style: GoogleFonts.roboto(fontSize: 16),
                          ),
                        ),
                        Radio(
                          value: index,
                          groupValue: _selectedPaymentIndex,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentIndex = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: 20),

            // Pay Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PendingPage(
                        paymentMethod: paymentMethods[_selectedPaymentIndex], // Pass selected payment method
                        totalPrice: widget.totalPrice, // Pass total price
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.payment, color: Colors.white),
                label: Text("Bayar Sekarang", style: GoogleFonts.roboto(color: Colors.white, fontSize: 16)),
              ),
            ),

            SizedBox(height: 15),

            // Add New Payment Method
            GestureDetector(
              onTap: () {
                // Action to add new payment method
              },
              child: Text(
                "+ Tambahkan Metode Baru",
                style: GoogleFonts.roboto(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
