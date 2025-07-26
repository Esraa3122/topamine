// class LectureModel {
//   LectureModel({
//     required this.id,
//     required this.title,
//     required this.videoUrl,
//     required this.pdfUrl,
//     required this.txtUrl,
//   });

//   factory LectureModel.fromJson(Map<String, dynamic> json) {
//     return LectureModel(
//       id: json['id']?.toString() ?? '',
//       title: json['title']?.toString() ?? '',
//       videoUrl: json['videoUrl']?.toString() ?? '',
//       pdfUrl: json['pdfUrl']?.toString() ?? '',
//       txtUrl: json['txtUrl']?.toString() ?? '',
//     );
//   }

//   final String id;
//   final String title;
//   final String videoUrl;
//   final String pdfUrl;
//   final String txtUrl;

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'videoUrl': videoUrl,
//       'pdfUrl': pdfUrl,
//       'txtUrl': txtUrl,
//     };
//   }
// }
