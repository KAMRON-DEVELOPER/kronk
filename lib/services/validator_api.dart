import 'package:dio/dio.dart';

import '../models/users.dart';
import '../provider/data_repository.dart';

class ValidateApiService {
  late Dio _dio;
  late DataRepository dataRepository;
  final String _baseUrl = 'http://192.168.31.42:8000/api/v1/users';

  ValidateApiService() {
    _dio = Dio();
    dataRepository = DataRepository();
    fetchAndStoreUsersData();
  }

  Future<void> fetchAndStoreUsersData() async {
    try {
      Response response = await _dio.get('$_baseUrl/all/');
      print('RESPONSE IN fetchAndStoreUserData: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        List<Users?> users = data.map((user) => Users.toUsers(user)).toList();
        await dataRepository.clearUsers();
        await dataRepository.setUsers(users);
      } else {
        print('🥶 ERROR IN fetchAndStoreUserData');
      }
    } catch (e) {
      print("🥶 ERROR IN fetchAndStoreUserData: $e");
    }
  }
}
