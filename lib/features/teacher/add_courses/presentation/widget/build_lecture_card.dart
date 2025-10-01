import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/custom_text_field.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/features/teacher/add_courses/presentation/widget/lecture_file_picker_widget.dart';

class BuildLectureCard extends StatelessWidget {
  const BuildLectureCard({
    required this.idx,
    required this.lecture,
    required this.onRemove,
    super.key,
  });

  final int idx;
  final Map<String, dynamic> lecture;
  final VoidCallback onRemove;

  // void removeLecture(int index) {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: context.color.mainColor,
      elevation: 4,
      shadowColor: context.color.bluePinkLight!.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: context.color.bluePinkLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextApp(
                    text: 'محاضرة ${idx + 1}',
                    theme: const TextStyle(
                      color: Colors.white, fontFamily: FontFamilyHelper.cairoArabic,
                                      letterSpacing: 0.5,),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: onRemove,
                ),
              ],
            ),

            const SizedBox(height: 12),

            CustomTextField(
              controller: lecture['title'] as TextEditingController,
              hintText: 'ادخل اسم المحاضره',
              validator: (value) {
                if (value!.isEmpty == true) {
                  return 'اسم المحاضره مطلوب';
                } else {
                  return null;
                }
              },
              lable: 'اسم المحاضرة',
            ),
            const SizedBox(height: 16),

            LectureFilePickerWidget(
              idx: idx,
              lecture: lecture,
              type: 'video',
              icon: Icons.videocam,
              label: 'فيديو',
              color: context.color.bluePinkLight!,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: LectureFilePickerWidget(
                    idx: idx,
                    lecture: lecture,
                    type: 'text',
                    icon: Icons.description,
                    label: '.txt',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LectureFilePickerWidget(
                    idx: idx,
                    lecture: lecture,
                    type: 'word',
                    icon: Icons.article,
                    label: '.doc',
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}