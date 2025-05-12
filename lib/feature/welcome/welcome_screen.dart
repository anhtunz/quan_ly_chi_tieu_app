// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_chi_tieu/product/constants/enums/app_theme_enums.dart';
import 'package:quan_ly_chi_tieu/product/constants/image/image_constants.dart';
import 'package:quan_ly_chi_tieu/product/lang/language_constants.dart';
import 'package:quan_ly_chi_tieu/product/services/language_services.dart';
import 'package:quan_ly_chi_tieu/product/theme/app_theme.dart';
import '../../product/cache/locale_manager.dart';
import '../../product/constants/enums/app_route_enums.dart';
import '../../product/constants/enums/locale_keys_enum.dart';
import '../../product/extension/context_extension.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin(context);
  }

  void checkLogin(BuildContext context) async {
    // ThemeNotifier themeNotifier = context.watch<ThemeNotifier>();
    await LocaleManager.prefrencesInit();

    // String theme = LocaleManager.instance.getStringValue(PreferencesKeys.THEME);
    String token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN);
    int exp = LocaleManager.instance.getIntValue(PreferencesKeys.EXP);
    String lang =
        LocaleManager.instance.getStringValue(PreferencesKeys.LANGUAGE_CODE);
    String theme = LocaleManager.instance.getStringValue(PreferencesKeys.THEME);
    log("Token cu: ${LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN)}");
    log("UID: ${LocaleManager.instance.getStringValue(PreferencesKeys.UID)}");
    log("EXP: ${LocaleManager.instance.getIntValue(PreferencesKeys.EXP)}");
    log("Email: ${LocaleManager.instance.getStringValue(PreferencesKeys.EMAIL)}");
    log("Name: ${LocaleManager.instance.getStringValue(PreferencesKeys.NAME)}");
    log("Lang: ${LocaleManager.instance.getStringValue(PreferencesKeys.LANGUAGE_CODE)}");
    log("Theme: ${LocaleManager.instance.getStringValue(PreferencesKeys.THEME)}");
    if (theme == "") {
      LocaleManager.instance
          .setString(PreferencesKeys.THEME, AppThemes.LIGHT.name);
    }
    if (lang == "") {
      LocaleManager.instance
          .setString(PreferencesKeys.LANGUAGE_CODE, LanguageConstants.VIETNAM);
    }
    int timeNow = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (token != "" && (exp - timeNow) > 7200) {
      context.goNamed(AppRoutes.HOME.name);
      // context.goNamed("notification");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: context.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  Text(
                    appLocalization(context).welcome_title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Ứng dụng quản lý chi tiêu - Nhóm 28",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700], fontSize: 15))
                ],
              ),
              Container(
                height: context.dynamicHeight(0.3333),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      ImageConstants.instance.getImage("welcome"),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      context.pushNamed(AppRoutes.LOGIN.name);
                    },
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface),
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      appLocalization(context).login_title,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: context.lowValue,
                  ),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      context.pushNamed(AppRoutes.REGISTER.name);
                    },
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface),
                        borderRadius: BorderRadius.circular(50)),
                    color: Theme.of(context).colorScheme.primary,
                    child: Text(
                      appLocalization(context).register_title,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
