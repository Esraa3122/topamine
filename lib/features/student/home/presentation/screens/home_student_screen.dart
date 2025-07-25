import 'package:flutter/material.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/features/student/bot/presentation/screen/chatbot_screen.dart';
import 'package:test/features/student/home/presentation/refactors/home_student_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: const [
            HomeStudentBody(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.color.bluePinkLight, 
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatbotScreen()),
          );
        },
        child: const Icon(Icons.chat, color: Colors.white), 
      ),

    );
  }
}
