import 'package:keeps_note_clone/utils/log_print.dart';

class Note {
  int? id;
  String title = "";
  String note = "";
  DateTime createdDate = DateTime.now();

  Note({
    this.id,
    this.title = '',
    this.note = '',
    DateTime? createdDate,
  }) : createdDate = createdDate ?? DateTime.now();

  // Method to convert a Note to JSON
  Map<String, dynamic> toMap() {
    return {
      'note_id': id,
      'title': title,
      'content': note,
      'created_at': createdDate.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String()
    };
  }


  // Optional: Override toString for easier debugging
  @override
  String toString() {
    return 'Note { id: $id, title: $title, note: $note, createdDate: $createdDate}';
  }

  Note.fromMap(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['note_id'] ?? 0; // Direct assignment with fallback to 0
      title = jsonMap['title'] ?? "";
      note = jsonMap['content'] ?? "";
      createdDate = jsonMap['created_at'] != null
          ? DateTime.parse(jsonMap['created_at'])
          : DateTime.now(); // Properly parse the date if it's a String
    } catch (e) {
      logPrint(e);
    }
  }
}