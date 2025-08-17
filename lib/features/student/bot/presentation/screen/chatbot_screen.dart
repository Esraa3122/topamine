import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
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
      message: 'أهلا كيف يمكننى مساعدتك ؟',
      isUser: false,
    ),
  ];
  final TextEditingController _textEditingController = TextEditingController();
  bool _isLoading = false;

  Future<void> handleSubmit() async {
    final prompt = _textEditingController.text.trim();

  if (prompt.isEmpty) {
    return;
  }

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
      appBar: AppBar(
        title: Text(
          'Gemini Chatbot',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.color.textColor!,
          ),
        ),
        leading: const Padding(
          padding: EdgeInsets.only(left: 6, top: 6, bottom: 6, right: 6),
          child: CircleAvatar(
            backgroundImage: AssetImage(AppImages.logo),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              color: context.color.textColor,
            ),
          ),
        ],
        backgroundColor: Colors.blue.shade300,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, context.color.mainColor!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          // padding: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
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
                  child: Center(
                    child: SpinKitSpinningLines(
                      color: context.color.textColor!,
                      size: 50.sp,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: CustomTextField(
                          hintText: 'اسأل شىء هنا ...',
                          lable: '',
                          controller: _textEditingController,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
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
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
