import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app_provider/config/config.dart';
import 'package:chat_app_provider/presentation/models/models.dart';
import 'package:chat_app_provider/presentation/services/services.dart';

class ChatService with ChangeNotifier {
  // Usuario al que se desea enviar los mensajes
  User? userReceiving;

  Future<List<Message>> getChats(String userId) async {
    // Obtener el Token
    String? token = await AuthService.getToken();

    final uri = Uri.parse('${Environments.apiUrl}/messages/$userId');
    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': token.toString()
    });

    final messagesResponse = messagesResponseFromJson(response.body);

    return messagesResponse.messages;
  }
}
