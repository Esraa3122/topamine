import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DocViewerPage extends StatelessWidget {
  const DocViewerPage({required this.docUrl, super.key});
  final String docUrl;

  @override
  Widget build(BuildContext context) {
    final googleUrl = 'https://docs.google.com/gview?embedded=true&url=$docUrl';

    return Scaffold(
      appBar: AppBar(
        title: TextApp(
          text: 'عرض المذكرة (Word)',
          theme: context.textStyle.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: FontFamilyHelper.cairoArabic,
            fontSize: 22,
            color: Colors.white
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
      body: WebViewWidget(
        controller: WebViewController()
          ..loadRequest(Uri.parse(googleUrl))
          ..setJavaScriptMode(JavaScriptMode.unrestricted),
      ),
    );
  }
}
