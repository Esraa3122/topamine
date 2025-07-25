// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:test/core/common/widgets/text_app.dart';
// import 'package:test/core/extensions/context_extension.dart';
// import 'package:test/core/language/lang_keys.dart';
// import 'package:test/core/style/fonts/font_weight_helper.dart';

// class NotificationsChange extends StatelessWidget {
//   const NotificationsChange({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(
//           Icons.notifications_active,
//           color: context.color.textColor,
//         ),
//         SizedBox(width: 10.w),
//         TextApp(
//           text: context.translate(LangKeys.notifications),
//           theme: context.textStyle.copyWith(
//             fontSize: 18.sp,
//             fontWeight: FontWeightHelper.regular,
//           ),
//         ),
//         const Spacer(),

//         // radio buttons
//         ValueListenableBuilder(
//           valueListenable: FirebaseCloudMessaging().isNotificationSubscribe,
//           builder: (_, value, __) {
//             return Transform.scale(
//               scale: 0.75,
//               child: Switch.adaptive(
//                 value: value,
//                 inactiveTrackColor: const Color(0xff262626),
//                 activeColor: Colors.green,
//                 onChanged: (value) {
//                   FirebaseCloudMessaging().controllerForUserSubscribe(context);

//                 },
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
