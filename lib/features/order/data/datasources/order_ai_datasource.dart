import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_item_model.dart';

class OrderAiDatasource {
  final String apiKey;
  OrderAiDatasource(this.apiKey);
  Future<List<OrderItemModel>> analyzeOrder(
    String inputText,
    List<String> productTitles,
  ) async {
    if (productTitles.isEmpty) {
      throw Exception('Product list is empty – cannot analyze order.');
    }

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$apiKey',
    );

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "contents": [
              {
                "parts": [
                  {"text": _buildPrompt(inputText, productTitles)},
                ],
              },
            ],
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('AI error: ${response.statusCode}\n${response.body}');
    }

    final decoded = jsonDecode(response.body);
    final candidates = decoded['candidates'];
    if (candidates is! List || candidates.isEmpty) {
      throw Exception('AI returned no candidates.');
    }

    final parts = candidates.first['content']?['parts'];
    if (parts is! List || parts.isEmpty) {
      throw Exception('AI returned no text parts.');
    }

    final text = parts.first['text'] as String? ?? '';
    final cleanedText = text
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim()
        .replaceAll(RegExp(r',\s*\]'), ']');

    try {
      final rawList = jsonDecode(cleanedText);
      final items = List<Map<String, dynamic>>.from(rawList);
      return items.map(OrderItemModel.fromJson).toList();
    } catch (e) {
      throw Exception('Failed to interpret order. Raw: $cleanedText');
    }
  }

  String _buildPrompt(String inputText, List<String> productTitles) {
    final productListText = productTitles.join(', ');
    return '''
Convert the following order text into a JSON array of products.

Each product must include only the fields: "product" and "quantity".

- Always capitalize the first letter of the product name.
- Use only product names from the available list.
- If a product is not in the available list, still include it. In that case, in the "product" field write the product name with the first letter uppercase and append "(Unmatched)".

Return only a pure JSON array, without comments, explanations, or extra text.

Available products: $productListText

Order text: "$inputText"
''';
  }
}
