import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/features/student/chat/data/models/chats_model.dart';

class ChatBubbleStudent extends StatelessWidget {
  const ChatBubbleStudent({required this.message, super.key});
  final Message message;

  @override
  Widget build(BuildContext context) {
   final time = DateFormat('hh:mm a').format(
  DateTime.fromMillisecondsSinceEpoch(message.date),
);

IconData icon;
    Color color;

     if (message.isRead) {
      icon = Icons.done_all;
      color = Colors.blue;
    } else {
      icon = Icons.done_all;
      color = Colors.black;
    }


    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.color.mainColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topLeft: Radius.circular(5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 4,
              offset: const Offset(2, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextApp(
              text: message.message,
              theme: context.textStyle.copyWith(
                fontSize: 14, 
                fontFamily: FontFamilyHelper.cairoArabic),
            ),
            const SizedBox(height: 4),
 Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}