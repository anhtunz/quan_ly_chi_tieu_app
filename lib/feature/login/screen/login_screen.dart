import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../product/constants/enums/app_route_enums.dart';
import '../../../product/constants/image/image_constants.dart';
import '../../../product/services/language_services.dart';
import '../../../product/extension/context_extension.dart';
import '../bloc/login_bloc.dart';
import '../../../product/base/bloc/base_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc loginBloc;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  // String? _password;
  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    // toastService.showSuccessToast(
    //     context: context, title: "Thong bao", message: "Test thong bao");
    if (_formKey.currentState!.validate()) {
      // Form is valid, retrieve values from controllers
      final email = _emailController.text;
      final password = _passwordController.text;
      // final name = _nameController.text;
      loginBloc.login(context, email, password);
      // registerBloc.registerUser(context, name, email, password);
      // Example: Print values (you can use them as needed)
      // print('Name: $name');
      log('Email: $email');
      log('Password: $password');
      // print('Confirm Password: $confirmPassword');
      // You can now use these values (e.g., send to an API, save to a database, etc.)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
      ),
      body: SizedBox(
        height: context.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        appLocalization(context).login_title,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: context.lowValue,
                      ),
                      Text(appLocalization(context).login_body,
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[700])),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                                label:
                                    Text(appLocalization(context).email_label),
                                hintText: appLocalization(context).email_hint,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return appLocalization(context).email_not_empty;
                              }
                              // Email format validation
                              final emailRegex =
                                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegex.hasMatch(text)) {
                                return appLocalization(context).email_error;
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: context.lowValue,
                          ),
                          StreamBuilder<bool>(
                              stream: loginBloc.streamIsShowPassword,
                              initialData: _isPasswordVisible,
                              builder: (context, isShowPasswordSnapshot) {
                                return TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    label: Text(appLocalization(context)
                                        .password_label),
                                    hintText:
                                        appLocalization(context).password_hint,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        isShowPasswordSnapshot.data!
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                        loginBloc.sinkIsShowPassword
                                            .add(_isPasswordVisible);
                                      },
                                    ),
                                  ),
                                  obscureText: !_isPasswordVisible,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return appLocalization(context)
                                          .password_not_empty;
                                    }
                                    if (text.length < 6) {
                                      return appLocalization(context)
                                          .password_not_length;
                                    }
                                    return null;
                                  },
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border(
                            bottom: BorderSide(
                                color: context.theme.colorScheme.onSurface),
                            top: BorderSide(
                                color: context.theme.colorScheme.onSurface),
                            left: BorderSide(
                                color: context.theme.colorScheme.onSurface),
                            right: BorderSide(
                                color: context.theme.colorScheme.onSurface),
                          )),
                      child: MaterialButton(
                        onPressed: () {
                          _submitForm();
                        },
                        minWidth: double.infinity,
                        height: 60,
                        color: context.theme.colorScheme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          appLocalization(context).login_title,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(appLocalization(context)
                              .login_do_not_have_account),
                          GestureDetector(
                            onTap: () {
                              context.pushNamed(AppRoutes.REGISTER.name);
                            },
                            child: Text(
                              appLocalization(context).register_title,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: context.lowValue,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.pushNamed(AppRoutes.FORGOT_PASSWORD.name);
                            },
                            child: Text(
                              "Quên mật khẩu?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 100),
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          ImageConstants.instance.getImage("background"),
                        ),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
