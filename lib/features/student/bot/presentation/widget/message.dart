import 'package:flutter/material.dart';
import 'package:test/core/extensions/context_extension.dart';

class Message extends StatelessWidget {
  const Message({this.message = '', this.isUser = false, super.key});
  final String message;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUser
              ? context.color.bluePinkDark
              : context.color.bluePinkLight,
          borderRadius: BorderRadius.only(
            topLeft: isUser
                ? const Radius.circular(10)
                :  Radius.zero,
            topRight: isUser
                ? Radius.zero
                : const Radius.circular(10),
            bottomLeft: const Radius.circular(10),
            bottomRight: const Radius.circular(10),
          ),
        ),
        child: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
