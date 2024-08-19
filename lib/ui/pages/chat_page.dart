import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat/services/chat/chat_service.dart';
import 'package:flutter_firebase_chat/ui/widgets/custom_text_form_field.dart';
import 'package:flutter_firebase_chat/ui/widgets/message_item.dart';
import 'package:provider/provider.dart';

import '../../services/auth/auth_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  late final ChatService chatService;
  late final AuthService authService;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
  }

  void sendMessage() async {
    if (_messageController.value.text.isNotEmpty) {
      await chatService.sendMessage(_messageController.value.text);
      _messageController.clear();
    }
  }

  void signOut() async {
    await authService.signOut();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Conversas",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
              onPressed: signOut,
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.onPrimary,
              ))
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Expanded(
            child: StreamBuilder(
              stream: chatService.getMessages(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Um erro ocorreu. ${snapshot.error}");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return ListView(
                  children: snapshot.data!.docs
                      .map((document) => MessageItem(
                            document: document,
                            currentUserId: authService.getCurrentUser(),
                          ))
                      .toList(),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  labelText: "Digite...",
                  controller: _messageController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: IconButton(
                      onPressed: sendMessage,
                      icon: Icon(
                        Icons.arrow_upward,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )),
                ),
              )
            ],
          ),
          SizedBox(height: 10,)
        ],
      ),
    );
  }
}
