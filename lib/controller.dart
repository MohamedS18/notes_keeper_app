import 'dart:convert';
import 'package:http/http.dart' as http;
import 'states.dart';

class Controller {
  static const String baseUrl =
      "https://notes-keeper-backend-sigma.vercel.app/notes";

  static Future<bool> signUp(String username, String password) async {
    final Uri url = Uri.parse("$baseUrl/signup");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      if (response.statusCode == 200) {
        States.setIsLogged(true);
        return true;
      }
    } catch (e) {
      print("error: $e");
    }
    return false;
  }

  static Future<bool> login(String username, String password) async {
    final Uri url = Uri.parse("$baseUrl/login");
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      if (response.statusCode == 200) {
        States.setIsLogged(true);
        return true;
      }
    } catch (e) {
      print("error: $e");
    }
    return false;
  }

  static Future<List<Map<String, dynamic>>> getNotes(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getData?username=$username'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Map<String, dynamic>> res =
            (data.map((e) {
              return {
                "id": e["_id"],
                "title": e["title"],
                "content": e["content"],
                "lastUpdated":
                    DateTime.tryParse(e["lastUpdated"] ?? "")?.toLocal() ??
                    DateTime.now(),
              };
            }).toList());
        return res;
      } else {
        throw Exception("Failed to fetch notes: ${response.body}");
      }
    } catch (e) {
      print("Error fetching notes: $e");
      return [];
    }
  }

  static Future<bool> addNote(
    String username,
    title,
    String description,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/insert"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "title": title,
          "content": description,
          "lastUpdated": DateTime.now().toUtc().toIso8601String(),
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error inserting notes: $e");
    }
    return false;
  }

  static Future<bool> deleteNote(String username, String id) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/delete"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "note_id": id}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error deleting notes: $e");
    }
    return false;
  }
}
