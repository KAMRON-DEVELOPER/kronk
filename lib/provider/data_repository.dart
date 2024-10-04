import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive/hive.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/note.dart';
import '../models/tab.dart';
import '../models/user.dart';
import '../models/users.dart';
import '../services/users_api.dart';
import '../widgets/custom_theme.dart';

class DataRepository {
  final AuthApiService authApiService;
  final Box<Users?> usersBox;
  final Box<Profile?> profileBox;
  final Box<MyTab?> tabsBox;
  final Box<Note?> notesBox;
  final Box settingsBox;
  Timer? _timer;

  DataRepository()
      : usersBox = Hive.box<Users>('usersBox'),
        profileBox = Hive.box<Profile>("profileBox"),
        tabsBox = Hive.box<MyTab>("tabsBox"),
        notesBox = Hive.box<Note>("notesBox"),
        settingsBox = Hive.box("settingsBox"),
        authApiService = AuthApiService() {_checkAuthPeriodically();}

  
  Future<List<Users?>> getUsers() async {
    print('💾🎉 getUsers');
    return usersBox.values.toList();
  }
  Future<bool> setUsers(List<Users?> newUsers) async {
    print('💾🎉 setUsers newUsers: $newUsers');
    try {
      await usersBox.clear();
      await usersBox.addAll(newUsers);
      return true;
    } catch (e) {
      print('💾🥶 catch setUsers: $e');
      return false;
    }
  }
  Future<bool> deleteUsers() async {
    print('💾🎉 clearUsers');
    try {
      await usersBox.clear();
      return true;
    } catch (e) {
      print('💾🥶 catch deleteUsers: $e');
      return false;
    }
  }

  
  Future<Profile?> getProfile() async {
    print('💾🎉 getProfile');
    return profileBox.get('profile');
  }
  Future<bool> setProfile(Profile? newProfile) async {
    print('💾🎉 setProfile profile: $newProfile');
    try {
      await profileBox.clear();
      await profileBox.put("profileData", newProfile);
      return true;
    } catch (e) {
      print('💾🥶 catch setProfile: $e');
      return false;
    }
  }
  Future<bool> updateProfile(Profile? updatedProfile) async {
    print('📝 updateProfile updatedProfile: $updatedProfile');
    try {
      Profile? oldProfile = await getProfile();
      Profile? newProfile = oldProfile?.forUpdate(updatedProfile);
      await setProfile(newProfile);
      return true;
    } catch (e) {
      print('🥶📝 catch updateProfile: $e');
      return false;
    }
  }
  Future<bool> deleteProfile() async {
    print('💾🎉 clearProfile');
    try {
      await profileBox.delete("profileData");
      return true;
    } catch (e) {
      print('💾🥶 catch clearProfile: $e');
      return false;
    }
  }
  

  Future<List<Note?>> getNotes() async {
    print('💾🎉 getNotes');
    return notesBox.values.toList();
  }
  Future<bool> setNotes(List<Note?> newNotes) async {
    print('💾🎉 setNotes notes: $newNotes');
    try {
      await notesBox.clear();
      await notesBox.addAll(newNotes);
      return true;
    } catch (e) {
      print('💾🥶 catch setNotes: $e');
      return false;
    }
  }
  Future<bool> updateNote(int index, Note? updatedNote) async {
    print('💾🎉 updateNote updatedNote: $updatedNote');
    try {
      Note? oldNote = notesBox.getAt(index);
      final Note? newNote = oldNote?.forUpdate(updatedNote);
      await notesBox.putAt(index, newNote);
      return true;
    } catch (e) {
      print('💾🥶 catch updateNote: $e');
      return false;
    }
  }
  Future<bool> addNote(Note? newNote) async {
    print('💾🎉 addNote note: $newNote');
    try {
      await notesBox.add(newNote);
      return true;
    } catch (e) {
      print('💾🥶 catch addNote: $e');
      return false;
    }
  }
  Future<bool> deleteNote(int index) async {
    print('💾🎉 deleteNote index: $index');
    try {
      await notesBox.deleteAt(index);
      return true;
    } catch (e) {
      print('💾🥶 catch deleteNote: $e');
      return false;
    }
  }
  Future<bool> clearNotes() async {
    print('💾🎉 clearNotes');
    try {
      await notesBox.clear();
      return true;
    } catch (e) {
      print('💾🥶 catch clearNotes: $e');
      return false;
    }
  }
  

  Future<List<MyTab?>> getTabs() async {
    print('💾🎉 getTabs');
    return tabsBox.values.toList();
  }
  Future<bool> setTabs(List<MyTab?> newTabs) async {
    print('💾🎉 setTabs newTabs: $newTabs');
    try {
      await tabsBox.clear();
      await tabsBox.addAll(newTabs);
      return true;
    } catch (e) {
      print('💾🥶 catch setTabs: $e');
      return false;
    }
  }
  Future<bool> updateTab(int index, MyTab? updatedTab) async {
    print('💾🎉 updateTab updatedTab: $updatedTab, index: $index');
    try {
      MyTab? oldTab = tabsBox.getAt(index);
      MyTab? newTab = oldTab?.forUpdate(updatedTab);
      await tabsBox.putAt(index, newTab);
      return true;
    } catch (e) {
      print('💾🥶 catch updateTab: $e');
      return false;
    }
  }
  Future<bool> addTab(MyTab? newTab) async {
    print('💾🎉 addTab newTab: $newTab');
    try {
      await tabsBox.add(newTab);
      return true;
    } catch (e) {
      print('💾🥶 catch addTab: $e');
      return false;
    }
  }
  Future<bool> deleteTab(int index) async {
    print('💾🎉 deleteTab index: $index');
    try {
      await tabsBox.deleteAt(index);
      return true;
    } catch (e) {
      print('💾🥶 catch deleteTab: $e');
      return false;
    }
  }
  Future<bool> clearTabs() async {
    print('💾🎉 clearTabs');
    try {
      await tabsBox.clear();
      return true;
    } catch (e) {
      print('💾🥶 catch clearTabs: $e');
      return false;
    }
  }


  Future<dynamic> getSettings(String key) async {
    print('💾🎉 getSettings key: $key');
    try {
      return await settingsBox.get(key);
    } catch (e) {
      print('💾🥶 catch getSettings: $e');
      return null;
    }
  }
  Future<bool> setSettings(String key, dynamic value) async {
    print('💾🎉 setSettings key: $key, value: $value');
    try {
      await settingsBox.put(key, value);
      return true;
    } catch (e) {
      print('💾🥶 catch setSettings: $e');
      return false;
    }
  }
  Future<bool> deleteSettings(String key) async {
    print('💾🎉 deleteSettings key: $key');
    try {
      await settingsBox.delete(key);
      return true;
    } catch (e) {
      print('💾🥶 catch deleteSettings: $e');
      return false;
    }
  }
  Future<bool> setSettingsAll(Map<String, dynamic> keysValues) async {
    print('💾🎉 setSettingsAll keysValues: $keysValues');
    try {
      await settingsBox.putAll(keysValues);
      return true;
    } catch (e) {
      print('💾🥶 catch setSettingsAll: $e');
      return false;
    }
  }


  Future<bool> cacheTemporaryUserToken(String token) async {
    print('💾🎉 cacheTemporaryUserToken token: $token');
    try {
      final DefaultCacheManager cache = DefaultCacheManager();

      await cache.putFile(
        'temporaryUserToken',
        utf8.encode(token),
        maxAge: const Duration(minutes: 5),
        fileExtension: 'txt',
      );
      return true;
    } catch (e) {
      print('💾🥶 catch cacheTemporaryUserToken: $e');
      return false;
    }
  }
  Future<String?> getTemporaryUserToken() async {
    print('💾🎉 getTemporaryUserToken');
    try {
      final DefaultCacheManager cache = DefaultCacheManager();

      final FileInfo? fileInfo = await cache.getFileFromCache('temporaryUserToken');
      if (fileInfo != null) {
        final String temporaryUserToken = await fileInfo.file.readAsString();
        return temporaryUserToken;
      }
      return null;
    } catch (e) {
      print('💾🥶 catch getTemporaryUserToken: $e');
      return null;
    }
  }


  Future<String?> getAccessToken() async {
    return await settingsBox.get("accessToken");
  }
  Future<String?> getRefreshToken() async {
    return await settingsBox.get("refreshToken");
  }
  Future<bool> getIsAuthenticated() async {
    print('💾🎉 getIsAuthenticated');
    try {
      return await _isAuthenticated();
    } catch (e) {
      print('🥶📝 catch getIsAuthenticated: $e');
      return false;
    }
  }

  Future<bool> getIsFetchedTabs() async {
    return await settingsBox.get("isFetchedTabs", defaultValue: false);
  }

  Future<bool> setIsFetchedTabs() async {
    try {
      await settingsBox.put("isFetchedTabs", true);
      return true;
    } catch (e) {
      print("catch setIsFetchedTabs ** $e");
      return false;
    }
  }

  Future<bool> getIsFetchedNotes() async {
    return await settingsBox.get("isFetchedNotes", defaultValue: false);
  }

  Future<bool> setIsFetchedNotes() async {
    try {
      await settingsBox.put("isFetchedNotes", true);
      return true;
    } catch (e) {
      print("catch setIsFetchedNotes ** $e");
      return false;
    }
  }

  String getCurrentThemeName() {
    return settingsBox.get('theme', defaultValue: 'dark');
  }

  MyTheme getCurrentTheme() {
    String themeName = getCurrentThemeName();
    MyTheme currentTheme = CustomTheme.themes[themeName] as MyTheme;
    return currentTheme;
  }




  Future<bool> _getIsExpiredAccess() async {
    String? token = await getAccessToken();
    return token == null ? true : JwtDecoder.isExpired(token);
  }

  Future<bool> _getIsExpiredRefresh() async {
    String? token = await getRefreshToken();
    return token == null ? true : JwtDecoder.isExpired(token);
  }

  Future<bool> _isAuthenticated() async {
    bool isExpiredAccess = await _getIsExpiredAccess();
    bool isExpiredRefresh = await _getIsExpiredRefresh();

    // TODO: move on from there.
    if (!isExpiredAccess) {
      await setSettings('isAuthenticated', true);
      return true;
    } else if (!isExpiredRefresh) {
      String? refresh = await getRefreshToken();
      Profile? tokens = await authApiService.fetchTokens(refreshToken: refresh);
      print('📝 _isAuthenticated tokens: $tokens');
      if (tokens != null) {
        await setSettingsAll(tokens.toMap());
        await setSettings('isAuthenticated', true);
        return true;
      }
    }

    await setSettings('isAuthenticated', false);
    return false;
  }


  Future<void> _checkAuthPeriodically() async {
    String? accessToken = await getAccessToken();
    if (accessToken != null) {
      Duration? timeLeft = JwtDecoder.getRemainingTime(accessToken);

      print('📝 _checkAuthPeriodically timeLeft: $timeLeft');

      _timer = Timer(timeLeft - const Duration(minutes: 1), () async {
        await _isAuthenticated();
        _checkAuthPeriodically();
      });
    }
  }


  void dispose() {
    _timer?.cancel();
  }
}
