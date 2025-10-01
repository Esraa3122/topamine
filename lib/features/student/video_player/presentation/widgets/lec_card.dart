import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class LectureCard extends StatefulWidget {
  const LectureCard({
    required this.lecture,
    required this.index,
    required this.onVideoTap,
    super.key,
    this.isSelected = false,
    this.isCompleted = false,
  });

  final LectureModel lecture;
  final int index;
  final VoidCallback onVideoTap;
  final bool isSelected;
  final bool isCompleted;

  @override
  State<LectureCard> createState() => _LectureCardState();
}

class _LectureCardState extends State<LectureCard> {
  bool _isExpanded = false;

  void _handleTapExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  bool _isPdf(String url) => url.toLowerCase().endsWith('.pdf');
  bool _isDoc(String url) =>
      url.toLowerCase().endsWith('.doc') || url.toLowerCase().endsWith('.docx');

  void _openFile(String url) {
    if (_isPdf(url)) {
      context.pushNamed(AppRoutes.pdfViewerPage, arguments: url);
    } else if (_isDoc(url)) {
      context.pushNamed(AppRoutes.docViewerPage, arguments: url);
    } else if (url.toLowerCase().endsWith('.txt')) {
      context.pushNamed(AppRoutes.textViewerPage, arguments: url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('صيغة الملف غير مدعومة')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.isSelected
          ? widget.isCompleted
                ? Colors.green.withOpacity(0.1)
                : Colors.blue.withOpacity(0.1)
          : context.color.mainColor,
      elevation: 4,
      shadowColor: widget.isCompleted
          ? Colors.green.withOpacity(0.1)
          : Colors.blue.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              widget.isCompleted ? Icons.check_circle : Icons.play_circle_fill,
              color: widget.isCompleted ? Colors.green : Colors.blue,
              size: 28,
            ),
            title: TextApp(
              text: 'المحاضرة ${widget.index + 1}: ${widget.lecture.title}',
              theme: context.textStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeightHelper.medium,
                color: widget.isSelected
                    ? Colors.blue.shade800
                    : context.color.textColor,
                fontFamily: FontFamilyHelper.cairoArabic,
                letterSpacing: 0.5,
              ),
            ),
            subtitle: widget.lecture.duration != null
                ? TextApp(
                    text: 'المدة: ${widget.lecture.duration}',
                    theme: context.textStyle.copyWith(
                      fontFamily: FontFamilyHelper.cairoArabic,
                      letterSpacing: 0.5,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  )
                : null,
            trailing: Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
            onTap: _handleTapExpansion,
          ),

          // التفاصيل (مشاهدة فيديو + ملفات)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.play_arrow, color: Colors.green),
                  title: TextApp(
                    text: 'مشاهدة الفيديو',
                    theme: context.textStyle.copyWith(
                      fontFamily: FontFamilyHelper.cairoArabic,
                      letterSpacing: 0.5,
                      color: widget.isSelected
                          ? Colors.blue.shade800
                          : context.color.textColor,
                    ),
                  ),
                  onTap: widget.onVideoTap,
                ),
                if ((widget.lecture.docUrl ?? '').isNotEmpty)
                  ListTile(
                    leading: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                    ),
                    title: TextApp(
                      text: 'عرض الملف',
                      theme: context.textStyle.copyWith(
                        fontFamily: FontFamilyHelper.cairoArabic,
                        letterSpacing: 0.5,
                        color: widget.isSelected
                            ? Colors.blue.shade800
                            : context.color.textColor,
                      ),
                    ),
                    onTap: () => _openFile(widget.lecture.docUrl!),
                  ),
                if ((widget.lecture.txtUrl ?? '').isNotEmpty)
                  ListTile(
                    leading: const Icon(
                      Icons.description,
                      color: Colors.orange,
                    ),
                    title: TextApp(
                      text: 'عرض الملاحظات',
                      theme: context.textStyle.copyWith(
                        fontFamily: FontFamilyHelper.cairoArabic,
                        letterSpacing: 0.5,
                        color: widget.isSelected
                            ? Colors.blue.shade800
                            : context.color.textColor,
                      ),
                    ),
                    onTap: () => _openFile(widget.lecture.txtUrl!),
                  ),
              ],
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
