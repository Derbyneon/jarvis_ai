// discussion.dart
class Discussion {
  final String id;
  final String title;
  final DateTime dateTime;
  final List<Message> messages;

  Discussion({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.messages,
  });
}

class Message {
  final String content;
  final bool isUser;

  Message({
    required this.content,
    required this.isUser,
  });
}
