import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/chat_controller.dart';
import '../models/chat_model.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/search_bar.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ChatController controller = ChatController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.addInitialGreeting(context);
      _scrollToBottom();
    });
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    controller.addUserMessage(text, context);
    _inputController.clear();
    _scrollToBottom();
    await controller.getAssistantReply(text, context);
    _scrollToBottom();
    setState(() {});
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Center(
                child: Text(
                  'Chat',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<List<ChatMessage>>(
                valueListenable: controller.chatsNotifier,
                builder: (context, chats, _) {
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      return ChatBubble(
                        avatarUrl: chat.avatarUrl,
                        name: chat.name,
                        role: chat.role,
                        message: chat.message,
                        time: chat.time,
                        isAssistant: chat.isAssistant,
                      );
                    },
                  );
                },
              ),
            ),
            SearchBarr(
              enableNavigation: false,
              placeholder: 'Ketik pertanyaanmu disini...',
              controller: _inputController,
              onSubmitted: _sendMessage,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
