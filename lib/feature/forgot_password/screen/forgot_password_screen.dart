import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:quan_ly_chi_tieu/product/cache/locale_manager.dart';
import 'package:quan_ly_chi_tieu/product/constants/enums/locale_keys_enum.dart';
import 'package:quan_ly_chi_tieu/product/services/toast_service.dart';

import '../../../product/extension/context_extension.dart';
import '../bloc/forgot_password_bloc.dart';
import '../../../product/base/bloc/base_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late ForgotPasswordBloc bloc;
  ToastService toastService = ToastService();
  final formKey = GlobalKey<FormState>();
  final resetPassFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  int currentStep = 0;
  bool isEmailDisable = false;
  bool isClearOTP = false;
  bool isOTPDisable = true;
  Timer? timer;
  int? otpValue;
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  String? password;
  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context);
    loadCountdown();
  }

  bool isButtonDisabled = false;
  int _countdown = 60;

  void startCountdown() async {
    final random = Random();
    final randomNumber = 10000 + random.nextInt(90000);
    dev.log("Random: $randomNumber");
    String email = emailController.text;

    bloc.sendOTPMail(context, email, randomNumber.toString());
    setState(() {
      isButtonDisabled = true;
      _countdown = 60;
      otpValue = randomNumber;
    });
    _saveEndTime(60);
    _saveRandomNumber(randomNumber);
    _startTimer();
  }

  void _saveRandomNumber(int number) async {
    LocaleManager.instance.setInt(PreferencesKeys.OTP_VALUE, number);
  }

  void loadCountdown() async {
    final endTime =
        LocaleManager.instance.getIntValue(PreferencesKeys.OTP_ENDTIME);

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final remainingTime = (endTime - currentTime) ~/ 1000;
    final otp = LocaleManager.instance.getIntValue(PreferencesKeys.OTP_VALUE);
    if (remainingTime > 0) {
      setState(() {
        isButtonDisabled = true;
        _countdown = remainingTime;
        otpValue = otp;
      });
      _startTimer();
    } else {
      _clearPrefs();
    }
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown <= 0) {
        setState(() {
          isButtonDisabled = false;
        });
        _clearPrefs();
        timer.cancel();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  void _saveEndTime(int seconds) async {
    final endTime = DateTime.now().millisecondsSinceEpoch + (seconds * 1000);
    LocaleManager.instance.setInt(PreferencesKeys.OTP_ENDTIME, endTime);
  }

  Future<void> _clearPrefs() async {
    final endTime =
        LocaleManager.instance.getIntValue(PreferencesKeys.OTP_ENDTIME);
    final storedOtpValue =
        LocaleManager.instance.getIntValue(PreferencesKeys.OTP_VALUE);

    if (endTime != null) {
      await LocaleManager.instance
          .deleteStringValue(PreferencesKeys.OTP_ENDTIME);
    }
    if (storedOtpValue != null) {
      await LocaleManager.instance.deleteStringValue(PreferencesKeys.OTP_VALUE);
    }
    setState(() {
      otpValue = null;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quên mật khẩu"),
        centerTitle: true,
      ),
      body: Stepper(
        currentStep: currentStep,
        steps: [
          Step(title: Text("Nhập email"), content: stepEmai()),
          Step(title: Text("Nhập OTP"), content: stepOTP()),
          Step(title: Text("Đổi mật khẩu"), content: stepResetPassword()),
        ],
        onStepContinue: () {
          if (currentStep == 0) {
            if (formKey.currentState!.validate()) {
              isEmailDisable = true;
              bloc.sinkisEmailDisable.add(isEmailDisable);
              setState(() {
                currentStep += 1;
              });
            }
          }
          if (currentStep == 1) {
            if (isOTPDisable == false) {
              setState(() {
                currentStep += 1;
              });
            }
          }
          if (currentStep == 2) {
            if (resetPassFormKey.currentState!.validate()) {
              String email = emailController.text;
              String password = newPasswordController.text;
              bloc.refreshPassword(context, email, password);
            }
          }
        },
        onStepCancel: () {
          setState(() {
            currentStep -= 1;
          });
        },
      ),
    );
  }

  stepEmai() {
    return Form(
      key: formKey,
      child: StreamBuilder<bool>(
        stream: bloc.streamisEmailDisable,
        initialData: isEmailDisable,
        builder: (context, isEmailDisableSnapshot) {
          return TextFormField(
            readOnly: isEmailDisableSnapshot.data!,
            controller: emailController,
            decoration: InputDecoration(
                label: Text("Email"),
                hintText: "Nhập email",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return "Email không được để trống";
              }
              // Email format validation
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(text)) {
                return "Email không hợp lệ";
              }
              return null;
            },
          );
        },
      ),
    );
  }

  stepOTP() {
    return Column(
      children: [
        StreamBuilder<bool>(
          stream: bloc.streamisClearOTP,
          initialData: isClearOTP,
          builder: (context, isClearOTPSnapshot) {
            return StreamBuilder<bool>(
              stream: bloc.streamisOTPDisable,
              initialData: isOTPDisable,
              builder: (context, isOTPDisableSnapshot) {
                return OtpTextField(
                  enabled: isOTPDisableSnapshot.data!,
                  clearText: isClearOTPSnapshot.data!,
                  numberOfFields: 5,
                  borderColor: Color(0xFF512DA8),
                  showFieldAsBox: true,
                  // onCodeChanged: (String code) {},
                  onSubmit: (String verificationCode) async {
                    isClearOTP = false;
                    bloc.sinkisClearOTP.add(isClearOTP);
                    if (verificationCode == otpValue.toString()) {
                      setState(() {
                        currentStep = 2;
                      });

                      isOTPDisable = false;
                      bloc.sinkisOTPDisable.add(isOTPDisable);
                    } else {
                      isClearOTP = true;
                      bloc.sinkisClearOTP.add(isClearOTP);
                      toastService.showErrorToast(
                          context: context,
                          title: "Thông báo",
                          message: "Mã OTP nhập vào chưa đúng");
                    }
                  },
                );
              },
            );
          },
        ),
        Center(
          child: TextButton(
            onPressed: isButtonDisabled
                ? null
                : () {
                    startCountdown();
                  },
            child: Text(
              isButtonDisabled ? "Gửi lại mã ($_countdown)" : "Gửi lại mã",
            ),
          ),
        )
      ],
    );
  }

  stepResetPassword() {
    return Form(
      key: resetPassFormKey,
      child: Column(
        children: [
          SizedBox(height: context.lowValue),
          StreamBuilder<bool>(
            stream: bloc.streamIsShowPassword,
            initialData: isPasswordVisible,
            builder: (context, isShowPasswordSnapshot) {
              return TextFormField(
                controller: newPasswordController,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  password = value;
                },
                validator: (newPassword) {
                  if (newPassword == "null" || newPassword!.isEmpty) {
                    return "Mật khẩu mới không được để trống";
                  }
                  if (newPassword.length < 6) {
                    return "Mật khẩu mới phải lớn hơn 6 kí tự";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: Text("Mật khẩu mới"),
                  hintText: "Nhập mật khẩu mới",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isShowPasswordSnapshot.data!
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      isPasswordVisible = !isPasswordVisible;
                      bloc.sinkIsShowPassword.add(isPasswordVisible);
                    },
                  ),
                ),
              );
            },
          ),
          SizedBox(height: context.lowValue),
          StreamBuilder<bool>(
            stream: bloc.streamIsConfirmPassword,
            initialData: isConfirmPasswordVisible,
            builder: (context, isConfirmPasswordSnapshot) {
              return TextFormField(
                controller: confirmPasswordController,
                textInputAction: TextInputAction.next,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Mật khẩu không được để trống";
                  }
                  if (text != password) {
                    return "Mật khẩu không khớp";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: Text("Xác nhận mật khẩu"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordSnapshot.data!
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      bloc.sinkIsShowPassword.add(isConfirmPasswordVisible);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
