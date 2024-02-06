import 'package:flutter/foundation.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../core/utility/injection.dart';
import '../core/utility/session_helper.dart';

class BookingSocketProvider with ChangeNotifier {
  final session = locator<Session>();
  WebSocket? _socket;
  connectToSocket() {
    _socket = WebSocket(
      Uri.parse(
        "ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}",
      ),
      pingInterval: Duration(seconds: 5),
    );
  }
}
