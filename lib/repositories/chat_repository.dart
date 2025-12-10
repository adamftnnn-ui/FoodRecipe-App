import '../services/api_service.dart';

class ChatRepository {
  String? _contextId;

  Future<Map<String, dynamic>?> getRecipeDetailFromQuery(String query) async {
    final String q = Uri.encodeQueryComponent(query);
    final String searchEndpoint =
        'recipes/complexSearch?query=$q&number=1&addRecipeInformation=false';

    final Map<String, dynamic>? searchResult = await ApiService.getData(
      searchEndpoint,
    );

    if (searchResult == null ||
        searchResult['results'] is! List ||
        (searchResult['results'] as List).isEmpty) {
      return null;
    }

    final Map<String, dynamic> first =
        (searchResult['results'] as List).first as Map<String, dynamic>;
    final int? id = first['id'] as int?;

    if (id == null) return null;

    final Map<String, dynamic>? detail = await ApiService.getRecipeDetail(id);
    return detail;
  }

  Future<String> getConverseReply(String userMessage) async {
    _contextId ??= DateTime.now().millisecondsSinceEpoch.toString();

    final Map<String, dynamic>? response =
        await ApiService.converseWithSpoonacular(userMessage, _contextId!);

    if (response == null) {
      throw Exception(
        'Failed to contact Spoonacular server. Please check your connection or API limit.',
      );
    }

    final dynamic contextFromResponse =
        response['contextId'] ?? response['conversationId'] ?? response['id'];

    if (contextFromResponse is String && contextFromResponse.isNotEmpty) {
      _contextId = contextFromResponse;
    } else if (contextFromResponse is int) {
      _contextId = contextFromResponse.toString();
    }

    String? answer;
    if (response['answerText'] != null) {
      answer = response['answerText'].toString();
    } else if (response['text'] != null) {
      answer = response['text'].toString();
    } else if (response['message'] != null) {
      answer = response['message'].toString();
    } else if (response['output'] != null) {
      answer = response['output'].toString();
    }

    if (answer == null || answer.trim().isEmpty) {
      answer =
          'Sorry, I did not get a response from the Spoonacular chatbot. Please try asking in a different way.';
    }

    return answer;
  }

  void resetConversation() {
    _contextId = null;
  }
}
