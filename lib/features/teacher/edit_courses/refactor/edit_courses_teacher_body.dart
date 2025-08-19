import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test/core/common/toast/awesome_snackbar.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/utils/pickFileUtils.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:test/features/teacher/edit_courses/cubit/edit_course_cubit.dart';
import 'package:test/features/teacher/edit_courses/widgets/date_field_teacher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class EditCoursesTeacherBody extends StatefulWidget {
  const EditCoursesTeacherBody({required this.coursesModel, super.key});

  final CoursesModel coursesModel;

  @override
  State<EditCoursesTeacherBody> createState() => _EditCoursesTeacherBodyState();
}

class _EditCoursesTeacherBodyState extends State<EditCoursesTeacherBody> {
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

  final List<String> grades = [
    'الصف الاول الثانوي',
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

  Future<Uint8List?> _generateThumbnail(
    String videoPath, {
    bool isNetwork = false,
  }) async {
    try {
      if (isNetwork) {
        final tempDir = Directory.systemTemp;
        final tempPath =
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
        final uri = Uri.parse(videoPath);
        final request = await HttpClient().getUrl(uri);
        final response = await request.close();

        if (response.statusCode == 200) {
          final file = File(tempPath);
          await response.pipe(file.openWrite());

          return await VideoThumbnail.thumbnailData(
            video: file.path,
            imageFormat: ImageFormat.PNG,
            maxHeight: 100,
            quality: 75,
          );
        } else {
          debugPrint('فشل تحميل الفيديو من الرابط: $videoPath');
          return null;
        }
      } else {
        return await VideoThumbnail.thumbnailData(
          video: videoPath,
          imageFormat: ImageFormat.PNG,
          maxHeight: 100,
          quality: 75,
        );
      }
    } catch (e) {
      debugPrint('خطأ في توليد الصورة المصغّرة: $e');
      return null;
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

    final cubit = context.read<EditCourseCubit>();

    for (final lecture in lectures) {
      final title = (lecture['title'] as TextEditingController).text;
      final video = lecture['video'] as File?;
      final videoUrl = lecture['videoUrl'] as String?;

      if (title.isEmpty || (video == null && videoUrl == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('كل محاضرة يجب أن تحتوي على عنوان وفيديو'),
          ),
        );
        return;
      }

      if (video != null || lecture['word'] != null || lecture['text'] != null) {
        await cubit.uploadLecture(
          title: title,
          video: video ?? File(''),
          word: lecture['word'] as File?,
          text: lecture['text'] as File?,
        );
      } else {
        cubit.lectures.add(
          LectureModel(
            title: title,
            videoUrl: videoUrl!,
            docUrl: lecture['wordUrl'] as String?,
            txtUrl: lecture['textUrl'] as String?,
          ),
        );
      }
    }

    final user = FirebaseAuth.instance.currentUser!;

    final updatedCourse = widget.coursesModel.copyWith(
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

    await cubit.updateCourse(
      course: updatedCourse,
      imageFile: imageFile,
    );

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
      context.pop();
    }
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.coursesModel.title;
    subTitleController.text = widget.coursesModel.subTitle ?? '';
    subjectController.text = widget.coursesModel.subject ?? '';
    priceController.text = widget.coursesModel.price?.toString() ?? '';
    gradeLevelController.text = widget.coursesModel.gradeLevel ?? '';
    termController.text = widget.coursesModel.term ?? '';
    startDate = widget.coursesModel.startDate;
    endDate = widget.coursesModel.endDate;
    selectedGrade = widget.coursesModel.gradeLevel;
    selectedTerm = widget.coursesModel.term;

    if (widget.coursesModel.lectures != null) {
      lectures = widget.coursesModel.lectures!.map((lec) {
        return {
          'title': TextEditingController(text: lec.title),
          'video': null,
          'word': null,
          'text': null,
          'videoUrl': lec.videoUrl,
          'wordUrl': lec.docUrl,
          'textUrl': lec.txtUrl,
        };
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تعديل كورس',
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
      body: BlocConsumer<EditCourseCubit, EditCourseState>(
        listener: (context, state) {
          if (state is EditCourseSuccess) {
            AwesomeSnackBar.show(
              context: context,
              title: 'Success!',
              message: 'تم التعديل بنجاح',
              contentType: ContentType.success,
            );
          } else if (state is EditCourseError) {
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
                          options: RoundedRectDottedBorderOptions(
                            radius: const Radius.circular(8),
                            dashPattern: [6, 3],
                            color: context.color.bluePinkLight!,
                            strokeWidth: 1.5,
                            padding: EdgeInsets.zero,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            alignment: Alignment.center,
                            child: imageFile == null
                                ? (widget.coursesModel.imageUrl != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            widget.coursesModel.imageUrl!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 150,
                                          ),
                                        )
                                      : Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.camera_alt_outlined,
                                              size: 40,
                                              color:
                                                  context.color.bluePinkLight,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'رفع صورة الكورس',
                                              style: TextStyle(
                                                color:
                                                    context.color.bluePinkLight,
                                              ),
                                            ),
                                          ],
                                        ))
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
                        style: TextStyle(
                          color: context.color.textColor,
                        ),
                        decoration: InputDecoration(
                          labelText: 'عنوان الكورس',
                          labelStyle: TextStyle(
                            color: context.color.textColor,
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.color.bluePinkLight!,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.color.bluePinkLight!,
                            ),
                          ),
                        ),
                        validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: subTitleController,
                        style: TextStyle(
                          color: context.color.textColor,
                        ),
                        decoration: InputDecoration(
                          labelText: 'العنوان الفرعي',
                          labelStyle: TextStyle(
                            color: context.color.textColor,
                          ),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.color.bluePinkLight!,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.color.bluePinkLight!,
                            ),
                          ),
                        ),
                        validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: subjectController,
                        style: TextStyle(
                          color: context.color.textColor,
                        ),
                        decoration: InputDecoration(
                          labelText: 'المادة',
                          labelStyle: TextStyle(
                            color: context.color.textColor,
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.color.bluePinkLight!,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.color.bluePinkLight!,
                            ),
                          ),
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
                              child: DateField(
                                label: 'تاريخ النهاية',
                                date: endDate,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: priceController,
                        style: TextStyle(
                          color: context.color.textColor,
                        ),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'السعر',
                          labelStyle: TextStyle(
                            color: context.color.textColor,
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.color.bluePinkLight!,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.color.bluePinkLight!,
                            ),
                          ),
                        ),
                        validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: gradeLevelController,
                        style: TextStyle(
                          color: context.color.textColor,
                        ),
                        decoration: InputDecoration(
                          labelText: 'الصف الدراسي',
                          labelStyle: TextStyle(
                            color: context.color.textColor,
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.color.bluePinkLight!,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.color.bluePinkLight!,
                            ),
                          ),
                        ),
                        validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: termController,
                        style: TextStyle(
                          color: context.color.textColor,
                        ),
                        decoration: InputDecoration(
                          labelText: 'الترم',
                          labelStyle: TextStyle(
                            color: context.color.textColor,
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.color.bluePinkLight!,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.color.bluePinkLight!,
                            ),
                          ),
                        ),
                        validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'المحاضرات',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: context.color.textColor,
                            ),
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: context.color.bluePinkLight,
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
                          shadowColor: context.color.bluePinkLight!.withOpacity(
                            0.5,
                          ),
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
                                        color: context.color.bluePinkLight,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        'محاضرة ${idx + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
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
                                  style: TextStyle(
                                    color: context.color.textColor,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'اسم المحاضرة',
                                    labelStyle: TextStyle(
                                      color: context.color.textColor,
                                    ),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: context.color.bluePinkLight!,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: context.color.bluePinkLight!,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'فيديو',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    radius: const Radius.circular(8),
                                    dashPattern: const [8, 4],
                                    strokeWidth: 2,
                                    color: context.color.bluePinkLight!,
                                    padding: const EdgeInsets.all(16),
                                  ),
                                  child: InkWell(
                                    onTap: () => pickLectureFile(idx, 'video'),
                                    child: lecture['video'] != null
                                        ? FutureBuilder<Uint8List?>(
                                            future: _generateThumbnail(
                                              (lecture['video'] as File).path,
                                              isNetwork: false,
                                            ),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const SizedBox(
                                                  height: 100,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                );
                                              }
                                              if (snapshot.hasData) {
                                                return Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      child: Image.memory(
                                                        snapshot.data!,
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: 100,
                                                      ),
                                                    ),
                                                    const Icon(
                                                      Icons.play_circle_fill,
                                                      size: 40,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                );
                                              }
                                              return Icon(
                                                Icons.videocam,
                                                color:
                                                    context.color.bluePinkLight,
                                              );
                                            },
                                          )
                                        : (lecture['videoUrl'] != null
                                              ? FutureBuilder<Uint8List?>(
                                                  future: _generateThumbnail(
                                                    lecture['videoUrl']
                                                        .toString(),
                                                    isNetwork: true,
                                                  ),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const SizedBox(
                                                        height: 100,
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    }
                                                    if (snapshot.hasData) {
                                                      return Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                            child: Image.memory(
                                                              snapshot.data!,
                                                              fit: BoxFit.cover,
                                                              width: double
                                                                  .infinity,
                                                              height: 100,
                                                            ),
                                                          ),
                                                          const Icon(
                                                            Icons
                                                                .play_circle_fill,
                                                            size: 40,
                                                            color: Colors.white,
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                    return Icon(
                                                      Icons.videocam,
                                                      color: context
                                                          .color
                                                          .bluePinkLight,
                                                    );
                                                  },
                                                )
                                              : Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.videocam,
                                                      size: 32,
                                                      color: context
                                                          .color
                                                          .bluePinkLight,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'رفع فيديو',
                                                      style: TextStyle(
                                                        color: context
                                                            .color
                                                            .bluePinkLight,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                  ),
                                ),

                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DottedBorder(
                                        options: RoundedRectDottedBorderOptions(
                                          radius: Radius.circular(8),
                                          dashPattern: const [8, 4],
                                          strokeWidth: 2,
                                          color: context.color.bluePinkLight!,
                                          padding: EdgeInsets.all(16),
                                        ),
                                        child: InkWell(
                                          onTap: () =>
                                              pickLectureFile(idx, 'text'),
                                          child: lecture['text'] != null
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.description,
                                                      color: context
                                                          .color
                                                          .bluePinkLight,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      lecture['text'].path
                                                          .split('/')
                                                          .last
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: context
                                                            .color
                                                            .bluePinkLight,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : (lecture['textUrl'] != null
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.description,
                                                            color:
                                                                Colors.yellow,
                                                          ),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                          Text(
                                                            'ملف TXT موجود',
                                                            style: TextStyle(
                                                              color: context
                                                                  .color
                                                                  .bluePinkLight,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .cloud_upload_outlined,
                                                            size: 28,
                                                            color: context
                                                                .color
                                                                .bluePinkLight,
                                                          ),
                                                          SizedBox(height: 4),
                                                          Text(
                                                            'رفع .txt',
                                                            style: TextStyle(
                                                              color: context
                                                                  .color
                                                                  .bluePinkLight,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: DottedBorder(
                                        options: RoundedRectDottedBorderOptions(
                                          radius: Radius.circular(8),
                                          dashPattern: [8, 4],
                                          strokeWidth: 2,
                                          color: context.color.bluePinkLight!,
                                          padding: EdgeInsets.all(16),
                                        ),
                                        child: InkWell(
                                          onTap: () =>
                                              pickLectureFile(idx, 'word'),
                                          child: lecture['text'] != null
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.description,
                                                      color: context
                                                          .color
                                                          .bluePinkLight!,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      lecture['text'].path
                                                          .split('/')
                                                          .last
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: context
                                                            .color
                                                            .bluePinkLight,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : (lecture['textUrl'] != null
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .picture_as_pdf,
                                                            color: Colors.red,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text(
                                                            'ملف doc موجود',
                                                            style: TextStyle(
                                                              color: context
                                                                  .color
                                                                  .bluePinkLight!,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .cloud_upload_outlined,
                                                            size: 28,
                                                            color: context
                                                                .color
                                                                .bluePinkLight!,
                                                          ),
                                                          SizedBox(height: 4),
                                                          Text(
                                                            'رفع .doc',
                                                            style: TextStyle(
                                                              color: context
                                                                  .color
                                                                  .bluePinkLight!,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      )),
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
                            backgroundColor: context.color.bluePinkLight,
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
              if (state is EditCourseLoading)
                Container(
                  color: Colors.black.withOpacity(0.6),
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
    );
  }
}
