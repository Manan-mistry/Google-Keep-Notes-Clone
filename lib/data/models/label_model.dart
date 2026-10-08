import 'package:keeps_note_clone/utils/log_print.dart';

class Label {
  int? id;
  String title = "";
  DateTime createdDate = DateTime.now();

  Label({
    this.id,
    this.title = 'Untitled',
    DateTime? createdDate,
  }) : createdDate = createdDate ?? DateTime.now();

  // Method to convert a Note to JSON
  Map<String, dynamic> toMap() {
    return {
      'label_id': id,
      'name': title,
      'created_at': createdDate.toIso8601String(),
    };
  }


  // Optional: Override toString for easier debugging
  @override
  String toString() {
    return 'Note { id: $id, title: $title, createdDate: $createdDate}';
  }

  Label.fromMap(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['label_id'] ?? 0; // Direct assignment with fallback to 0
      title = jsonMap['name'] ?? "";
      createdDate = jsonMap['created_at'] != null
          ? DateTime.parse(jsonMap['created_at'])
          : DateTime.now(); // Properly parse the date if it's a String
    } catch (e) {
      logPrint(e);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Label) return false;

    return other.id == id && other.title == title;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}