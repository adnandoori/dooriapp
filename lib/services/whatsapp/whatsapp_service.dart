import 'dart:convert';
import 'package:http/http.dart' as http;

class AisensyService {
  final String apiUrl = 'https://api.aisensy.com';
  final String apiKey = 'YOUR_API_KEY';

  Future<void> sendWhatsAppMessage(String phoneNumber, String message) async {
    final response = await http.post(
      Uri.parse('$apiUrl/send_message'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'phone_number': phoneNumber,
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      print('Message sent successfully!');
    } else {
      print('Failed to send message. Error: ${response.body}');
    }
  }
}
