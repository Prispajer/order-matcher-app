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
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
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
    } else if (response.statusCode == 403) {
      throw Exception('Unauthorized: please check your API key configuration.');
    } else {
      throw Exception(
        'Server error (${response.statusCode}). Please try again.',
      );
    }
  }

  String _buildPrompt(String inputText, List<String> productTitles) {
    final productListText = productTitles.join(', ');
    return '''
Convert the following order text into a JSON array of products.

Rules:
1. Each product must have fields: "product" and "quantity".
2. Always capitalize the first letter of the product name.
3. If the product exists in the available list, use its name exactly.
4. If the product is not in the list, include it anyway, but append " (Unmatched)" to the name.
5. If the same product appears multiple times in the order text, sum the quantities into one entry.
6. The order text may be written in different languages. Always try to match the product to the available list by translating or interpreting the name into the language of the available products. 
   - Example: if the order text says "Jabłko" and the available list contains "Apple", treat it as "Apple".

Return only a pure JSON array, without comments, explanations, or extra text.

Available products: $productListText

Order text: "$inputText"
''';
  }
}
