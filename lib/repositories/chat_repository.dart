import '../services/api_service.dart';

/// Repository khusus untuk fitur chat.
///
/// Tugas:
/// - Mengelola contextId supaya percakapan nyambung.
/// - Memanggil endpoint /food/converse dari Spoonacular.
/// - Menyediakan helper mengambil detail resep dari query.
class ChatRepository {
  /// ID konteks percakapan dengan chatbot.
  /// 1 contextId per sesi percakapan.
  String? _contextId;

  /// Ambil DETAIL resep berdasarkan teks pertanyaan user.
  ///
  /// Langkah:
  /// 1. Panggil recipes/complexSearch untuk dapatkan id resep.
  /// 2. Panggil recipes/{id}/information?includeNutrition=true
  ///    untuk dapatkan detail lengkap.
  ///
  /// Return:
  ///  - Map detail resep (title, ingredients, instructions, dll) jika sukses.
  ///  - null jika gagal / tidak ada hasil.
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

    // Ambil detail resep lengkap
    final Map<String, dynamic>? detail = await ApiService.getRecipeDetail(id);
    return detail;
  }

  /// Kirim pesan ke chatbot Spoonacular dan ambil jawaban teksnya.
  ///
  /// - [userMessage]: pesan dari user.
  /// - Mengembalikan String jawaban untuk ditampilkan di UI.
  ///
  /// Melempar Exception jika terjadi error jaringan / server.
  Future<String> getConverseReply(String userMessage) async {
    // Inisialisasi contextId kalau belum ada
    _contextId ??= DateTime.now().millisecondsSinceEpoch.toString();

    final Map<String, dynamic>? response =
        await ApiService.converseWithSpoonacular(userMessage, _contextId!);

    if (response == null) {
      throw Exception(
        'Gagal menghubungi server Spoonacular. Periksa koneksi atau limit API.',
      );
    }

    // Perbarui contextId kalau API mengembalikan yang baru
    final dynamic contextFromResponse =
        response['contextId'] ?? response['conversationId'] ?? response['id'];

    if (contextFromResponse is String && contextFromResponse.isNotEmpty) {
      _contextId = contextFromResponse;
    } else if (contextFromResponse is int) {
      _contextId = contextFromResponse.toString();
    }

    // Cari teks jawaban di beberapa kemungkinan field
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

    // Fallback kalau tidak ada teks yang jelas
    if (answer == null || answer.trim().isEmpty) {
      answer =
          'Maaf, aku belum mendapatkan jawaban dari chatbot Spoonacular. Coba tanyakan dengan kalimat lain.';
    }

    return answer;
  }

  /// Reset percakapan (kalau nanti mau dipakai tombol "mulai baru").
  void resetConversation() {
    _contextId = null;
  }
}
