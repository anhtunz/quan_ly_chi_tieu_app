import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:quan_ly_chi_tieu/feature/calendar/calendar_bloc.dart';
import 'package:quan_ly_chi_tieu/feature/calendar/calendar_screen.dart';
import 'package:quan_ly_chi_tieu/feature/home/bloc/home_bloc.dart';
import 'package:quan_ly_chi_tieu/feature/home/screen/home_screen.dart';
import 'package:quan_ly_chi_tieu/feature/setting/setting_bloc.dart';
import 'package:quan_ly_chi_tieu/feature/setting/setting_screen.dart';
import 'package:quan_ly_chi_tieu/feature/statistics/statistics_bloc.dart';
import 'package:quan_ly_chi_tieu/feature/statistics/statistics_screen.dart';

import '../../product/base/bloc/base_bloc.dart';
import '../../product/constants/icon/icon_constants.dart';
import 'main_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainBloc mainBloc;
  PersistentTabController persistentTabController =
      PersistentTabController(initialIndex: 0);
  @override
  void initState() {
    super.initState();
    mainBloc = BlocProvider.of(context);
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: IconConstants.instance.getMaterialIcon(Icons.edit),
        title: "Nhập vào",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
        inactiveIcon:
            IconConstants.instance.getMaterialIcon(Icons.edit_outlined),
      ),
      PersistentBottomNavBarItem(
        icon: IconConstants.instance.getMaterialIcon(Icons.calendar_month),
        title: "Lịch",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
        inactiveIcon: IconConstants.instance
            .getMaterialIcon(Icons.calendar_month_outlined),
      ),
      PersistentBottomNavBarItem(
        icon: IconConstants.instance.getMaterialIcon(Icons.pie_chart),
        title: "Thống kê",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
        inactiveIcon:
            IconConstants.instance.getMaterialIcon(Icons.pie_chart_outline),
      ),
      PersistentBottomNavBarItem(
        icon: IconConstants.instance.getMaterialIcon(Icons.settings),
        title: "Cài đặt",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
        inactiveIcon:
            IconConstants.instance.getMaterialIcon(Icons.settings_outlined),
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      BlocProvider(
        child: const HomeScreen(),
        blocBuilder: () => HomeBloc(),
      ),
      BlocProvider(
        child: const CalendarScreen(),
        blocBuilder: () => CalendarBloc(),
      ),
      BlocProvider(
        child: const StatisticsScreen(),
        blocBuilder: () => StatisticsBloc(),
      ),
      BlocProvider(
        child: const SettingScreen(),
        blocBuilder: () => SettingBloc(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: persistentTabController,
        screens: _buildScreens(),
        items: _navBarsItems(),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: false,
        animationSettings: const NavBarAnimationSettings(
          navBarItemAnimation: ItemAnimationSettings(
            duration: Duration(milliseconds: 200),
            curve: Curves.bounceInOut,
          ),
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            animateTabTransition: true,
            curve: Curves.bounceInOut,
            duration: Duration(milliseconds: 200),
          ),
        ),
        navBarStyle: NavBarStyle.style1,
      ),
    );
  }
}
