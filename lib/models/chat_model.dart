class ChatMessage {
  final String avatarUrl;
  final String name;
  final String? role;
  final String message;
  final String time;
  final bool isAssistant;

  ChatMessage({
    required this.avatarUrl,
    required this.name,
    this.role,
    required this.message,
    required this.time,
    required this.isAssistant,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      avatarUrl: json['avatarUrl'] ?? '',
      name: json['name'] ?? '',
      role: json['role'],
      message: json['message'] ?? '',
      time: json['time'] ?? '',
      isAssistant: json['isAssistant'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatarUrl': avatarUrl,
      'name': name,
      'role': role,
      'message': message,
      'time': time,
      'isAssistant': isAssistant,
    };
  }
}
