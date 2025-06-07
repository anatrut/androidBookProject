import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/book_card.dart';

// Screen that displays books for Ages 4–8
// Shows books based on format (PDF or DOCX), passed as route argument

class Books48Screen extends StatelessWidget {
  const Books48Screen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the format from navigation arguments ("pdf" or "docx")
    final format = ModalRoute.of(context)!.settings.arguments as String? ?? 'pdf';

    // Select icon path based on format
    final iconPath = format == 'pdf'
        ? 'assets/icons/pdf_icon.png'
        : 'assets/icons/docx_icon.png';

    return Scaffold(
      appBar: AppBar(
        // Show icon + format label in AppBar
        title: Row(
          children: [
            Image.asset(iconPath, height: 28), // Format icon
            const SizedBox(width: 10),
            Text('Ages 4–8 ($format)'), // Title with format
          ],
        ),
      ),

      // Body loads book data from Firebase and displays list or error
      body: FutureBuilder<Map<String, String>>(
        // Get books for age group 4-8 and specific format
        future: FirebaseService.getBooksByAgeGroup('4-8', format),
        builder: (context, snapshot) {
          // Show a loading spinner while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error if something went wrong
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading books'));
          }

          // Extract the book data (Map of title → URL)
          final books = snapshot.data!;
          if (books.isEmpty) {
            return const Center(child: Text('No books available for this format'));
          }

          // Main layout: list of books and upload button at the bottom
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

                // Upload Book button at the bottom
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to upload screen and pass current age group + format
                    Navigator.pushNamed(
                      context,
                      '/upload',
                      arguments: {
                        'ageGroup': '4-8',
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
