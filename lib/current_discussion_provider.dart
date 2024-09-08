import 'package:flutter/foundation.dart';

class CurrentDiscussionIdProvider with ChangeNotifier {
  String? _currentDiscussionId;

  String? get currentDiscussionId => _currentDiscussionId;

  void setCurrentDiscussionId(String id) {
    _currentDiscussionId = id;
    notifyListeners();
  }

  void clearCurrentDiscussionId() {
    _currentDiscussionId = null;
    notifyListeners();
  }
}
