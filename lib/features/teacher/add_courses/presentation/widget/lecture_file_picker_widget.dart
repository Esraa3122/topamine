import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/utils/pickFileUtils.dart';

import 'package:test/features/teacher/add_courses/presentation/widget/video_player_view_widget.dart';

class LectureFilePickerWidget extends StatefulWidget {
  const LectureFilePickerWidget({
    required this.idx,
    required this.lecture,
    required this.type,
    required this.icon,
    required this.label,
    required this.color,
    super.key,
  });

  final int idx;
  final Map<String, dynamic> lecture;
  final String type;
  final IconData icon;
  final String label;
  final Color color;

  @override
  State<LectureFilePickerWidget> createState() =>
      _LectureFilePickerWidgetState();
}

class _LectureFilePickerWidgetState extends State<LectureFilePickerWidget> {
  List<Map<String, dynamic>> lectures = [];

  Future<void> pickLectureFile(int index, String type) async {
    File? file;
    if (type == 'video') {
      file = await PickFileUtils.pickVideo();
    } else {
      file = await PickFileUtils.pickDocument(
        extensions: type == 'word' ? ['doc', 'docx'] : ['txt'],
      );
    }
    if (file != null) {
      widget.lecture[type] = file;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final file = widget.lecture[widget.type] as File?;

    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: const Radius.circular(12),
        dashPattern: const [6, 3],
        color: widget.color,
      ),
      child: Container(
        height: widget.type == 'video' ? 180 : 100,
        width: double.infinity,
        alignment: Alignment.center,
        child: file == null
            ? InkWell(
                onTap: () => pickLectureFile(widget.idx, widget.type),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon, color: widget.color, size: 32),
                    const SizedBox(height: 6),
                    TextApp(
                      text: 'رفع ${widget.label}',
                      theme: TextStyle(
                        color: widget.color,
                        fontFamily: FontFamilyHelper.cairoArabic,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  Positioned.fill(
                    child: widget.type == 'video'
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: VideoPlayerViewWidget(file: file),
                          )
                        : ListTile(
                            leading: Icon(widget.icon, color: widget.color),
                            title: TextApp(
                              text: 'عرض ملف ${widget.label}',
                              theme: TextStyle(
                                color: widget.color,
                                fontFamily: FontFamilyHelper.cairoArabic,
                                letterSpacing: 0.5,
                              ),
                            ),
                            onTap: () => OpenFilex.open(file.path),
                          ),
                  ),

                  Positioned(
                    bottom: 4,
                    left: 4,
                    right: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () =>
                              pickLectureFile(widget.idx, widget.type),
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.blueAccent,
                          ),
                          tooltip: 'إعادة رفع',
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              widget.lecture[widget.type] = null;
                            });
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'حذف الملف',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
