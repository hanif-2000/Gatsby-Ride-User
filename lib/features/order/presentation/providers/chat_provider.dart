import 'package:flutter/cupertino.dart';

import '../../data/models/chat_response_modal.dart';

class ChatProvider extends ChangeNotifier {
  static final ChatProvider chatProvider = ChatProvider._internal();

  factory ChatProvider() {
    return chatProvider;
  }

  ChatProvider._internal();

  final chatController = TextEditingController();

  List<ChatData> _chatMessagesList = [];

  List<ChatData> get chatMessageList => _chatMessagesList;

  clearChatList() {
    _chatMessagesList.clear();
    _chatMessagesList = [];
    notifyListeners();
  }

  addChatAll(List<ChatData> list) {
    _chatMessagesList = list;
    notifyListeners();
  }

  addSingleChat(ChatData chat) {
    _chatMessagesList.insert(0, chat);
    notifyListeners();
  }
}
