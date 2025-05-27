import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/filter_bloc.dart';
import '../bloc/filter_event.dart';
import '../bloc/filter_state.dart';

class BuildFilter extends StatelessWidget {
  const BuildFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FilterBloc(),
      child: const _BuildFilterView(),
    );
  }
}

class _BuildFilterView extends StatelessWidget {
  const _BuildFilterView();

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
        child: BlocBuilder<FilterBloc, FilterState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  context: context,
                  title: "Opsi Pengiriman",
                  isVisible: state.isDeliveryOptionsVisible,
                  onToggle: () => context.read<FilterBloc>().add(ToggleDeliveryOptions()),
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
                  context: context,
                  title: "Jangkauan Harga",
                  isVisible: state.isPriceRangeVisible,
                  onToggle: () => context.read<FilterBloc>().add(TogglePriceRange()),
                  content: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPriceBox(state.minPrice, isDarkMode),
                          _buildPriceBox(state.maxPrice, isDarkMode),
                        ],
                      ),
                      RangeSlider(
                        min: 1000,
                        max: 10000,
                        values: RangeValues(state.minPrice, state.maxPrice),
                        onChanged: (values) {
                          context.read<FilterBloc>().add(UpdatePriceRange(values.start, values.end));
                        },
                      ),
                    ],
                  ),
                ),
                Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey),
                _buildSection(
                  context: context,
                  title: "Rata-Rata Ulasan",
                  isVisible: state.isReviewRatingVisible,
                  onToggle: () => context.read<FilterBloc>().add(ToggleReviewRating()),
                  content: Row(children: _buildStarRating(4, isDarkMode)),
                ),
                Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey),
                _buildSection(
                  context: context,
                  title: "Lainnya",
                  isVisible: state.isOtherOptionsVisible,
                  onToggle: () => context.read<FilterBloc>().add(ToggleOtherOptions()),
                  content: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSelectableButton(
                        context: context,
                        text: "Free Return",
                        selected: state.freeReturn,
                        isDarkMode: isDarkMode,
                        onTap: () => context.read<FilterBloc>().add(ToggleFreeReturn()),
                      ),
                      _buildSelectableButton(
                        context: context,
                        text: "Buyer Protection",
                        selected: state.buyerProtection,
                        isDarkMode: isDarkMode,
                        onTap: () => context.read<FilterBloc>().add(ToggleBuyerProtection()),
                      ),
                      _buildSelectableButton(
                        context: context,
                        text: "Best Deal",
                        selected: state.bestDeal,
                        isDarkMode: isDarkMode,
                        onTap: () => context.read<FilterBloc>().add(ToggleBestDeal()),
                      ),
                      _buildSelectableButton(
                        context: context,
                        text: "Nearest",
                        selected: state.nearest,
                        isDarkMode: isDarkMode,
                        onTap: () => context.read<FilterBloc>().add(ToggleNearest()),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
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

  Widget _buildSelectableButton({
    required BuildContext context,
    required String text,
    required bool selected,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
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
