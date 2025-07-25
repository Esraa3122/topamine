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
import 'package:test/features/checkout/presentation/views/payment_details.dart';
import 'package:test/features/onbording/view/screens/on_boarding_screen.dart';
import 'package:test/features/splash/view/screen/splash_screen.dart';
import 'package:test/features/student/all_courses/presentation/screen/all_courses_page.dart';
import 'package:test/features/student/booking/presentation/screen/booking_student_screen.dart';
import 'package:test/features/student/course_details/presentation/screen/course_details_screen.dart';
import 'package:test/features/student/home/data/model/courses_model.dart';
import 'package:test/features/student/home/presentation/screens/home_student_screen.dart';
import 'package:test/features/student/navigation/presentation/screen/navigation_student_screen.dart';
import 'package:test/features/student/profile/presentation/screens/profile_student_screen.dart';
import 'package:test/features/student/profile_teacher/presentation/screen/view_profile_teacher_screen.dart';
import 'package:test/features/student/search/presentation/screen/search_page.dart';
import 'package:test/features/teacher/booking/presentation/screen/booking_teacher_screen.dart';
import 'package:test/features/teacher/navigation/presentation/screens/navigation_teacher_screen.dart';
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
      case paymentDetailsView:
        return BaseRoute(page: const PaymentDetailsView());
      default:
        return BaseRoute(page: const PageUnderBuildScreen());
    }
  }
}
