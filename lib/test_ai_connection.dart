import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const apiKey = 'AIzaSyCY3N6b8Z1Avo6i_4s1stwiDIhg6faZiBw';

  final uri = Uri.parse(
    'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$apiKey',
  );

  final headers = {'Content-Type': 'application/json'};

  final body = jsonEncode({
    "contents": [
      {
        "parts": [
          {
            "text": """
Zamień poniższy tekst zamówienia na listę produktów w formacie JSON:
[
  { "name": "iPhone 9", "quantity": 2 },
  { "name": "Samsung Universe 9", "quantity": 1 },
  { "name": "Apple AirPods", "quantity": 3 }
]

Tekst: „Poproszę 2x iPhone 9 oraz 1x Samsung Universe 9. Dodatkowo 3 sztuki Apple AirPods.”
""",
          },
        ],
      },
    ],
  });

  try {
    final response = await http.post(uri, headers: headers, body: body);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final content = decoded['candidates'][0]['content']['parts'][0]['text'];
      print('✅ Odpowiedź Gemini:\n$content');
    } else {
      print('❌ Błąd API: ${response.statusCode}\n${response.body}');
    }
  } catch (e) {
    print('❌ Błąd połączenia: $e');
  }
}
