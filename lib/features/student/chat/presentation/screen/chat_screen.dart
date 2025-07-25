import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/custom_app_bar.dart';
import 'package:test/features/student/chat/presentation/refactors/chat_body.dart';


class ChatScreen extends StatelessWidget {

  const ChatScreen({required this.chatId, super.key});
  final String chatId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Chat',),
      body: ChatBody(chatId: chatId),
    );
  }
}

