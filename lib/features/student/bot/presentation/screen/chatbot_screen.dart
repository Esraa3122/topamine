import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/student/bot/presentation/widget/message.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Message> _messages = [
    const Message(
      message: 'Hi, What can I help you',
      isUser: false,
    ),
  ];
  final TextEditingController _textEditingController = TextEditingController();
  bool _isLoading = false;

  Future<void> handleSubmit() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyBqKzsFPotUr-x-8HcnbRmEobrcMY-i-Ts',
      );
      final prompt = _textEditingController.text;

      setState(() {
        _messages.add(
          Message(
            isUser: true,
            message: prompt,
          ),
        );
        _textEditingController.clear();
      });

      final response = await model.generateContent([Content.text(prompt)]);

      setState(() {
        _messages.add(
          Message(
            isUser: false,
            message: response.text != null ? response.text!.trim() : '',
          ),
        );
      });
      print(response.text);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Chatbot', style: TextStyle(fontWeight: FontWeight.bold),),
        leading: const Padding(
          padding: EdgeInsets.only(
            left: 6,
            top: 6,
            bottom: 6
          ),
          child: CircleAvatar(
            backgroundImage: AssetImage(AppImages.logo),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return _messages[index];
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: _messages.length,
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Ask something here...',
                    ),
                    controller: _textEditingController,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: context.color.bluePinkLight,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: handleSubmit,
                    icon: const Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
