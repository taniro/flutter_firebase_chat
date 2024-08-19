import 'package:flutter_firebase_chat/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../services/chat/chat_service.dart';

class ConfigureProviders {

  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async {

    final auth_service = AuthService();
    final chat_service = ChatService();

    return ConfigureProviders(providers: [
      Provider<AuthService>.value(value: auth_service),
      Provider<ChatService>.value(value: chat_service)
    ]);
  }
}

