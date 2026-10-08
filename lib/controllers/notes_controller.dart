import 'package:keeps_note_clone/data/local/database_manager.dart';
import 'package:keeps_note_clone/data/models/label_model.dart';
import 'package:keeps_note_clone/data/models/notes_model.dart';
import 'package:keeps_note_clone/data/remote/api_error.dart';
import 'package:keeps_note_clone/data/remote/api_response.dart';
import 'package:keeps_note_clone/data/repositories/notes_repository.dart';
import 'package:keeps_note_clone/utils/log_print.dart';
import 'package:sqflite/sqflite.dart';
import 'package:state_extended/state_extended.dart';

class NotesController extends StateXController {
  final NotesRepository notesRepo = NotesRepository();
  final DatabaseManager databaseManager = DatabaseManager();

  bool isApiCalled = false;
  bool isLoading = true;

  // List of arrays of notes to maintain state across different screens
  List<Note> notesArray = [];

  // Index to track the current screen's notes array
  int currentScreenIndex = 0;

  // Function to get the notes for the current screen

  // Function to initialize the notes array for a new screen
  void initNotesForScreen() {
    currentScreenIndex = notesArray.length - 1;
  }

  Future<void> getNotes() async {
    setState(() {
      isLoading = true;
    });

    // await notesRepo.getNotes('10').then((value) {
    //   if (value is ApiResponse) {
    //     setState(() {
    //       isLoading = false;
    //       notesArray[currentScreenIndex] = (value).response;
    //     });
    //     return;
    //   } else if (value is ApiError) {
    //     setState(() {
    //       isLoading = false;
    //     });
    //     print('Something Went Wrong.');
    //   }
    // });
  }

  Future<bool> addNote(String title, String notes) async {
    setState(() {
      isLoading = true;
    });

    // final response = await notesRepo.addNote(title, notes, DateTime.now());

    // if (response is ApiResponse) {
    //   setState(() {
    //     isLoading = false;
    //     var responseNote = response.response as Note;
    //     var newNoteAdded = Note(
    //       id: currentNotes.length + 1,
    //       title: responseNote.title,
    //       note: responseNote.note,
    //       createdDate: responseNote.createdDate,
    //     );
    //     currentNotes.add(newNoteAdded); // Update the notes list or state
    //   });
    //   return true;
    // } else if (response is ApiError) {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   print('Something went wrong ~ show Snackbar');
    //   return false;
    // } else {
      setState(() {
        isLoading = false;
      });
      logPrint('Unexpected response');
      return false;
    // }
  }

  Future<int> insertNoteInDB(Note note) async {
    var success = await databaseManager.insertNote(note);
    if (success == 1) {
      var notes = await databaseManager.getNotesFromDB();
      setState(() {
        notesArray = notes;
      });
    }
    return success;
  }

  Future<int> updateNoteInDB(Note note) async {
    var success = await databaseManager.updateNote(note);
    if (success == 1) {
      var notes = await databaseManager.getNotesFromDB();
      setState(() {
        notesArray = notes;
      });
    }
    return success;
  }

  Future<List<Note>> fetchNotesFromDB() async {
    var notes = await databaseManager.getNotesFromDB();
    setState((){
      notesArray = notes;
    });
    return notes;
  }

  Future<int> deleteNoteInDB(Note note) async {
    return await databaseManager.deleteNote(note);
  }

  Future<int> deleteLabelsByNoteId(Note note) async {
    return await databaseManager.deleteLabelForNote(note);
  }

  Future<int> insertLabelsForNote(Note note, Label label) async {
    var success = await databaseManager.insertLabelsForNotes(label, note);
    return success;
  }

  Future<List<Label>> fetchLabelsForNote(Note note) async {
    return await databaseManager.fetchLabelsForNotes(note);
  }

  Future<int> archiveNote(Note note) async {
    return await databaseManager.archivedNote(note);
  }

  Future<int> unarchiveNote(Note note) async {
    return await databaseManager.unarchivedNote(note);
  }

  Future<Note> fetchNoteById(Note note) async {
    return await databaseManager.getNoteById(note) ?? Note();
  }
}
