import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/common/screens/under_build_screen.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/core/routes/base_routes.dart';
import 'package:test/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:test/features/auth/presentation/refactors/forget_password_body.dart';
import 'package:test/features/auth/presentation/screen/login_screen.dart';
import 'package:test/features/auth/presentation/screen/rule_sign_up_screen.dart';
import 'package:test/features/auth/presentation/screen/sign_up_student_screen.dart';
import 'package:test/features/auth/presentation/screen/sign_up_teacher_screen.dart';
import 'package:test/features/booking/presentation/screen/booking_page.dart';
import 'package:test/features/checkout/presentation/views/payment_details.dart';
import 'package:test/features/course_details/presentation/screen/course_details.dart';
import 'package:test/features/home/data/model/coures_model.dart';
import 'package:test/features/home/presentation/screens/home_page.dart';
import 'package:test/features/home/presentation/widgets/all_courses_page.dart';
import 'package:test/features/navigation/presentation/screen/navigation_teacher_app_bar_screen.dart';
import 'package:test/features/onbording/view/screens/on_boarding_screen.dart';
import 'package:test/features/search/presentation/screen/search_page.dart';
import 'package:test/features/splash/view/screen/splash_screen.dart';
import 'package:test/features/student/profile/presentation/screens/profile_student_screen.dart';
import 'package:test/features/student/profile/presentation/screens/student_profile2.dart';
import 'package:test/features/teacher/profile/presentation/screens/profile_teacher_screen.dart';
import 'package:test/features/teacher/profile/presentation/screens/teacher_profile2.dart';

class AppRoutes {
  static const String splash = 'splash';
  static const String onBoarding = 'onBoarding';
  static const String login = 'login';
  static const String ruleSignUp = 'ruleSignUp';
  static const String signUpStudent = 'signUpStudent';
  static const String signUpTeacher = 'signUpTeacher';
  static const String forgetPassword = 'forgetPassword';
  static const String navigation = 'navigation';
  static const String homePage = 'homePage';
  static const String bookingPage = 'bookingPage';
  static const String courseDetails = 'courseDetails';
  static const String allCoursesPage = 'allCoursesPage';
  static const String searchPage = 'searchPage';
  static const String studentProfile2 = 'studentProfile2';
  static const String teacherProfile2 = 'teacherProfile2';
  static const String teacherProfile = 'teacherProfile';
  static const String studentProfile = 'studentProfile';
  static const String paymentDetailsView = 'paymentDetailsView';

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
      case navigation:
        return BaseRoute(page: const NavigationScreen());
      case homePage:
        return BaseRoute(page: const HomePage());
      case searchPage:
        return BaseRoute(page: const SearchPage());
      case bookingPage:
        return BaseRoute(page: const BookingPage());
      case allCoursesPage:
        return BaseRoute(page: const AllCoursesPage());
      case courseDetails:
        return BaseRoute(page: CourseDetails(course: arg! as CourseModel));
      case studentProfile2:
        return BaseRoute(page: const StudentProfile2());
      case teacherProfile2:
        return BaseRoute(page: const TeacherProfile2());
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
