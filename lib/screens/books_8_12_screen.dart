import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/book_card.dart';

// Screen for showing downloadable books for children aged 8–12.
// Displays PDF or DOCX books based on the format passed as a route argument.

class Books812Screen extends StatelessWidget {
  const Books812Screen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the selected file format from the navigation arguments.
    // If no format is passed, default to 'pdf'.
    final format = ModalRoute.of(context)!.settings.arguments as String? ?? 'pdf';

    // Choose which icon to show in the AppBar based on the format
    final iconPath = format == 'pdf'
        ? 'assets/icons/pdf_icon.png'
        : 'assets/icons/docx_icon.png';

    return Scaffold(
      appBar: AppBar(
        // Title row: shows icon and age group with format
        title: Row(
          children: [
            Image.asset(iconPath, height: 28), // Show PDF or DOCX icon
            const SizedBox(width: 10),         // Spacing between icon and text
            Text('Ages 8–12 ($format)'),        // Title text
          ],
        ),
      ),

      // Body uses FutureBuilder to load and display book data
      body: FutureBuilder<Map<String, String>>(
        // Request books for age group 8–12 and selected format
        future: FirebaseService.getBooksByAgeGroup('8-12', format),
        builder: (context, snapshot) {
          // Show loading spinner while waiting for Firebase
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If an error occurred during the fetch
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading books'));
          }

          // Get the actual book list (title → URL map)
          final books = snapshot.data!;
          if (books.isEmpty) {
            return const Center(child: Text('No books available for this format'));
          }

          // Main layout: list of books + upload button
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Scrollable list of book cards
                Expanded(
                  child: ListView(
                    children: books.entries
                        .map((entry) => BookCard(
                              title: entry.key,     // Book title
                              url: entry.value,     // File URL
                            ))
                        .toList(),
                  ),
                ),

                // Upload Book button at the bottom
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to upload screen with selected age group and format
                    Navigator.pushNamed(
                      context,
                      '/upload',
                      arguments: {
                        'ageGroup': '8-12',
                        'format': format,
                      },
                    );
                  },
                  icon: const Icon(Icons.upload_file),   // Upload icon
                  label: const Text("Upload Book"),       // Button text
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
