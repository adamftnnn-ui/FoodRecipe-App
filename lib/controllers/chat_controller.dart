import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../repositories/chat_repository.dart';

class ChatController {
  final ChatRepository repository = ChatRepository();
  final ValueNotifier<List<ChatMessage>> chatsNotifier =
      ValueNotifier<List<ChatMessage>>([]);

  final String userAvatar = 'assets/images/avatar.jpg';
  final String assistantAvatar = 'assets/images/avatar_ai.jpg';
  final String userName = 'Adam';
  final String assistantName = 'Kama';

  void addInitialGreeting(BuildContext context) {
    chatsNotifier.value = [
      ChatMessage(
        avatarUrl: assistantAvatar,
        name: assistantName,
        role: 'Assistant',
        message:
            'Halo $userName, apa yang ingin kamu tanyakan atau masak hari ini?',
        time: TimeOfDay.now().format(context),
        isAssistant: true,
      ),
    ];
  }

  void addUserMessage(String text, BuildContext context) {
    final message = ChatMessage(
      avatarUrl: userAvatar,
      name: userName,
      message: text,
      time: TimeOfDay.now().format(context),
      isAssistant: false,
    );
    chatsNotifier.value = [...chatsNotifier.value, message];
  }

  void addAssistantMessage(String text, BuildContext context) {
    final message = ChatMessage(
      avatarUrl: assistantAvatar,
      name: assistantName,
      role: 'Assistant',
      message: text,
      time: TimeOfDay.now().format(context),
      isAssistant: true,
    );
    chatsNotifier.value = [...chatsNotifier.value, message];
  }

  /// Dipanggil dari UI setiap kali user menekan tombol kirim.
  Future<void> getAssistantReply(
    String userMessage,
    BuildContext context,
  ) async {
    try {
      final keyword = userMessage.toLowerCase();
      final recipeKeywords = [
        'resep',
        'recipe',
        'masak',
        'cook',
        'burger',
        'ayam',
        'nasi',
        'sop',
        'soup',
        'ikan',
        'fish',
        'cake',
        'kue',
        'pasta',
        'salad',
      ];
      final isRecipeQuery = recipeKeywords.any((k) => keyword.contains(k));

      if (isRecipeQuery) {
        await _fetchRecipe(userMessage, context);
      } else {
        await _fetchConverseReply(userMessage, context);
      }
    } catch (e) {
      addAssistantMessage('Maaf, terjadi kesalahan.', context);
    }
  }

  Future<void> _fetchRecipe(String userMessage, BuildContext context) async {
    try {
      final detail = await repository.getRecipeDetailFromQuery(userMessage);

      if (detail == null) {
        addAssistantMessage(
          'Maaf, saya tidak menemukan resep untuk "$userMessage".',
          context,
        );
        return;
      }

      final String title = (detail['title'] ?? 'Resep Tanpa Judul').toString();
      final dynamic readyRaw = detail['readyInMinutes'];
      final String ready = (readyRaw == null || readyRaw.toString().isEmpty)
          ? '-'
          : readyRaw.toString();

      final dynamic servingsRaw = detail['servings'];
      final String servings =
          (servingsRaw == null || servingsRaw.toString().isEmpty)
          ? '-'
          : servingsRaw.toString();

      final List extIng = detail['extendedIngredients'] as List? ?? <dynamic>[];
      final List<String> ingredients = extIng
          .map<String>((e) {
            if (e is Map<String, dynamic>) {
              return (e['original'] ?? e['name'] ?? '').toString().trim();
            }
            return e.toString().trim();
          })
          .where((s) => s.isNotEmpty)
          .toList();

      // Ambil instructions kalau ada, kalau tidak pakai summary
      String instructions = (detail['instructions'] ?? detail['summary'] ?? '')
          .toString()
          .trim();

      if (instructions.isNotEmpty) {
        instructions = _stripHtml(instructions);
      }

      String reply =
          '**$title**\nPorsi: $servings\nWaktu masak: $ready menit\n';

      if (ingredients.isNotEmpty) {
        reply += '\nBahan:\n';
        for (final ing in ingredients) {
          reply += '- $ing\n';
        }
      }

      if (instructions.isNotEmpty) {
        reply += '\nLangkah:\n$instructions';
      }

      addAssistantMessage(reply.trim(), context);
    } catch (e) {
      addAssistantMessage(
        'Maaf, terjadi kesalahan saat mengambil resep.',
        context,
      );
    }
  }

  Future<void> _fetchConverseReply(
    String userMessage,
    BuildContext context,
  ) async {
    try {
      final replyText = await repository.getConverseReply(userMessage);
      addAssistantMessage(replyText, context);
    } catch (e) {
      addAssistantMessage('Maaf, terjadi kesalahan pada AI.', context);
    }
  }

  /// Utility sederhana untuk menghapus tag HTML dari teks (summary/instructions).
  String _stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }
}
