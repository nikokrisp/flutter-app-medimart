import 'package:flutter/material.dart';
import 'package:flutter_medimart/page/payment_method.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this for toast notifications

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _voucherController = TextEditingController();
  String? _voucherStatus; // Tracks the status of the voucher ("Applied" or "Denied")
  Color? _voucherStatusColor; // Tracks the color of the status text
  int _totalPrice = 0; // Tracks the total price
  int _discountAmount = 0; // Tracks the discount amount
  bool _showDiscountAnimation = false; // Tracks if the discount animation should be shown

  // Simulated valid voucher codes with discount amounts
  final Map<String, int> validVouchers = {
    "DISKON10": 20000,
    "FREEONGKIR": 15000,
    "SALE50": 50000,
  };

  @override
  void initState() {
    super.initState();
    _totalPrice = cartItems.fold(0, (sum, item) => sum + (item["price"] as int));
  }

  void _applyVoucher() {
    String inputCode = _voucherController.text.trim();

    setState(() {
      if (validVouchers.containsKey(inputCode)) {
        _voucherStatus = "Applied";
        _voucherStatusColor = Colors.green;
        _discountAmount = validVouchers[inputCode]!;
        _showNotification("Voucher berhasil digunakan!", Colors.green);

        // Trigger discount animation
        _showDiscountAnimation = true;
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _showDiscountAnimation = false;
              _totalPrice -= _discountAmount; // Reduce the total price
            });
          }
        });
      } else {
        _voucherStatus = "Denied";
        _voucherStatusColor = Colors.red;
        _showNotification("Voucher tidak valid!", Colors.red);

        // Revert back to "Apply" button after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _voucherStatus = null;
            });
          }
        });
      }
    });
  }

  void _showNotification(String message, Color color) {
    if (!mounted) return; // Ensure the widget is still mounted
    FToast fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      width: MediaQuery.of(context).size.width * 0.9, // Set width to 90% of the screen width
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), // Slightly taller padding
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: color,
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center, // Center the text
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
    );
  }

  final List<Map<String, dynamic>> cartItems = [
    {"name": "Obat 1", "desc": "Consequat ex eu", "price": 20000},
    {"name": "Obat 2", "desc": "Consequat ex eu", "price": 30000},
    {"name": "Obat Lagi", "desc": "Consequat ex eu", "price": 100000},
    {"name": "Banyak Sekali Obat", "desc": "Consequat ex eu", "price": 50000},
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        title: Center(
          child: Text(
            "Checkout",
            style: GoogleFonts.lora(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              children: [
                // List of Cart Items
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      var item = cartItems[index];
                      return _buildCartItem(item["name"], item["desc"], item["price"], isDarkMode);
                    },
                  ),
                ),
                SizedBox(height: 10),

                // Voucher Input
                _buildVoucherInput(isDarkMode),

                SizedBox(height: 10),

                // Shipping Method Dropdown
                _buildShippingDropdown(isDarkMode),

                SizedBox(height: 20),

                // Total Price
                _buildTotalPrice(isDarkMode),

                SizedBox(height: 20),

                // Next Button
                _buildNextButton(),
              ],
            ),

            // Discount Animation
            if (_showDiscountAnimation)
              Positioned(
                bottom: 85,
                left: MediaQuery.of(context).size.width * 0.84 - 50,
                child: AnimatedOpacity(
                  opacity: _showDiscountAnimation ? 1.0 : 0.0,
                  duration: const Duration(seconds: 1),
                  child: Text(
                    "- Rp $_discountAmount",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(String name, String desc, int price, bool isDarkMode) {
    return Card(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 120, // Set width and height to ensure a square aspect ratio
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[300], // Placeholder background color
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage("images/Placeholder_image.png"), // Placeholder for product image
                fit: BoxFit.cover, // Ensure the image covers the container
              ),
            ),
          ),
          SizedBox(width: 12), // Add spacing between image and text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.lora(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                ),
                SizedBox(height: 8),
                Text(
                  desc,
                  style: GoogleFonts.roboto(color: isDarkMode ? Colors.grey[400] : Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  "Rp ${price.toString()}",
                  style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                ),
              ],
            ),
          ),
          SizedBox(width: 12), // Add spacing for trailing content
          Column(
            children: [
              SizedBox(height: 90),
              Padding(padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                child: Text(
                  "x1",
                  style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherInput(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _voucherController,
            onChanged: (value) {
              // Revert back to "Apply" button when text field is re-entered
              if (_voucherStatus == "Denied") {
                setState(() {
                  _voucherStatus = null;
                });
              }
            },
            decoration: InputDecoration(
              hintText: "Enter voucher code",
              hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: isDarkMode ? Colors.grey[700]! : Colors.grey),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        SizedBox(width: 10),
        _voucherStatus == null
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange[100],
                ),
                onPressed: _applyVoucher,
                child: Text(
                  "Apply",
                  style: TextStyle(color: Colors.red[300]),
                ),
              )
            : Text(
                _voucherStatus!,
                style: TextStyle(color: _voucherStatusColor, fontWeight: FontWeight.bold),
              ),
      ],
    );
  }

  Widget _buildShippingDropdown(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Jenis Pengiriman",
          style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: isDarkMode ? Colors.grey[700]! : Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(Icons.local_shipping, color: isDarkMode ? Colors.white : Colors.black), // Car icon
              SizedBox(width: 8), // Spacing between icon and dropdown
              Expanded(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: "Instant",
                  underline: SizedBox(),
                  dropdownColor: isDarkMode ? Colors.grey[900] : Colors.white,
                  items: ["Instant", "Express", "Standard"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalPrice(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "TOTAL",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
        ),
        Text(
          "Rp $_totalPrice",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentMethodPage(totalPrice: _totalPrice), // Pass total price
            ),
          );
        },
        child: Text(
          "Selanjutnya →",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
