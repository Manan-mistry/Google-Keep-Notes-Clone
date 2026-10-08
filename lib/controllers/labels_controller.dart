import 'package:keeps_note_clone/data/local/database_manager.dart';
import 'package:keeps_note_clone/data/models/label_model.dart';
import 'package:keeps_note_clone/data/models/notes_model.dart';
import 'package:keeps_note_clone/data/remote/api_error.dart';
import 'package:keeps_note_clone/data/remote/api_response.dart';
import 'package:keeps_note_clone/data/repositories/notes_repository.dart';
import 'package:keeps_note_clone/utils/log_print.dart';
import 'package:state_extended/state_extended.dart';

class LabelsController extends StateXController {
  final NotesRepository notesRepo = NotesRepository();
  final DatabaseManager databaseManager = DatabaseManager();

  bool isApiCalled = false;
  bool isLoading = true;

  // List of arrays of notes to maintain state across different screens
  List<List<Note>> notesArray = <List<Note>>[];
  List<Label> labelsArray = [];

  // Index to track the current screen's notes array
  int currentScreenIndex = 0;

  // Function to get the notes for the current screen
  List<Note> get currentNotes => notesArray.isNotEmpty ? notesArray[currentScreenIndex] : <Note>[];

  Future<int> insertLabel(Label label) async {
    return await databaseManager.insertLabel(label);
  }

  Future<int> updateLabel(Label label) async {
    return await databaseManager.updateLabel(label);
  }

  Future<List<Label>> fetchLabelsFromDB() async {
    labelsArray = await databaseManager.getLabelsFromDB();
    return labelsArray;
  }

  Future<int> deleteLabel(Label label) async {
    return await databaseManager.deleteLabel(label);
  }
}
