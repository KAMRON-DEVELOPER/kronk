import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthApiService {
  final Dio _dio;
  final String _usersUrl = 'http://192.168.31.42:8000/api/v1/users';

  AuthApiService() : _dio = Dio();

  
  // TODO: registration
  Future<Profile?> fetchRegister({required Profile registerData}) async {
    try {
      Response response = await _dio.post(
        '$_usersUrl/register/',
        data: registerData.toJsonForRegister(),
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 201) {
        print('response in fetchRegister: ${response.data.toString()}');
        return Profile.fromJsonToToken(response.data);
      } else {
        print('Failed in fetchRegister: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error in fetchRegister: ${error.toString()}');
      return null;
    }
  }

  // TODO: verification
  Future<Profile?> fetchVerify(
      {required Profile verifyData, required String? accessToken}) async {
    try {
      Response response = await _dio.post(
        '$_usersUrl/verify/',
        data: verifyData.toJsonForVerify(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );

      if (response.statusCode == 200) {
        print('response status code is 200 ok');
        return Profile.fromJsonToToken(response.data);
      } else {
        print('Failed in fetchVerify >> ${response.statusCode}');
        print('Failed in fetchVerify >> ${response.data.toString()}');
        return null;
      }
    } catch (error) {
      print('Error in fetchVerify >> ${error.toString()}');
      return null;
    }
  }

  // TODO: login
  Future<Profile?> fetchLogin({required Profile loginData}) async {
    try {
      Response response = await _dio.post(
        '$_usersUrl/login/',
        data: loginData.toJsonForLogin(),
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 200) {
        print('response in fetchLogin: ${response.data.toString()}');
        return Profile.fromJsonToToken(response.data);
      } else {
        print('Failed in fetchLogin: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error in fetchLogin: ${error.toString()}');
      return null;
    }
  }

  // TODO: fetch user profile
  Future<Profile?> fetchUserProfile({required String? accessToken}) async {
    try {
      Response response = await _dio.get(
        '$_usersUrl/profile/',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );
      if (response.statusCode == 200) {
        print('response in fetchUserProfile: ${response.data.toString()}');
        return Profile.fromJson(response.data);
      } else {
        print('Failed in fetchUserProfile: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error in fetchUserProfile: ${error.toString()}');
      return null;
    }
  }

  // TODO: update user profile
  Future<bool> fetchUpdateUserProfile(
      {required String? accessToken, required Profile? updateData}) async {
    try {
      Response response = await _dio.put(
        '$_usersUrl/profile/',
        data: updateData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );
      if (response.statusCode == 200) {
        print('response in fetchUpdateUserProfile: ${response.statusCode}');
        return true;
      } else {
        print('failed in fetchUserProfile: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('error in fetchUserProfile: ${e.toString()}');
      return false;
    }
  }

  // TODO: fetch new access and refresh token
  Future<Profile?> fetchTokens({required String? refreshToken}) async {
    try {
      Response response = await _dio.post(
        '$_usersUrl/token/refresh/',
        data: {"refresh": refreshToken},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        print('response in fetchToken: ${response.data.toString()}');
        return Profile.fromJsonToToken(response.data);
      } else {
        print('Failed in fetchToken: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error in fetchToken: ${error.toString()}');
      return null;
    }
  }

  // TODO: fetch banner
  Future<MemoryImage?> fetchBanner({required String imageUrl}) async {
    try {
      final response = await _dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        final bytes = await response.data;
        final image = MemoryImage(bytes);
        return image;
      } else {
        null;
      }
    } catch (e) {
      print('Failed to load image: $e');
      return null;
    }
    return null;
  }

  // TODO: fetch google sign in
  Future<bool> fetchGoogleSignIn({required String? firebaseUserIdToken}) async {
    try {
      Response response = await _dio.post(
        '$_usersUrl/firebase-social-auth/',
        data: {"firebase_id_token": firebaseUserIdToken},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 200) {
        print('response in fetchLogin: ${response.data.toString()}');
        return true;
      } else {
        print('Failed in fetchLogin: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error in fetchLogin: ${error.toString()}');
      return false;
    }
  }
}
