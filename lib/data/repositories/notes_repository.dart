
import 'dart:convert';
import 'package:keeps_note_clone/data/models/notes_model.dart';
import 'package:keeps_note_clone/data/remote/api_error.dart';
import 'package:keeps_note_clone/data/remote/api_response.dart';
import 'package:keeps_note_clone/utils/app_url.dart';
import 'package:keeps_note_clone/utils/helper.dart';
import 'package:http/http.dart' as http;

class NotesRepository {

  Future<Object> getNotes(String limit) async {
    Map<String, dynamic> params = {
      'limit': limit
    };

    final String url = AppUrl.getNotes;

    final client = http.Client();

    final uri = Uri.parse(url).replace(queryParameters: params);
    final response = await client.get(
      uri,
      headers: await Helper.getHeaders(),
    );

    if (response.statusCode == AppUrl.successStatusCode) {
      if (json.decode(response.body) != null) {
        final jsonObj = json.decode(response.body);
        List<dynamic> jsonArray = jsonObj['data'] as List<dynamic>;
        List<Note> note = jsonArray.map((noteMap) => Note.fromMap(noteMap)).toList();
        return ApiResponse(note, json.decode(response.body)['message'] as String, true);
      } else {
        return ApiError(null, 'Something Went Wrong', response.statusCode);
      }
    } else if (response.statusCode == AppUrl.parsingErrorStatusCode) {
      return ApiError(null, 'Parsing Error', response.statusCode);
    }
    else if (response.statusCode == AppUrl.validationErrorStatusCode) {
      return ApiError(null, 'Validation Error', response.statusCode);
    } else {
      return ApiError(null, 'Something Went Wrong', response.statusCode);
    }
  }

  Future<Object> addNote(String title, String notes, DateTime createdDateTime) async {

    final String url = AppUrl.addNote;
    final client = http.Client();

    final response = await client.post(
        Uri.parse(url),
        headers: await Helper.getHeaders(),
        body: {
          "title": title,
          "notes": notes,
          "createdDateTime": createdDateTime.toIso8601String()
        }
    );

    if (response.statusCode == AppUrl.successStatusCode) {
      if (json.decode(response.body) != null) {
        final objJsonObject = json.decode(response.body);
        Note note = Note.fromMap(objJsonObject['data']);
        return ApiResponse(note, json.decode(response.body)['message'] as String, true);
      } else {
        return ApiError(null, 'Something Went Wrong', response.statusCode);
      }
    } else {
      return ApiError(null, 'Something Went Wrong', response.statusCode);
    }
  }
}