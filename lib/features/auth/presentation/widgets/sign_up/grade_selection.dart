import 'package:flutter/material.dart';
import 'package:test/core/extensions/context_extension.dart';

class GradeSelection extends StatefulWidget {

  const GradeSelection({
    required this.genderController, super.key,
  });
  final TextEditingController genderController;

  @override
  State<GradeSelection> createState() => _GradeSelectionState();
}

class _GradeSelectionState extends State<GradeSelection> {
  String? selectedGender;
  List<String> gradeList = ['grade1', 'grade2', 'grade3'];
  List<String> governorate = [
    'الإسكندرية',
    'الإسماعيلية',
    'أسوان',
    'أسيوط',
    'الأقصر',
    'الغردقة',
    'دمنهور',
    'بني سويف',
    'بورسعيد',
    'الطور',
    'الجيزة',
    'الدقهليه',
    'دمياط',
    'سوهاج',
    'السويس',
    'شمال سيناء',
    'الشرقية',
    'الغربية',
    'الفيوم',
    'القاهرة',
    'القليوبية',
    'قنا',
    'كفر الشيخ',
    'مطروح',
    'المنوفية',
    'المنيا',
    'الوادي الجديد',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
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
        borderSide: const BorderSide(color: Colors.red ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      value: selectedGender,
      hint: const Text('Select Gender'),
      isExpanded: true,
      items: gradeList.map((String gender) {
        return DropdownMenuItem(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedGender = newValue;
    
          widget.genderController.text = newValue ?? '';
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select gender';
        }
        return null;
      },
    );
  }
}
