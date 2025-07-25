import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/features/student/chat/data/models/chats_model.dart';
import 'package:test/features/student/chat/presentation/widgets/chat_buble_for_student.dart';
import 'package:test/features/student/chat/presentation/widgets/chat_buble_for_teacher.dart';

class ChatBody extends StatefulWidget {
  final String chatId; // 💡 نمرر chatId

  const ChatBody({required this.chatId, super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  late final CollectionReference messages;

  final TextEditingController controller = TextEditingController();
  final ScrollController _controller = ScrollController();

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final String? currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  final String? currentUserName = FirebaseAuth.instance.currentUser!.displayName ?? 'No Name';

  @override
  void initState() {
    super.initState();
    messages = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages');
  }

  Future<void> sendMessage(String data) async {
    final messageData = {
      'message': data,
      'createdAt': Timestamp.now(),
      'createdBy': currentUserId,
      'name': currentUserName,
      'emailUser': currentUserEmail,
    };

    final chatRef = FirebaseFirestore.instance.collection('chats').doc(widget.chatId);

    await messages.add(messageData);

    await chatRef.set({
      'lastMessage': data,
      'lastMessageTime': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          List<Message> messagesList = asyncSnapshot.data!.docs.map((doc) {
            return Message.fromJson(doc.data() as Map<String, dynamic>);
          }).toList();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  controller: _controller,
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                    final message = messagesList[index];
                    return message.uId == currentUserId
                        ? ChatBubleForStudent(message: message)
                        : ChatBubleForTeacher(message: message);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: controller,
                  onSubmitted: (data) async {
                    await sendMessage(data);
                    controller.clear();
                    _controller.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'Send Message',
                    suffixIcon: Icon(
                      Icons.send,
                      color: context.color.bluePinkDark,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: context.color.textFormBorder!,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
