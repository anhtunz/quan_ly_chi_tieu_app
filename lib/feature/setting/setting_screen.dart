import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/feature/setting/change_password.dart';
import 'package:quan_ly_chi_tieu/product/extension/context_extension.dart';
import '../../product/constants/icon/icon_constants.dart';
import 'change_infomation.dart';
import 'setting_bloc.dart';
import '../../product/base/bloc/base_bloc.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late SettingBloc settingBloc;

  @override
  void initState() {
    super.initState();
    settingBloc = BlocProvider.of(context);
    settingBloc.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cài đặt"),
        centerTitle: true,
      ),
      body: StreamBuilder<Map<String, dynamic>>(
          stream: settingBloc.streamUserInfo,
          builder: (context, userInfoSnapshot) {
            if (userInfoSnapshot.data == null) {
              settingBloc.getUserInfo();
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: context.mediumValue),
                    CircleAvatar(
                      backgroundColor: Theme.of(context).focusColor,
                      radius: 70,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).highlightColor,
                        radius: 60,
                        child: CircleAvatar(
                          radius: 50,
                          child: Text(
                            "T",
                            style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.lowValue),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userInfoSnapshot.data?['name'] ?? "",
                          style: const TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 26),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text(userInfoSnapshot.data?['email'] ?? "")],
                    ),
                    SizedBox(height: context.mediumValue),
                    cardContent(
                      Icons.account_circle_rounded,
                      "Thông tin cá nhân",
                    ),
                    SizedBox(height: context.lowValue),
                    cardContent(
                      Icons.lock_outline,
                      "Đổi mật khẩu",
                    ),
                    SizedBox(height: context.lowValue),
                    cardContent(
                      Icons.settings_outlined,
                      "Cài đặt",
                    ),
                    SizedBox(height: context.lowValue),
                    cardContent(
                      Icons.logout_outlined,
                      "Đăng xuất",
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  cardContent(IconData icon, String content) {
    return GestureDetector(
      onTap: () async {
        if (icon == Icons.account_circle_rounded) {
          changeUserInfomation(context, settingBloc);
        } else if (icon == Icons.lock_outline) {
          changePassword(context, settingBloc);
        } else if (icon == Icons.settings_outlined) {
          // context.push(ApplicationConstants.DEVICE_NOTIFICATIONS_SETTINGS);
        } else if (icon == Icons.bar_chart_rounded) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => BarChartSample2(),
          //   ),
          // );
        } else {
          settingBloc.logout(context);
        }
      },
      child: Card(
        color: Theme.of(context).colorScheme.onInverseSurface,
        margin: const EdgeInsets.only(left: 35, right: 35, bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: ListTile(
          leading: IconConstants.instance.getMaterialIcon(icon),
          title: Text(
            content,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_outlined,
          ),
        ),
      ),
    );
  }
}
