import 'package:http/http.dart' as http;

import 'package:chat_app_provider/config/config.dart';
import 'package:chat_app_provider/presentation/models/models.dart';
import 'package:chat_app_provider/presentation/services/auth_service.dart';

class UsersListService {
  Future<List<User>> getUsers() async {
    try {
      final uri = Uri.parse('${Environments.apiUrl}/usuarios');
      String? token = await AuthService.getToken();
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': token.toString()
      });

      final usersListResponse = usersListResponseFromJson(response.body);

      return usersListResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
