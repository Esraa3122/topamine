import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/extensions/context_extension.dart';

class Message extends StatelessWidget {
  const Message({this.message = '', this.isUser = false, super.key});
  final String message;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:  isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUser ? context.color.bluePinkDark : context.color.bluePinkLight,
          borderRadius: BorderRadius.only(
            topLeft: isUser ? Radius.circular(10) : Radius.circular(0),
            topRight: isUser ? Radius.circular(0) : Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)
          )
        ),
        child: Text(message, style: TextStyle(fontSize: 16),),
      ),
    );
  }
}
