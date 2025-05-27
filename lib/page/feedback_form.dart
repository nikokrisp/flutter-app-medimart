import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensures the modal respects the height factor
      backgroundColor: Colors.transparent, // Transparent background to show the current page
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.75, // Restrict the modal to 75% of the screen height
        child: FeedbackForm(),
      ),
    );
  }
}

class _FeedbackFormState extends State<FeedbackForm> {
  int _feedbackStatus = 2; // Default status is 2 (Good)
  List<String> selectedTags = [];
  TextEditingController feedbackController = TextEditingController();
  double rating = 4.0;
  List<File> uploadedImages = [];

  final Map<int, List<String>> tagOptions = {
    0: [
      "Pelayanan Kurang Ramah",
      "Obat Tidak Bekerja",
      "Harga Mahal",
      "Pengiriman Lambat",
      "Barang Kurang Lengkap"
    ],
    1: [
      "Pelayanan Baik",
      "Obat Efektif",
      "Barang Lengkap",
      "Pengiriman Cepat"
    ],
    2: [
      "Pelayanan Sangat Baik",
      "Obat Efektif",
      "Harga Murah",
      "Pengiriman Cepat",
      "Promo",
      "Barang Lengkap",
      "Pelayanan Baik"
    ],
  };

  final Map<int, Color> statusColors = {
    0: Colors.red,
    1: Colors.amber[600] ?? Colors.amber,
    2: Colors.blue,
  };

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        uploadedImages.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> availableTags = tagOptions[_feedbackStatus] ?? [];
    final Color currentColor = statusColors[_feedbackStatus]!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)), // Rounded top corners
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.4),
                  Text(
                    "Feedback",
                    style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.3),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(thickness: 1), // Divider below the title
              SizedBox(height: 16),

              // Emoji selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  emojiIcon(0, Icons.sentiment_dissatisfied, currentColor),
                  SizedBox(width: 15),
                  emojiIcon(1, Icons.sentiment_neutral, currentColor),
                  SizedBox(width: 15),
                  emojiIcon(2, Icons.sentiment_satisfied, currentColor),
                ],
              ),

              // Tags selection
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Wrap(
                  spacing: 8.0,
                  children: availableTags.map((tag) {
                    bool isSelected = selectedTags.contains(tag);
                    return FilterChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedTags.add(tag);
                          } else {
                            selectedTags.remove(tag);
                          }
                        });
                      },
                      selectedColor: currentColor.withValues(alpha: 0.2),
                      checkmarkColor: currentColor,
                      backgroundColor: Colors.grey.shade200,
                    );
                  }).toList(),
                ),
              ),

              // Feedback Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  controller: feedbackController,
                  decoration: InputDecoration(
                    hintText: "Ada yang ingin anda tambahkan?",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                  maxLines: 3,
                ),
              ),

              // Image Upload
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.add, size: 40), // Increased icon size
                      ),
                    ),
                    SizedBox(width: 8),
                    ...uploadedImages.map((file) => Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(file),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    uploadedImages.remove(file);
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 10,
                                  child: Icon(Icons.close, size: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),

              // Rating
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (newRating) {
                    setState(() {
                      rating = newRating;
                    });
                  },
                ),
              ),

              // Submit Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: currentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Selesai", style: TextStyle(fontSize: 16, color: Colors.white)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget emojiIcon(int index, IconData icon, Color currentColor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _feedbackStatus = index;
        });
      },
      child: CircleAvatar(
        backgroundColor: _feedbackStatus == index ? currentColor.withValues(alpha: 0.2) : Colors.grey.shade200,
        radius: 30, // Increased radius for larger circle
        child: Icon(icon, size: 36, color: _feedbackStatus == index ? currentColor : Colors.black54), // Dynamic icon color
      ),
    );
  }
}