// discussion_provider.dart

import 'package:flutter/foundation.dart';
import 'dart:math';

class DiscussionProvider with ChangeNotifier {
  final List<Discussion> _discussions = [];

  List<Discussion> get discussions => _discussions;

  void addDiscussion(String title) {
    final discussion = Discussion(
      id: _generateUniqueId(),
      title: title,
      dateTime: DateTime.now(),
      messages: [],
    );
    _discussions.add(discussion);
    notifyListeners();
  }

  void addMessageToDiscussion(String discussionId, String content, bool isUser) {
    final discussion = _discussions.firstWhere((d) => d.id == discussionId);
    discussion.messages.add(Message(content: content, isUser: isUser));
    notifyListeners();
  }

  void removeDiscussion(int index) {
    if (index >= 0 && index < _discussions.length) {
      _discussions.removeAt(index);
      notifyListeners();
    }
  }

  String _generateUniqueId() {
    return Random().nextInt(1000000).toString();
  }
}




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
