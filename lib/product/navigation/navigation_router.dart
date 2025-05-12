import 'package:go_router/go_router.dart';
import 'package:quan_ly_chi_tieu/feature/home/bloc/home_bloc.dart';
import 'package:quan_ly_chi_tieu/feature/home/screen/label_manager_screen.dart';
import 'package:quan_ly_chi_tieu/feature/scan_image/scan_picker_bloc.dart';
import 'package:quan_ly_chi_tieu/feature/scan_image/scan_picker_screeen.dart';
import '../../feature/forgot_password/bloc/forgot_password_bloc.dart';
import '../../feature/forgot_password/screen/forgot_password_screen.dart';
import '../../feature/register/bloc/register_bloc.dart';
import '../../feature/register/screen/register_screen.dart';
import '../../feature/welcome/welcome_screen.dart';
import '../shared/shared_transition.dart';
import '../../feature/error/not_found_screen.dart';
import '../../feature/login/bloc/login_bloc.dart';
import '../../feature/login/screen/login_screen.dart';
import '../../feature/main/main_bloc.dart';
import '../../feature/main/main_screen.dart';
import '../base/bloc/base_bloc.dart';
import '../constants/enums/app_route_enums.dart';
import '../constants/navigation/navigation_constants.dart';

GoRouter goRouter() {
  return GoRouter(
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => const NotFoundScreen(),
    initialLocation: NavigationConstants.WELCOME_PATH,
    routes: <RouteBase>[
      GoRoute(
        path: NavigationConstants.WELCOME_PATH,
        name: AppRoutes.WELCOME.name,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: NavigationConstants.LOGIN_PATH,
        name: AppRoutes.LOGIN.name,
        pageBuilder: (context, state) => CustomTransitionPage(
            child: BlocProvider(
              child: const LoginScreen(),
              blocBuilder: () => LoginBloc(),
            ),
            transitionsBuilder: transitionsRightToLeft),
      ),
      GoRoute(
        path: NavigationConstants.REGISTER_PATH,
        name: AppRoutes.REGISTER.name,
        pageBuilder: (context, state) => CustomTransitionPage(
            child: BlocProvider(
              child: const RegisterScreen(),
              blocBuilder: () => RegisterBloc(),
            ),
            transitionsBuilder: transitionsRightToLeft),
      ),
      GoRoute(
        path: NavigationConstants.HOME_PATH,
        name: AppRoutes.HOME.name,
        builder: (context, state) => BlocProvider(
          child: const MainScreen(),
          blocBuilder: () => MainBloc(),
        ),
      ),
      GoRoute(
        path: NavigationConstants.TEST_PATH,
        name: AppRoutes.TEST.name,
        builder: (context, state) => BlocProvider(
          child: const ScanPickerScreeen(),
          blocBuilder: () => ScanPickerBloc(),
        ),
      ),
      GoRoute(
        path: NavigationConstants.FORGOT_PASSWORD_PATH,
        name: AppRoutes.FORGOT_PASSWORD.name,
        pageBuilder: (context, state) => CustomTransitionPage(
            child: BlocProvider(
              child: const ForgotPasswordScreen(),
              blocBuilder: () => ForgotPasswordBloc(),
            ),
            transitionsBuilder: transitionsRightToLeft),
      ),
      GoRoute(
          path: NavigationConstants.LABEL_MANAGER_PATH,
          name: AppRoutes.LABEL_MANAGER.name,
          pageBuilder: (context, state) {
            final value = state.extra! as int;
            return CustomTransitionPage(
              child: BlocProvider(
                child: LabelManagerScreen(value: value,),
                blocBuilder: () => HomeBloc(),
              ),
              transitionsBuilder: transitionsBottomToTop,
            );
          }),
      // GoRoute(
      //   path: ApplicationConstants.SETTINGS_PATH,
      //   name: AppRoutes.SETTINGS.name,
      //   pageBuilder: (context, state) => CustomTransitionPage(
      //     child: BlocProvider(
      //       child: const SettingsScreen(),
      //       blocBuilder: () => SettingsBloc(),
      //     ),
      //     transitionsBuilder: transitionsBottomToTop,
      //   ),
      // ),
      // GoRoute(
      //   path: '${ApplicationConstants.DEVICES_UPDATE_PATH}/:thingID',
      //   name: AppRoutes.DEVICE_UPDATE.name,
      //   pageBuilder: (context, state) => CustomTransitionPage(
      //       child: BlocProvider(
      //         child: DeviceUpdateScreen(
      //           thingID: state.pathParameters['thingID']!,
      //         ),
      //         blocBuilder: () => DeviceUpdateBloc(),
      //       ),
      //       transitionsBuilder: transitionsBottomToTop),
      // ),
      // GoRoute(
      //     path: '${ApplicationConstants.GROUP_PATH}/:groupId',
      //     name: AppRoutes.GROUP_DETAIL.name,
      //     pageBuilder: (context, state) {
      //       final groupId = state.pathParameters['groupId']!;
      //       final role = state.extra! as String;
      //       return CustomTransitionPage(
      //           child: BlocProvider(
      //             child: DetailGroupScreen(group: groupId, role: role),
      //             blocBuilder: () => DetailGroupBloc(),
      //           ),
      //           transitionsBuilder: transitionsRightToLeft);
      //     }),
    ],
  );
}
