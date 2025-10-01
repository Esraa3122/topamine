import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/common/screens/under_build_screen.dart';
import 'package:test/core/common/screens/waiting_approval_screen.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/core/routes/base_routes.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:test/features/auth/presentation/refactors/forget_password_body.dart';
import 'package:test/features/auth/presentation/screen/login_screen.dart';
import 'package:test/features/auth/presentation/screen/rule_sign_up_screen.dart';
import 'package:test/features/auth/presentation/screen/sign_up_student_screen.dart';
import 'package:test/features/auth/presentation/screen/sign_up_teacher_screen.dart';
import 'package:test/features/onbording/view/screens/on_boarding_screen.dart';
import 'package:test/features/splash/view/screen/splash_screen.dart';
import 'package:test/features/student/all_courses/presentation/screen/all_courses_page.dart';
import 'package:test/features/student/booking/presentation/screen/booking_student_screen.dart';
import 'package:test/features/student/bot/presentation/screen/chatbot_screen.dart';
import 'package:test/features/student/chat/presentation/screen/chat_screen.dart';
import 'package:test/features/student/course_details/presentation/screen/course_details_screen.dart';
import 'package:test/features/student/edit_profile/presentation/screen/edit_profile_student_screen.dart';
import 'package:test/features/student/home/presentation/screens/home_student_screen.dart';
import 'package:test/features/student/navigation/presentation/screen/navigation_student_screen.dart';
import 'package:test/features/student/notification/notification_screen.dart';
import 'package:test/features/student/profile/presentation/screens/profile_student_screen.dart';
import 'package:test/features/student/profile_teacher/presentation/screen/view_profile_teacher_screen.dart';
import 'package:test/features/student/search/presentation/screen/search_page.dart';
import 'package:test/features/student/video_player/cubit/video_cubit.dart';
import 'package:test/features/student/video_player/presentation/screen/video_payer_page.dart';
import 'package:test/features/student/video_player/presentation/widgets/doc_viewer_page.dart';
import 'package:test/features/student/video_player/presentation/widgets/pdf_viewer_page.dart';
import 'package:test/features/student/video_player/presentation/widgets/text_viewer_page.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:test/features/teacher/add_courses/presentation/cubit/add_course_cubit.dart';
import 'package:test/features/teacher/add_courses/presentation/screen/add_courses_screen.dart';
import 'package:test/features/teacher/booking/presentation/screen/booking_teacher_screen.dart';
import 'package:test/features/teacher/edit_courses/screen/edit_courses_teacher_screen.dart';
import 'package:test/features/teacher/edit_profile/presentation/screens/edit_profile_teacher_screen.dart';
import 'package:test/features/teacher/home/presentation/screen/home_teacher_screen.dart';
import 'package:test/features/teacher/navigation/presentation/screens/navigation_teacher_screen.dart';
import 'package:test/features/teacher/profile/presentation/refactors/about_us_screen.dart';
import 'package:test/features/teacher/profile/presentation/refactors/list_chat.dart';
import 'package:test/features/teacher/profile/presentation/screens/profile_teacher_screen.dart';

class AppRoutes {
  static const String splash = 'splash';
  static const String onBoarding = 'onBoarding';
  static const String login = 'login';
  static const String ruleSignUp = 'ruleSignUp';
  static const String signUpStudent = 'signUpStudent';
  static const String signUpTeacher = 'signUpTeacher';
  static const String forgetPassword = 'forgetPassword';
  static const String navigationStudent = 'navigationStudent';
  static const String navigationTeacher = 'navigationTeacher';
  static const String homePage = 'homePage';
  static const String homeTeacherScreen = 'homeTeacherScreen';
  static const String bookingStudentScreen = 'bookingStudentScreen';
  static const String bookingTeacherScreen = 'bookingTeacherScreen';
  static const String courseDetails = 'courseDetails';
  static const String allCoursesPage = 'allCoursesPage';
  static const String searchPage = 'searchPage';
  static const String teacherProfile2 = 'teacherProfile2';
  static const String teacherProfile = 'teacherProfile';
  static const String studentProfile = 'studentProfile';
  static const String paymentDetailsView = 'paymentDetailsView';
  static const String waitingApproval = 'waitingApproval';
  static const String chat = 'chat';
  static const String chatBoot = 'chatBoot';
  static const String editProfileStudentScreen = 'editProfileStudentScreen';
  static const String editProfileTeacherScreen = 'editProfileTeacherScreen';
  static const String editCoursesTeacherScreen = 'editCoursesTeacherScreen';
  static const String addCoursesTeacherScreen = 'addCoursesTeacherScreen';
  static const String videoPlayerScreen = 'videoPlayerScreen';
  static const String aboutUs = 'aboutUs';
  static const String notifications = 'notifications';
  static const String studentListScreen = 'studentListScreen';
  static const String pdfViewerPage = 'pdfViewerPage';
  static const String docViewerPage = 'docViewerPage';
  static const String textViewerPage = 'textViewerPage';

  static Route<void> onGenerateRoute(RouteSettings settings) {
    final arg = settings.arguments;
    switch (settings.name) {
      case splash:
        return BaseRoute(page: const SplashPage());
      case onBoarding:
        return BaseRoute(page: const OnBoardingScreen());
      case login:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => sl<AuthCubit>(),
            child: const LoginScreen(),
          ),
        );
      case ruleSignUp:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => sl<AuthCubit>(),
            child: const RuleSignUpScreen(),
          ),
        );
      case signUpStudent:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => sl<AuthCubit>(),
            child: const SignUpStudentScreen(),
          ),
        );
      case signUpTeacher:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => sl<AuthCubit>(),
            child: const SignUpTeacherScreen(),
          ),
        );
      case forgetPassword:
        return BaseRoute(page: const ForgetPasswordBody());
      case waitingApproval:
        return BaseRoute(page: const WaitingApprovalScreen());
      case navigationStudent:
        return BaseRoute(page: const NavigationStudentScreen());
      case navigationTeacher:
        return BaseRoute(page: const NavigationTeacherScreen());
      case homePage:
        return BaseRoute(page: const HomePage());
      case homeTeacherScreen:
        return BaseRoute(page: const HomeTeacherScreen());
      case searchPage:
        return BaseRoute(page: const SearchPage());
      case bookingStudentScreen:
        return BaseRoute(page: const BookingStudentScreen());
      case bookingTeacherScreen:
        return BaseRoute(page: const BookingTeacherScreen());
      case allCoursesPage:
        return BaseRoute(page: const AllCoursesPage());
      case courseDetails:
        return BaseRoute(
          page: CourseDetailsScreen(course: arg! as CoursesModel),
        );
      case teacherProfile2:
        return BaseRoute(
          page: ViewProfileTeacherScreen(
            userModel: arg! as UserModel,
          ),
        );
      case teacherProfile:
        return BaseRoute(page: const ProfileTeacherScreen());
      case studentProfile:
        return BaseRoute(page: const ProfileStudentScreen());
      case editProfileStudentScreen:
        return BaseRoute(
          page: EditProfileStudentScreen(
            user: arg! as UserModel,
          ),
        );
      case editProfileTeacherScreen:
        return BaseRoute(
          page: EditProfileTeacherScreen(
            user: arg! as UserModel,
          ),
        );
      case editCoursesTeacherScreen:
        return BaseRoute(
          page: EditCoursesTeacherScreen(
            coursesModel: arg! as CoursesModel,
          ),
        );
      case addCoursesTeacherScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => sl<AddCourseCubit>(),
            child: const AddCourseScreen(),
          ),
        );
case chat:
  final args = arg! as Map<String, dynamic>;
  return BaseRoute(
    page: ChatScreen(
      chatId: args['chatId'] as String,
      otherUser: args['otherUser'] as UserModel, // لازم يتبعت
    ),
  );

      case chatBoot:
        return BaseRoute(page: const ChatbotScreen());
      case videoPlayerScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => sl<VideoCubit>(),
            child: VideoPlayerPage(course: arg! as CoursesModel),
          ),
        );
      case aboutUs:
        return BaseRoute(page: const AboutUsPage());
      case notifications:
        return BaseRoute(page: const NotificationScreen());
      case studentListScreen:
        return BaseRoute(page: const StudentsListScreen());
      case pdfViewerPage:
        return BaseRoute(
          page: PdfViewerPage(pdfUrl: arg! as String),
        );
      case docViewerPage:
        return BaseRoute(
          page: DocViewerPage(docUrl: arg! as String),
        );
      case textViewerPage:
        return BaseRoute(
          page: TextViewerPage(txtUrl: arg! as String),
        );
      default:
        return BaseRoute(page: const PageUnderBuildScreen());
    }
  }
}
