import 'package:dio/dio.dart';

import '../models/note.dart';
import '../models/tab.dart';

class NoteApiService {
  late Dio _dio;
  final String _baseUrl = 'http://192.168.31.42:8000/api/v1/';

  NoteApiService() {
    _dio = Dio();
  }

  Future<List<Note?>?> fetchNotes({required String? accessToken}) async {
    try {
      Response response = await _dio.get(
        '${_baseUrl}users/notes/',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );

      if (response.statusCode == 200) {
        print('RESPONSE IN fetchNotes: ${response.data}');
        List<dynamic> data = response.data;
        return data.map((noteJson) => Note.fromJson(noteJson)).toList();
      } else {
        print("ERROR IN fetchNotes");
        return null;
      }
    } catch (e) {
      print("ERROR IN fetchNotes: $e");
      return null;
    }
  }

  Future<Note?> fetchCreateNote(
      {required String? accessToken, required Note? note}) async {
    try {
      Response response = await _dio.post(
        '${_baseUrl}users/notes/',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
        data: note?.toJson(),
      );
      print("RESPONSE IN fetchCreateNote: ${response.data}");
      if (response.statusCode == 201) {
        return Note.fromJson(response.data);
      } else {
        print("ERROR IN fetchCreateNote");
        return null;
      }
    } catch (e) {
      print("ERROR IN fetchCreateNote: $e");
      return null;
    }
  }

  Future<bool> fetchUpdateNote(
      {required String? accessToken,
      required String? id,
      required Note? note}) async {
    try {
      Response response = await _dio.put(
        '${_baseUrl}users/notes/',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
        data: {"id": id, "data": note?.toJson()},
      );
      print("response in fetchUpdateNote: ${response.statusCode}");
      if (response.statusCode == 200) {
        return true;
      } else {
        print("error in fetchDeleteNote");
        return false;
      }
    } catch (e) {
      print("error in fetchDeleteNote: $e");
      return false;
    }
  }

  Future<bool> fetchDeleteNote(
      {required String? accessToken, required String? id}) async {
    try {
      Response response = await _dio.post(
        '${_baseUrl}users/notes/',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
        data: {"id": id},
      );
      print("RESPONSE IN fetchDeleteNote: ${response.statusCode}");
      if (response.statusCode == 204) {
        return true;
      } else {
        print("ERROR IN fetchDeleteNote");
        return false;
      }
    } catch (e) {
      print("ERROR IN fetchDeleteNote: $e");
      return true;
    }
  }

  Future<List<MyTab?>?> fetchTabs({required String? accessToken}) async {
    try {
      Response response = await _dio.get(
        '${_baseUrl}users/tabs/',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );

      if (response.statusCode == 200) {
        print('RESPONSE IN fetchTabs: ${response.data}');
        List<dynamic> data = response.data;
        return data.map((noteJson) => MyTab.fromJson(noteJson)).toList();
      } else {
        print("ERROR IN fetchTabs");
        return null;
      }
    } catch (e) {
      print("ERROR IN fetchTabs: $e");
      return null;
    }
  }

  Future<MyTab?> fetchCreateTab(
      {required String? accessToken, required MyTab newTabData}) async {
    try {
      Response response = await _dio.post(
        '${_baseUrl}users/tabs/',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
        data: {"data": newTabData.toJson()},
      );
      print("RESPONSE IN fetchCreateTab: ${response.data}");
      if (response.statusCode == 201) {
        return MyTab.fromJson(response.data);
      } else {
        print("error in fetchCreateTab");
        return null;
      }
    } catch (e) {
      print("error in fetchCreateTab: $e");
      return null;
    }
  }

  Future<bool> fetchUpdateTab(
      {required String? accessToken,
      required String? id,
      required MyTab? updateTabData}) async {
    try {
      Response response = await _dio.put(
        '${_baseUrl}users/tabs/',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
        data: {"id": id, "data": updateTabData?.toJson()},
      );
      print("response in fetchUpdateTab: ${response.statusCode}");
      if (response.statusCode == 200) {
        return true;
      } else {
        print("ERROR IN fetchUpdateTab");
        return false;
      }
    } catch (e) {
      print("ERROR IN fetchUpdateTab: $e");
      return false;
    }
  }

  Future<bool> fetchDeleteTab(
      {required String? accessToken, required String? id}) async {
    try {
      Response response = await _dio.post(
        '${_baseUrl}users/tabs/',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
        data: {"id": id},
      );
      print("response in fetchDeleteTab: ${response.statusCode}");
      if (response.statusCode == 204) {
        return true;
      } else {
        print("error in fetchDeleteTab");
        return false;
      }
    } catch (e) {
      print('error in fetchDeleteTab: $e');
      return true;
    }
  }
}
