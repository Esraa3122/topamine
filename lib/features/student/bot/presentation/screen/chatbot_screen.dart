import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
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
      message: 'أهلا 👋\n كيف يمكننى مساعدتك ؟',
    ),
  ];
  final TextEditingController _textEditingController = TextEditingController();
  bool _isTyping = false;

  Future<void> handleSubmit() async {
    final prompt = _textEditingController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _messages.insert(
        0,
        Message(
          isUser: true,
          message: prompt,
        ),
      );
      _textEditingController.clear();
      _isTyping = true; 
    });

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyDT_K1WmbFE4sT1ekAU_UJvH6QN3hhvroY',
      );

      final response = await model.generateContent([Content.text(prompt)]);

      // await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isTyping = false;
        _messages.insert(
          0,
          Message(
            message: response.text != null ? response.text!.trim() : '',
          ),
        );
      });
    } catch (e) {
      setState(() {
        _isTyping = false;
      });
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.chatboot,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade200,
              child: SvgPicture.asset(
                AppImages.chatboot,
                color: Colors.white,
                height: 25.h,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 TextApp(
                  text: 'Gemini Bot',
                  theme: TextStyle(
                    fontWeight: FontWeightHelper.bold,
                    fontFamily: FontFamilyHelper.cairoArabic,
                    letterSpacing: 0.5,
                    color: context.color.textColor
                    ),
                ),
                TextApp(
                  text:  _isTyping ? 'يكتب...' : 'متصل الآن',
                  theme: const TextStyle(
                    fontSize: 12, 
                    color: Colors.white70,
                    fontFamily: FontFamilyHelper.cairoArabic,
                    letterSpacing: 0.5
                    ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade400,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios, color: context.color.textColor,),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              reverse: true,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) => SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.1, 0.3),
                      end: Offset.zero,
                    ).animate(anim),
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: _messages[index],
                );
              },
              separatorBuilder: (_, _) => const SizedBox(height: 6),
              itemCount: _messages.length,
            ),
          ),

          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.blue.shade200,
                    child: SvgPicture.asset(
                      AppImages.chatboot,
                      color: Colors.white,
                      height: 25.h,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SpinKitThreeBounce(
                    color: Colors.grey.shade700,
                    size: 18,
                  ),
                ],
              ),
            ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: context.color.mainColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالة',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: handleSubmit,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
