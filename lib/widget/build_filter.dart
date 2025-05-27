import 'package:flutter/material.dart';

class BuildFilter extends StatefulWidget {
  const BuildFilter({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BuildFilterState createState() => _BuildFilterState();
}

class _BuildFilterState extends State<BuildFilter> {
  double _minPrice = 1000;
  double _maxPrice = 10000;
  bool _freeReturn = false;
  bool _buyerProtection = false;
  bool _bestDeal = false;
  bool _nearest = false;

  // Section visibility states
  bool _isDeliveryOptionsVisible = true;
  bool _isPriceRangeVisible = true;
  bool _isReviewRatingVisible = true;
  bool _isOtherOptionsVisible = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        leading: Container(width: 0,),
        title: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Center(child: Text("Filter")),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        actions: [
          IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Icon(Icons.close, color: isDarkMode ? Colors.white : Colors.black, size: 24,),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: "Opsi Pengiriman",
              isVisible: _isDeliveryOptionsVisible,
              onToggle: () {
                setState(() {
                  _isDeliveryOptionsVisible = !_isDeliveryOptionsVisible;
                });
              },
              content: Column(
                children: [
                  _buildCheckbox("Instan (pengiriman dalam 2 jam)", isDarkMode),
                  _buildCheckbox("Express (pengiriman 1 hari)", isDarkMode),
                  _buildCheckbox("Standar (pengiriman 2-3 hari)", isDarkMode),
                ],
              ),
            ),
            Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey),
            _buildSection(
              title: "Jangkauan Harga",
              isVisible: _isPriceRangeVisible,
              onToggle: () {
                setState(() {
                  _isPriceRangeVisible = !_isPriceRangeVisible;
                });
              },
              content: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPriceBox(_minPrice, isDarkMode),
                      _buildPriceBox(_maxPrice, isDarkMode),
                    ],
                  ),
                  RangeSlider(
                    min: 1000,
                    max: 10000,
                    values: RangeValues(_minPrice, _maxPrice),
                    onChanged: (values) {
                      setState(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                    },
                  ),
                ],
              ),
            ),
            Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey),
            _buildSection(
              title: "Rata-Rata Ulasan",
              isVisible: _isReviewRatingVisible,
              onToggle: () {
                setState(() {
                  _isReviewRatingVisible = !_isReviewRatingVisible;
                });
              },
              content: Row(children: _buildStarRating(4, isDarkMode)),
            ),
            Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey),
            _buildSection(
              title: "Lainnya",
              isVisible: _isOtherOptionsVisible,
              onToggle: () {
                setState(() {
                  _isOtherOptionsVisible = !_isOtherOptionsVisible;
                });
              },
              content: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSelectableButton("Free Return", _freeReturn, isDarkMode, () {
                    setState(() => _freeReturn = !_freeReturn);
                  }),
                  _buildSelectableButton("Buyer Protection", _buyerProtection, isDarkMode, () {
                    setState(() => _buyerProtection = !_buyerProtection);
                  }),
                  _buildSelectableButton("Best Deal", _bestDeal, isDarkMode, () {
                    setState(() => _bestDeal = !_bestDeal);
                  }),
                  _buildSelectableButton("Nearest", _nearest, isDarkMode, () {
                    setState(() => _nearest = !_nearest);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required bool isVisible,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            IconButton(
              icon: Icon(
                isVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: onToggle,
            ),
          ],
        ),
        if (isVisible) content,
      ],
    );
  }

  Widget _buildCheckbox(String text, bool isDarkMode) {
    return Row(
      children: [
        Checkbox(
          value: false,
          onChanged: (bool? value) {},
          activeColor: isDarkMode ? Colors.blue : null,
        ),
        Text(
          text,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
      ],
    );
  }

  Widget _buildPriceBox(double price, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: isDarkMode ? Colors.grey[700]! : Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        "Rp ${price.toInt()}",
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      ),
    );
  }

  List<Widget> _buildStarRating(int stars, bool isDarkMode) {
    return List.generate(
      5,
      (index) => Icon(
        index < stars ? Icons.star : Icons.star_border,
        color: index < stars ? Colors.orange : (isDarkMode ? Colors.grey[700] : Colors.grey),
      ),
    );
  }

  Widget _buildSelectableButton(String text, bool selected, bool isDarkMode, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? Colors.blue : (isDarkMode ? Colors.grey[700]! : Colors.grey)),
          color: isDarkMode ? Colors.black : Colors.white,
        ),
        child: Text(
          text,
          style: TextStyle(color: selected ? Colors.blue : (isDarkMode ? Colors.white : Colors.black)),
        ),
      ),
    );
  }
}
