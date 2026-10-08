import 'dart:core';
import 'dart:io';
import 'package:keeps_note_clone/data/models/label_model.dart';
import 'package:keeps_note_clone/data/models/notes_model.dart';
import 'package:keeps_note_clone/utils/log_print.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseManager {

  static final DatabaseManager _databaseManager = DatabaseManager._internal();

  factory DatabaseManager() => _databaseManager;

  DatabaseManager._internal();

  static String tblNotes = 'notes';
  static String tblLabels = 'labels';
  static String tblNotesLabels = 'note_labels';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _openMyDatabase();
    return _database!;
  }

  Future<Database> _openMyDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'demo_database.db');
    logPrint('Database Path - $path');

    final exist = await databaseExists(path);
    if (!exist) {
      try {
        await Directory(p.dirname(path)).create(recursive: true);
      } catch (e) {
        logPrint(e.toString());
      }

      ByteData data = await rootBundle.load(
          p.join("assets/database", "demo_database.db"));
      List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path, version: 1, readOnly: false);
  }

  Future<int> insertNote(Note note) async {
    final db = await _databaseManager.database;
    return await db.insert(
        tblNotes, note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateNote(Note note) async {
    final db = await _databaseManager.database;
    return await db.update(
        tblNotes, note.toMap(), where: 'note_id = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(Note note) async {
    final db = await _databaseManager.database;
    return await db.delete(tblNotes, where: 'id = ?', whereArgs: [note.id]);
  }

  Future<List<Note>> getNotesFromDB() async {
    final db = await _databaseManager.database;
    final List<Map<String, dynamic>> maps = await db.query(
        tblNotes, orderBy: 'created_at DESC', where: "is_archived != ?", whereArgs: [1]);

    return List.generate(maps.length, (index) => Note.fromMap(maps[index]));
  }

  Future<int> insertLabel(Label label) async {
    final db = await _databaseManager.database;
    return await db.insert(
        tblLabels, label.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateLabel(Label label) async {
    final db = await _databaseManager.database;
    return await db.update(
        tblLabels, label.toMap(), where: 'label_id = ?', whereArgs: [label.id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteLabel(Label label) async {
    final db = await _databaseManager.database;
    return await db.delete(tblLabels, where: 'label_id = ?', whereArgs: [label.id]);
  }

  Future<Note?> getNoteById(Note note) async {
    final db = await _databaseManager.database;

    // db.query still returns a List<Map<String, dynamic>>, but we handle one result
    final List<Map<String, dynamic>> maps = await db.query(
        tblNotes,
        where: "note_id = ?",
        whereArgs: [note.id]
    );

    // If the query returns no results, return null
    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    } else {
      return null; // No result found
    }
  }


  Future<List<Label>> getLabelsFromDB() async {
    final db = await _databaseManager.database;
    final List<Map<String, dynamic>> maps = await db.query(
        tblLabels, orderBy: 'created_at DESC');

    return List.generate(maps.length, (index) => Label.fromMap(maps[index]));
  }

  Future<int> insertLabelsForNotes(Label label, Note note) async {
    final db = await _databaseManager.database;
    return await db.insert(
        tblNotesLabels,
        {
          'note_id': note.id,
          'label_id': label.id
        },
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<Label>> fetchLabelsForNotes(Note note) async {
    final db = await _databaseManager.database;

    // Fetch label_ids from note_labels table for the given note
    List<Map<String, dynamic>> labelIdsResult = await db.query(
      tblNotesLabels,
      columns: ['label_id'],
      where: 'note_id = ?',
      whereArgs: [note.id],
    );

    if (labelIdsResult.isEmpty) {
      return []; // No labels found, return an empty list
    }

    List<int> labelIds = labelIdsResult.map((row) => row['label_id'] as int).toList();

    List<Map<String, dynamic>> labelsResult = await db.query(
      tblLabels, // Assuming 'tblLabels' is the name of your labels table
      where: 'label_id IN (${List.filled(labelIds.length, '?').join(', ')})',
      whereArgs: labelIds,
    );

    List<Label> labels = labelsResult.map((labelData) => Label.fromMap(labelData)).toList();

    return labels; // Return the list of labels
  }

  Future<int> deleteLabelForNote(Note note) async {
    final db = await _databaseManager.database;
    return await db.delete(tblNotesLabels, where: 'note_id = ?', whereArgs: [note.id]);
  }

  Future<int> archivedNote(Note note) async {
    final db = await _databaseManager.database;
    return await db.update(tblNotes, {'is_archived' : 1}, where: 'note_id = ?', whereArgs: [note.id]);
  }

  Future<int> unarchivedNote(Note note) async {
    final db = await _databaseManager.database;
    return await db.update(tblNotes, {'is_archived' : 0}, where: 'note_id = ?', whereArgs: [note.id]);
  }

  Future<void> closeDB() async {
    final db = await _databaseManager.database;
    db.close();
  }
}