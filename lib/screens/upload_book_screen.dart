// Import Flutter widgets and material design components
import 'package:flutter/material.dart';

// Import Firebase service for uploading book info
import '../services/firebase_service.dart';

// This screen lets the user/admin upload a book URL and title for a specific age group
class UploadBookScreen extends StatefulWidget {
  const UploadBookScreen({super.key}); // Constructor

  @override
  State<UploadBookScreen> createState() => _UploadBookScreenState();
}

// The internal state of the screen
class _UploadBookScreenState extends State<UploadBookScreen> {
  // A key used to validate the form inputs
  final _formKey = GlobalKey<FormState>();

  // Default values for the form inputs
  String ageGroup = '0-4'; // Dropdown default
  String title = '';       // Book title
  String url = '';         // GitHub/Download URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The app bar at the top of the screen
      appBar: AppBar(title: const Text('Upload Book')),

      // Main content area with padding
      body: Padding(
        padding: const EdgeInsets.all(16),

        // Form widget manages form validation
        child: Form(
          key: _formKey,

          // Column displays form elements vertically
          child: Column(
            children: [
              // Dropdown to select age group (0-4, 4-8, 8-12)
              DropdownButtonFormField(
                value: ageGroup, // default value
                items: ['0-4', '4-8', '8-12']
                    .map((age) => DropdownMenuItem(
                          value: age,
                          child: Text('Ages $age'), // Label shown to user
                        ))
                    .toList(),
                onChanged: (value) => setState(() => ageGroup = value!), // Update state
                decoration: const InputDecoration(labelText: 'Age Group'),
              ),

              // Input field for the book title
              TextFormField(
                decoration: const InputDecoration(labelText: 'Book Title'),
                onChanged: (val) => title = val, // Store value in state
              ),

              // Input field for the book URL (e.g. GitHub PDF link)
              TextFormField(
                decoration: const InputDecoration(labelText: 'GitHub URL'),
                onChanged: (val) => url = val,
              ),

              // Add vertical spacing before the button
              const SizedBox(height: 20),

              // Submit button to upload book data
              ElevatedButton(
                onPressed: () async {
                  // If the form is valid, send data to Firebase
                  if (_formKey.currentState!.validate()) {
                    await FirebaseService.uploadBook(ageGroup, title, url);

                    // Show a confirmation message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Book uploaded!')),
                    );
                  }
                },
                child: const Text('Upload'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
