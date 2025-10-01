import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';

class MemoWidget extends StatelessWidget {
  const MemoWidget({
    required this.pdfUrl,
    required this.textMemo,
    super.key,
  });

  final String? pdfUrl;
  final String? textMemo;

  bool _isPdf(String url) => url.toLowerCase().endsWith('.pdf');

  bool _isDoc(String url) =>
      url.toLowerCase().endsWith('.doc') || url.toLowerCase().endsWith('.docx');

  @override
  Widget build(BuildContext context) {
    if ((pdfUrl == null || pdfUrl!.isEmpty) &&
        (textMemo == null || textMemo!.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (pdfUrl != null && pdfUrl!.isNotEmpty)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.color.bluePinkLight,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: () {
                if (_isPdf(pdfUrl!)) {
                  context.pushNamed(AppRoutes.pdfViewerPage, arguments: pdfUrl);
                } else if (_isDoc(pdfUrl!)) {
                  context.pushNamed(AppRoutes.docViewerPage, arguments: pdfUrl);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('صيغة الملف غير مدعومة')),
                  );
                }
              },
              icon: Icon(
                _isPdf(pdfUrl!)
                    ? Icons.picture_as_pdf
                    : _isDoc(pdfUrl!)
                    ? Icons.description
                    : Icons.insert_drive_file,
              ),
              label: Text(
                _isPdf(pdfUrl!)
                    ? 'PDF'
                    : _isDoc(pdfUrl!)
                    ? 'Word'
                    : 'ملف',
              ),
            ),
          if (pdfUrl != null &&
              pdfUrl!.isNotEmpty &&
              textMemo != null &&
              textMemo!.isNotEmpty)
            SizedBox(width: 12.w),
          if (textMemo != null && textMemo!.isNotEmpty)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.color.bluePinkLight,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: () {
                context.pushNamed(
                  AppRoutes.textViewerPage,
                  arguments: textMemo,
                );
              },
              icon: const Icon(Icons.notes),
              label: const Text('ملاحظات'),
            ),
        ],
      ),
    );
  }
}
