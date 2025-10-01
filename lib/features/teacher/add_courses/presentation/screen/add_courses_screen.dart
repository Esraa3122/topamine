import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test/core/common/toast/awesome_snackbar.dart';
import 'package:test/core/common/toast/gradient_snack_bar.dart';
import 'package:test/core/common/widgets/custom_text_field.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/core/utils/PickFileUtils.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:test/features/teacher/add_courses/presentation/cubit/add_course_cubit.dart';
import 'package:test/features/teacher/add_courses/presentation/widget/build_drop_down.dart';
import 'package:test/features/teacher/add_courses/presentation/widget/build_lecture_card.dart';
import 'package:test/features/teacher/add_courses/presentation/widget/date_field.dart';
import 'package:video_player/video_player.dart';

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

  Future<String?> getVideoDuration(String url) async {
    try {
      final controller = VideoPlayerController.network(
        url,
      );
      await controller.initialize();
      final duration = controller.value.duration;
      await controller.dispose();

      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final hours = twoDigits(duration.inHours);
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));

      return duration.inHours > 0
          ? '$hours:$minutes:$seconds'
          : '$minutes:$seconds';
    } catch (e) {
      return null;
    }
  }

  Future<void> pickImage() async {
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

  Future<void> pickDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.color.bluePinkLight!,
              onSurface: context.color.textColor!,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: context.color.mainColor,
              headerBackgroundColor: context.color.bluePinkLight,
              headerForegroundColor: Colors.white,
              dayForegroundColor: WidgetStateProperty.all(
                context.color.textColor,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: context.color.bluePinkLight,
              ),
            ),
          ),
          child: child!,
        );
      },
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

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (imageFile == null) {
      GradientSnackBar.show(
        context,
        'يجب رفع صورة للكورس',
        Colors.red.shade400,
        Colors.redAccent.shade700,
      );
      return;
    }

    final cubit = context.read<AddCourseCubit>();

    for (final lecture in lectures) {
      final title = (lecture['title'] as TextEditingController).text;
      final video = lecture['video'] as File?;
      if (title.isEmpty || video == null) {
        GradientSnackBar.show(
          context,
          'كل محاضرة يجب أن تحتوي على عنوان وفيديو',
        Colors.red.shade400,
        Colors.redAccent.shade700,
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
    for (final lecture in lectures) {
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
                                    color: context.color.bluePinkLight,
                                  ),
                                  const SizedBox(width: 6),
                                  TextApp(
                                    text: 'صورة الكورس',
                                    theme: context.textStyle.copyWith(
                                      fontWeight: FontWeightHelper.bold,
                                      fontSize: 16.sp,
                                      fontFamily: FontFamilyHelper.cairoArabic,
                                      letterSpacing: 0.5,
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
                                              TextApp(
                                                text:  'رفع صورة الكورس',
                                                theme: TextStyle(
                                                  color: context
                                                      .color
                                                      .bluePinkLight,
                                                   fontFamily: FontFamilyHelper
                                                   .cairoArabic,
                                      letterSpacing: 0.5,
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
                                                        color:
                                                            Colors.blueAccent,
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
                              CustomTextField(
                                controller: titleController,
                                lable: 'عنوان الكورس',
                                validator: (value) {
                                  if (value!.isEmpty == true) {
                                    return ' عنوان الكورس مطلوب';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                controller: subTitleController,
                                lable: 'وصف الكورس',
                                validator: (value) {
                                  if (value!.isEmpty == true) {
                                    return 'وصف الكورس مطلوب';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                controller: subjectController,
                                lable: 'المادة',
                                validator: (value) {
                                  if (value!.isEmpty == true) {
                                    return 'اسم المادة مطلوب';
                                  } else {
                                    return null;
                                  }
                                },
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
                              CustomTextField(
                                controller: priceController,
                                lable: 'السعر',
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty == true) {
                                    return 'السعر مطلوب';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(height: 8),
                              BuildDropDown(
                                label: 'الصف الدراسي',
                                value: selectedGrade,
                                items: gradeLevels,
                                onChanged: (v) => setState(() {
                                  selectedGrade = v;
                                  gradeLevelController.text = v!;
                                }),
                              ),
                              const SizedBox(height: 8),
                              BuildDropDown(
                                label: 'الترم',
                                value: selectedTerm,
                                items: terms,
                                onChanged: (v) => setState(() {
                                  selectedTerm = v;
                                  termController.text = v!;
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextApp(
                            text: 'المحاضرات',
                            theme: context.textStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeightHelper.bold,
                              fontFamily: FontFamilyHelper.cairoArabic,
                              letterSpacing: 0.5,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: addLecture,
                            style: TextButton.styleFrom(
                              foregroundColor: context.color.bluePinkLight,
                            ),
                            icon: const Icon(Icons.add_circle_outline),
                            label: const TextApp(text: 'أضف محاضرة',theme: TextStyle( fontFamily: FontFamilyHelper.cairoArabic,
                                      letterSpacing: 0.5,),),
                          ),
                        ],
                      ),

                      ...lectures.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final lecture = entry.value;
                        return BuildLectureCard(
                          idx: idx,
                          lecture: lecture,
                          onRemove: () {
                            lecture['title']?.dispose();
                            setState(() {
                              lectures.removeAt(idx);
                            });
                          },
                        );
                      }),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              if (state is AddCourseLoading)
                ColoredBox(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: SpinKitThreeBounce(
                      color: context.color.bluePinkLight,
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
        height: 55,
        child: ElevatedButton(
          onPressed: submit,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.color.bluePinkLight!,
                  context.color.bluePinkDark!,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              alignment: Alignment.center,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'حفظ الكورس',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
