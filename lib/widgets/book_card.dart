// Import Flutter Material UI package for widgets like Card, ListTile, Icons, etc.
import 'package:flutter/material.dart';

// Import url_launcher package to open URLs (for downloading files externally)
import 'package:url_launcher/url_launcher.dart';

/// Widget that displays a single book item as a card with a download button
class BookCard extends StatelessWidget {
  // Book title (e.g., "The Magical Cat.pdf")
  final String title;

  // URL to the downloadable file (hosted on GitHub or Firebase)
  final String url;

  // Constructor requires title and url as named parameters
  const BookCard({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8), // Margin between cards
      child: ListTile(
        title: Text(title), // Show the book title as the main text in the tile

        // Show a download button to the right
        trailing: IconButton(
          icon: const Icon(Icons.download), // Standard Material download icon

          // When the download icon is pressed
          onPressed: () async {
            // Print the URL to console (for debugging)
            debugPrint("Launching: $url");

            // Try to safely parse the string to a URI object
            final uri = Uri.tryParse(url);

            // Validate that:
            // 1. URI exists
            // 2. URI has an absolute path (not a relative one)
            // 3. URI uses HTTPS (secure)
            if (uri == null || !uri.hasAbsolutePath || !uri.isScheme("https")) {
              debugPrint("Invalid or insecure URL: $url");

              // Show a SnackBar with an error message to the user
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Invalid URL or unsupported format")),
              );
              return;
            }

            // Try to launch the URL in an external browser or app
            try {
              final launched = await launchUrl(
                uri,
                mode: LaunchMode.externalApplication, // Open in browser or external app
              );

              // If failed to launch, show an error
              if (!launched) {
                debugPrint("Could not launch: $uri");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Could not open the file.")),
                );
              }

            } catch (e) {
              // Catch and log any runtime errors (like malformed URL, permissions, etc.)
              debugPrint("Exception launching URL: $e");

              // Show error message in a SnackBar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${e.toString()}")),
              );
            }
          },
        ),
      ),
    );
  }
}
