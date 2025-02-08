import 'dart:convert';
import 'package:http/http.dart' as http;

class AisensyService {
  final String apiUrl = 'https://wa.me/15557043242';
  final String apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2NTVjMTdhYzE1ODdmMjA4NDUyNTRiNSIsIm5hbWUiOiJEb29yaSBIZWFsdGgiLCJhcHBOYW1lIjoiQWlTZW5zeSIsImNsaWVudElkIjoiNjY1NWMxN2FjMTU4N2YyMDg0NTI1NDljIiwiYWN0aXZlUGxhbiI6IkJBU0lDX01PTlRITFkiLCJpYXQiOjE3MTY4OTYxMjJ9.Emz0OHCRWq3suqa0C6GHAR94NvLafflFdXaEYySGPwU';

  Future<void> sendWhatsAppMessage(String phoneNumber, String message) async {
    final response = await http
        .post(
          Uri.parse('$apiUrl/send_message'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            'phone_number': 15557043242,
            'message': message,
          }),
        )
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      print('Message sent successfully!');
    } else {
      print('Failed to send message. Error: ${response.body}');
    }
  }
}
