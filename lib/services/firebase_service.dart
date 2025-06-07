// Import Firebase Firestore SDK for cloud database access
import 'package:cloud_firestore/cloud_firestore.dart';

// Service class to manage interactions with Firebase Firestore
class FirebaseService {
  // Private static instance of Firestore database
  static final _db = FirebaseFirestore.instance;

  /// Get a map of book titles and their download links
  /// based on age group (e.g. "0-4") and file format ("pdf" or "docx")
  ///
  /// Returns: Map<String, String> → { "BookTitle.format": "https://..." }
  static Future<Map<String, String>> getBooksByAgeGroup(String ageGroup, String format) async {
    // Try to fetch the document under the 'download_links' collection
    // For example: download_links → doc ID: "0-4"
    final doc = await _db.collection('download_links').doc(ageGroup).get();

    // Convert the document fields to a String map (title → URL)
    // If the document doesn't exist, return an empty map
    final data = Map<String, String>.from(doc.data() ?? {});

    // Filter the entries to include only those ending in .pdf or .docx
    // This assumes field names look like "Book Title.pdf" or "Book Title.docx"
    return Map.fromEntries(
      data.entries.where((e) => e.key.toLowerCase().endsWith(format.toLowerCase()))
    );
  }

  /// Upload or update a single book for a given age group
  ///
  /// - `ageGroup`: age group like "0-4"
  /// - `title`: full title with extension, e.g., "My Story.docx"
  /// - `url`: download URL to be stored
  ///
  /// This merges the new book into the document without overwriting others.
  static Future<void> uploadBook(String ageGroup, String title, String url) async {
    await _db
        .collection('download_links')      // Go to collection "download_links"
        .doc(ageGroup)                     // Select the document for the age group
        .set({title: url}, SetOptions(merge: true)); // Merge new field without deleting others
  }
}
