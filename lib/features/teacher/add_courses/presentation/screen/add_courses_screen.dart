import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/utils/PickFileUtils.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:test/features/teacher/add_courses/presentation/cubit/add_course_cubit.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final subTitleController = TextEditingController();
  final priceController = TextEditingController();
  final gradeLevelController = TextEditingController();
  final termController = TextEditingController();
  final subjectController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  File? imageFile;
  List<Map<String, dynamic>> lectures = [];

  final List<String> gradeLevels = [
    'الصف الأول الثانوي',
    'الصف الثاني الثانوي',
    'الصف الثالث الثانوي',
  ];

  String? selectedGrade;

  final List<String> terms = [
    'الترم الأول',
    'الترم الثاني',
  ];

  String? selectedTerm;

  void removeLecture(int index) {
    setState(() {
      lectures[index]['title']?.dispose();
      lectures.removeAt(index);
    });
  }

  void pickImage() async {
    final file = await PickFileUtils.pickImage();
    if (file != null) setState(() => imageFile = file);
  }

  void addLecture() {
    lectures.add({
      'title': TextEditingController(),
      'video': null,
      'word': null,
      'text': null,
    });
    setState(() {});
  }

  void pickLectureFile(int index, String type) async {
    File? file;
    if (type == 'video') {
      file = await PickFileUtils.pickVideo();
    } else {
      file = await PickFileUtils.pickDocument(
        extensions: type == 'word' ? ['doc', 'docx'] : ['txt'],
      );
    }
    if (file != null) {
      lectures[index][type] = file;
      setState(() {});
    }
  }

  Future<void> pickDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        if (isStart) {
          startDate = date;
        } else {
          endDate = date;
        }
      });
    }
  }

  void submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب رفع صورة للكورس')),
      );
      return;
    }

    final cubit = context.read<AddCourseCubit>();

    for (final lecture in lectures) {
      final title = (lecture['title'] as TextEditingController).text;
      final video = lecture['video'] as File?;
      if (title.isEmpty || video == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('كل محاضرة يجب أن تحتوي على عنوان وفيديو'),
          ),
        );
        return;
      }
      await cubit.uploadLecture(
        title: title,
        video: video,
        word: lecture['word'] as File?,
        text: lecture['text'] as File?,
      );
    }

    final user = FirebaseAuth.instance.currentUser!;
    final course = CoursesModel(
      title: titleController.text,
      subTitle: subTitleController.text,
      price: double.tryParse(priceController.text) ?? 0,
      gradeLevel: gradeLevelController.text,
      term: termController.text,
      startDate: startDate ?? DateTime.now(),
      endDate: endDate ?? DateTime.now().add(const Duration(days: 30)),
      teacherId: user.uid,
      teacherName: user.displayName ?? '',
      teacherEmail: user.email,
      subject: subjectController.text,
    );

    await cubit.submitCourse(course: course, imageFile: imageFile!);

    // Reset form
    titleController.clear();
    subTitleController.clear();
    subjectController.clear();
    priceController.clear();
    gradeLevelController.clear();
    termController.clear();
    startDate = null;
    endDate = null;
    imageFile = null;
    for (var lecture in lectures) {
      lecture['title']?.dispose();
    }
    lectures.clear();
    setState(() {});

    if (context.mounted) {
      await context.pushReplacementNamed(AppRoutes.navigationTeacher);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إضافة كورس',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        shadowColor: Colors.tealAccent,
      ),
      body: BlocListener<AddCourseCubit, AddCourseState>(
        listener: (context, state) {
          if (state is AddCourseSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تمت الإضافة بنجاح')),
            );
          } else if (state is AddCourseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'صورة الكورس',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: context.color.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: pickImage,
                  child: DottedBorder(
                    options: const RoundedRectDottedBorderOptions(
                      radius: Radius.circular(8),
                      dashPattern: [6, 3],
                      color: Colors.teal,
                      strokeWidth: 1.5,
                      padding: EdgeInsets.zero,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      alignment: Alignment.center,
                      child: imageFile == null
                          ? const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                  color: Colors.teal,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'رفع صورة الكورس',
                                  style: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                imageFile!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'عنوان الكورس',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: subTitleController,
                  decoration: const InputDecoration(
                    labelText: 'العنوان الفرعي',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    labelText: 'المادة',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => pickDate(true),
                        child: DateField(
                          label: 'تاريخ البداية',
                          date: startDate,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => pickDate(false),
                        child: DateField(label: 'تاريخ النهاية', date: endDate),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'السعر',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedGrade,
                  decoration: const InputDecoration(
                    labelText: 'الصف الدراسي',
                    border: OutlineInputBorder(),
                  ),
                  items: gradeLevels.map((grade) {
                    return DropdownMenuItem<String>(
                      value: grade,
                      child: Text(grade),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedGrade = value;
                    gradeLevelController.text = value!;
                  },
                  validator: (value) =>
                      value == null || value.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedTerm,
                  decoration: const InputDecoration(
                    labelText: 'الترم',
                    border: OutlineInputBorder(),
                  ),
                  items: terms.map((term) {
                    return DropdownMenuItem<String>(
                      value: term,
                      child: Text(term),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedTerm = value;
                    termController.text = value!;
                  },
                  validator: (value) =>
                      value == null || value.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'المحاضرات',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.teal,
                        // backgroundColor: Colors.teal,
                        // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(12),
                        // ),
                      ),
                      onPressed: addLecture,
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('أضف محاضرة'),
                    ),
                  ],
                ),
                ...lectures.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final lecture = entry.value;
                  return Card(
                    color: context.color.mainColor,
                    elevation: 4,
                    shadowColor: context.color.bluePinkLight!.withOpacity(0.5),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'محاضرة ${idx + 1}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => removeLecture(idx),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller:
                                lecture['title'] as TextEditingController,
                            decoration: const InputDecoration(
                              labelText: 'اسم المحاضرة',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'فيديو',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          DottedBorder(
                            options: const RoundedRectDottedBorderOptions(
                              radius: Radius.circular(8),
                              dashPattern: [8, 4],
                              strokeWidth: 2,
                              color: Colors.teal,
                              padding: EdgeInsets.all(16),
                            ),
                            child: InkWell(
                              onTap: () => pickLectureFile(idx, 'video'),
                              child: const SizedBox(
                                height: 100,
                                width: double.infinity,
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.videocam,
                                        size: 32,
                                        color: Colors.teal,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'رفع فيديو',
                                        style: TextStyle(color: Colors.teal),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: DottedBorder(
                                  options: const RoundedRectDottedBorderOptions(
                                    radius: Radius.circular(8),
                                    dashPattern: [8, 4],
                                    strokeWidth: 2,
                                    color: Colors.teal,
                                    padding: EdgeInsets.all(16),
                                  ),
                                  child: InkWell(
                                    onTap: () => pickLectureFile(idx, 'text'),
                                    child: const SizedBox(
                                      height: 80,
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.cloud_upload_outlined,
                                              size: 28,
                                              color: Colors.teal,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'رفع .txt',
                                              style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: DottedBorder(
                                  options: const RoundedRectDottedBorderOptions(
                                    radius: Radius.circular(8),
                                    dashPattern: [8, 4],
                                    strokeWidth: 2,
                                    color: Colors.teal,
                                    padding: EdgeInsets.all(16),
                                  ),
                                  child: InkWell(
                                    onTap: () => pickLectureFile(idx, 'word'),
                                    child: const SizedBox(
                                      height: 80,
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.cloud_upload_outlined,
                                              size: 28,
                                              color: Colors.teal,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'رفع .doc',
                                              style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'حفظ الكورس',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateField extends StatelessWidget {
  const DateField({required this.label, required this.date, super.key});
  final String label;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            date != null
                ? DateFormat('yyyy-MM-dd').format(date!)
                : "اختر التاريخ",
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// class DottedBorderBox extends StatelessWidget {
//   const DottedBorderBox({super.key, required this.child});
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 120,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey, width: 1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: child,
//     );
//   }
// }
