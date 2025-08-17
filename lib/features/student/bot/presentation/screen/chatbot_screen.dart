import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:test/core/common/widgets/custom_app_bar.dart';
import 'package:test/core/common/widgets/custom_text_field.dart';
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
      if (kDebugMode) {
        print(response.text);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Gemini Chatbot',
        color: context.color.textColor,
        backgroundColor: context.color.mainColor,
      ),
      // AppBar(
      //   title: const Text(
      //     'Gemini Chatbot',
      //     style: TextStyle(fontWeight: FontWeight.bold),
      //   ),
      //   leading: const Padding(
      //     padding: EdgeInsets.only(left: 6, top: 6, bottom: 6),
      //     child: CircleAvatar(
      //       backgroundImage: AssetImage(AppImages.logo),
      //     ),
      //   ),
      //   backgroundColor: Colors.blue,
      // ),
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
      child: CustomTextField(
        hintText: 'اسأل شىء هنا ...',
        lable: '',
        controller: _textEditingController,
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: InkWell(
            onTap: handleSubmit,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.color.bluePinkLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                size: 18, // الحجم أصغر
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  ],
)
          ],
        ),
      ),
    );
  }
}
