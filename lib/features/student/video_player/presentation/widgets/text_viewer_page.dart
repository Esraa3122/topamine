import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';

class TextViewerPage extends StatefulWidget {
  const TextViewerPage({required this.txtUrl, super.key});
  final String txtUrl;

  @override
  State<TextViewerPage> createState() => _TextViewerPageState();
}

class _TextViewerPageState extends State<TextViewerPage> {
  String? content;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadText();
  }

  Future<void> _loadText() async {
    try {
      final response = await http.get(Uri.parse(widget.txtUrl));
      if (response.statusCode == 200) {
        setState(() {
          content = response.body;
          isLoading = false;
        });
      } else {
        setState(() {
          content = 'تعذر تحميل الملف النصي';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        content = 'خطأ أثناء تحميل النص';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'عرض المذكرة (Text)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.color.bluePinkLight,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            gradient: LinearGradient(
              colors: [
                context.color.bluePinkLight!,
                context.color.bluePinkDark!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: TextApp(
                text: content ?? 'لا يوجد محتوى',
                theme: context.textStyle.copyWith(
                  fontFamily: FontFamilyHelper.cairoArabic,
                  letterSpacing: 0.5
                ),),
            ),
    );
  }
}
