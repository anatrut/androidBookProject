import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/book_card.dart';

// Screen for viewing and downloading books for Ages 0–4.
// Supports both PDF and DOCX formats, determined by navigation argument.

class Books04Screen extends StatelessWidget {
  const Books04Screen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the selected format ("pdf" or "docx") from route arguments
    final format = ModalRoute.of(context)!.settings.arguments as String? ?? 'pdf';

    // Choose the appropriate icon based on format
    final iconPath = format == 'pdf'
        ? 'assets/icons/pdf_icon.png'
        : 'assets/icons/docx_icon.png';

    return Scaffold(
      appBar: AppBar(
        // Display the icon + text in the title
        title: Row(
          children: [
            Image.asset(iconPath, height: 28),  // Format icon (PDF or DOCX)
            const SizedBox(width: 12),          // Spacing between icon and title
            Text("Ages 0–4 ($format)"),         // App bar title
          ],
        ),
        centerTitle: false, // Align title to the left
      ),

      // Body shows a loading indicator, error, or list of books
      body: FutureBuilder<Map<String, String>>(
        // Load the books for age group "0-4" and requested format
        future: FirebaseService.getBooksByAgeGroup("0-4", format),
        builder: (context, snapshot) {
          // Show spinner while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error message if the request failed
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading books"));
          }

          // Extract the book data (title → URL map)
          final books = snapshot.data!;
          if (books.isEmpty) {
            return const Center(child: Text("No books available for this format"));
          }

          // Main layout: list of books + upload button
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Scrollable list of BookCard widgets
                Expanded(
                  child: ListView(
                    children: books.entries
                        .map((entry) => BookCard(
                              title: entry.key,
                              url: entry.value,
                            ))
                        .toList(),
                  ),
                ),

                // Upload button at the bottom of the screen
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to upload screen with pre-filled arguments
                    Navigator.pushNamed(
                      context,
                      '/upload',
                      arguments: {
                        'ageGroup': '0-4',
                        'format': format,
                      },
                    );
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Upload Book"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
