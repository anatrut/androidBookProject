import 'package:flutter/material.dart';

// This screen allows the user to choose an age group and file format (PDF/DOCX)
// by clicking one of the 6 image-based buttons.
// Each button navigates to a corresponding book list screen for that age + format.

class AgeSelectionScreen extends StatelessWidget {
  const AgeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with the title centered
      appBar: AppBar(
        title: const Text("Choose your child’s age:"),
        centerTitle: true,
      ),

      // Page content with padding
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Row showing the Word and PDF icons above the buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // DOCX file format icon
                Image.asset(
                  'assets/icons/docx_icon.png',
                  height: 40,
                ),
                const SizedBox(width: 40),
                // PDF file format icon
                Image.asset(
                  'assets/icons/pdf_icon.png',
                  height: 40,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Grid view of all age+format combinations
            // 6 tiles: [0–4/docx], [0–4/pdf], [4–8/docx], etc.
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,       // 2 columns
                mainAxisSpacing: 16,     // space between rows
                crossAxisSpacing: 16,    // space between columns
                children: [
                  _ageTile(context, '0-4', 'docx', 'assets/images/age_0_4.png'),
                  _ageTile(context, '0-4', 'pdf',  'assets/images/age_0_4.png'),
                  _ageTile(context, '4-8', 'docx', 'assets/images/age_4_8.png'),
                  _ageTile(context, '4-8', 'pdf',  'assets/images/age_4_8.png'),
                  _ageTile(context, '8-12', 'docx','assets/images/age_8_12.png'),
                  _ageTile(context, '8-12', 'pdf', 'assets/images/age_8_12.png'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build a single tile for an age group + format
  Widget _ageTile(BuildContext context, String ageGroup, String format, String imagePath) {
    return GestureDetector(
      onTap: () {
        // Navigate to the books screen for this age group
        // We pass the file format (pdf/docx) as a navigation argument
        Navigator.pushNamed(
          context,
          '/books_${ageGroup.replaceAll('-', '_')}',
          arguments: format,
        );
      },
      child: Column(
        children: [
          // Image container with rounded corners and a light border
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,            // Show the image representing this age group
                  fit: BoxFit.contain,  // Keep full image visible without stretching
                  width: double.infinity,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Label showing the age group below the image
          Text(
            'Ages $ageGroup',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
