import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_filex/open_filex.dart';
import 'package:test/core/common/toast/awesome_snackbar.dart';
import 'package:test/core/common/widgets/custom_text_field.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/utils/PickFileUtils.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:test/features/teacher/add_courses/presentation/cubit/add_course_cubit.dart';
import 'package:test/features/teacher/add_courses/presentation/widget/date_field.dart';
import 'package:test/features/teacher/add_courses/presentation/widget/video_player_view_widget.dart';

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
      ),
      body: BlocConsumer<AddCourseCubit, AddCourseState>(
        listener: (context, state) {
              if (state is AddCourseSuccess) {
                AwesomeSnackBar.show(
                  context: context,
                  title: 'Success!',
                  message: 'تمت الإضافة بنجاح',
                  contentType: ContentType.success,
                );
              } else if (state is AddCourseError) {
                AwesomeSnackBar.show(
                  context: context,
                  title: 'Error!',
                  message: state.message,
                  contentType: ContentType.failure,
                );
              }
            },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: context.color.mainColor,
                        elevation: 4,
                        shadowColor: context.color.bluePinkLight!.withOpacity(
                          0.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.image,
                                    color: context.color.bluePinkLight!,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'صورة الكورس',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: context.color.textColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: pickImage,
                                child: DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    radius: const Radius.circular(8),
                                    dashPattern: [6, 3],
                                    color: context.color.bluePinkLight!,
                                  ),
                                  child: Container(
                                    height: 150,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: imageFile == null
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.camera_alt_outlined,
                                                size: 40,
                                                color:
                                                    context.color.bluePinkLight,
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                'رفع صورة الكورس',
                                                style: TextStyle(
                                                  color:
                                                      context.color.bluePinkLight,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      8,
                                                    ),
                                                child: Image.file(
                                                  imageFile!,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: 150,
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 4,
                                                left: 0,
                                                right: 0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      iconSize: 20,
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          const BoxConstraints(),
                                                      onPressed: pickImage,
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
                                                      constraints:
                                                          const BoxConstraints(),
                                                      onPressed: () {
                                                        setState(() {
                                                          imageFile = null;
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                      tooltip: 'حذف الصورة',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              
                      const SizedBox(height: 16),
                      Card(
                        color: context.color.mainColor,
                        elevation: 4,
                        shadowColor: context.color.bluePinkLight!.withOpacity(
                          0.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTextField(titleController, "عنوان الكورس"),
                              const SizedBox(height: 8),
                              _buildTextField(subTitleController, "وصف الكورس"),
                              const SizedBox(height: 8),
                              _buildTextField(subjectController, "المادة"),
                            ],
                          ),
                        ),
                      ),
              
                      const SizedBox(height: 16),
              
                      Card(
                        color: context.color.mainColor,
                        elevation: 4,
                        shadowColor: context.color.bluePinkLight!.withOpacity(
                          0.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
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
                                  child: DateField(
                                    label: 'تاريخ النهاية',
                                    date: endDate,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        color: context.color.mainColor,
                        elevation: 4,
                        shadowColor: context.color.bluePinkLight!.withOpacity(
                          0.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTextField(priceController, "السعر",keyboardType: TextInputType.number),
                              const SizedBox(height: 8),
                              _buildDropdown(
                                "الصف الدراسي",
                                selectedGrade,
                                gradeLevels,
                                (v) => setState(() {
                                  selectedGrade = v;
                                  gradeLevelController.text = v!;
                                }),
                              ),
                              const SizedBox(height: 8),
                              _buildDropdown("الترم", selectedTerm, terms, (v) {
                                setState(() {
                                  selectedTerm = v;
                                  termController.text = v!;
                                });
                              }),
                            ],
                          ),
                        ),
                      ),
              
                      const SizedBox(height: 20),
              
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'المحاضرات',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: context.color.textColor,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: addLecture,
                            style: TextButton.styleFrom(
                              foregroundColor: context.color.bluePinkLight,
                            ),
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text('أضف محاضرة'),
                          ),
                        ],
                      ),
              
                      ...lectures.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final lecture = entry.value;
                        return _buildLectureCard(idx, lecture);
                      }),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              if (state is AddCourseLoading)
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: SpinKitSpinningLines(
                            color: context.color.bluePinkLight!,
                            size: 50.sp,
                          ),
                        ),
                      ),
            ],
          );
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: ElevatedButton.icon(
          onPressed: submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.color.bluePinkLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          icon: const Icon(Icons.save, color: Colors.white),
          label: const Text(
            'حفظ الكورس',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    String? hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomTextField(
        controller: controller,
        hintText: hintText,
        keyboardType: keyboardType,
        validator: (v) => v!.isEmpty ? 'مطلوب' : null,
        lable: label,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: context.color.textFormBorder!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: context.color.textFormBorder!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      ),
      value: value,
      isExpanded: true,
      items: items
          .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
    );
  }

  Widget _buildLectureCard(int idx, Map<String, dynamic> lecture) {
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
                  child: Text(
                    "محاضرة ${idx + 1}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: () => removeLecture(idx),
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

            _buildFilePicker(
              idx: idx,
              lecture: lecture,
              type: "video",
              icon: Icons.videocam,
              label: "فيديو",
              color: context.color.bluePinkLight!,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildFilePicker(
                    idx: idx,
                    lecture: lecture,
                    type: "text",
                    icon: Icons.description,
                    label: ".txt",
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFilePicker(
                    idx: idx,
                    lecture: lecture,
                    type: "word",
                    icon: Icons.article,
                    label: ".doc",
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

  Widget _buildFilePicker({
    required int idx,
    required Map<String, dynamic> lecture,
    required String type,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final file = lecture[type] as File?;

    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: const Radius.circular(12),
        dashPattern: const [6, 3],
        color: color,
      ),
      child: Container(
        height: type == "video" ? 180 : 100,
        width: double.infinity,
        alignment: Alignment.center,
        child: file == null
            ? InkWell(
                onTap: () => pickLectureFile(idx, type),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: color, size: 32),
                    const SizedBox(height: 6),
                    Text("رفع $label", style: TextStyle(color: color)),
                  ],
                ),
              )
            : Stack(
                children: [
                  Positioned.fill(
                    child: type == "video"
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: VideoPlayerViewWidget(file: file),
                          )
                        : ListTile(
                            leading: Icon(icon, color: color),
                            title: Text("عرض ملف $label"),
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
                          onPressed: () => pickLectureFile(idx, type),
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.blueAccent,
                          ),
                          tooltip: "إعادة رفع",
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              lecture[type] = null;
                            });
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: "حذف الملف",
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
