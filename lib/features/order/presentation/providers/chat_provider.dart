// import 'dart:developer';

// import 'package:flutter/cupertino.dart';

// import '../../data/models/chat_modal.dart';

// class ChatProvider extends ChangeNotifier {
//   static final ChatProvider chatProvider = ChatProvider._internal();

//   factory ChatProvider() {
//     return chatProvider;
//   }

//   ChatProvider._internal();

//   final chatController = TextEditingController();

//   List<ChatModel> _chatMessagesList = [];

//   List<ChatModel> get chatMessageList => _chatMessagesList;

//   clearChatList() {
//     _chatMessagesList.clear();
//     _chatMessagesList = [];
//     notifyListeners();
//   }

//   addChatAll(List<ChatModel> list) {
//     _chatMessagesList = list;
//     notifyListeners();
//   }

//   addSingleChat(ChatModel chat) {
//     log("my single chat data is:-->> ${chat}");
//     _chatMessagesList.insert(0, chat);
//     notifyListeners();
//   }
// }
