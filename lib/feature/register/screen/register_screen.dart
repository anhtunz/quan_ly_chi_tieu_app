import 'package:flutter/material.dart';

import '../../../product/services/toast_service.dart';
import '../../../product/services/language_services.dart';
import '../bloc/register_bloc.dart';
import '../../../product/base/bloc/base_bloc.dart';
import '../../../product/extension/context_extension.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterBloc registerBloc;
  ToastService toastService = ToastService();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _password;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    registerBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    // toastService.showSuccessToast(
    //     context: context, title: "Thong bao", message: "Test thong bao");
    if (_formKey.currentState!.validate()) {
      // Form is valid, retrieve values from controllers
      final email = _emailController.text;
      final password = _passwordController.text;
      final name = _nameController.text;

      registerBloc.registerUser(context, name, email, password);
      // Example: Print values (you can use them as needed)
      // print('Name: $name');
      // print('Email: $email');
      // print('Password: $password');
      // print('Confirm Password: $confirmPassword');
      // You can now use these values (e.g., send to an API, save to a database, etc.)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 40,
          ),
          height: (context.height - 50),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
                  Text(
                    appLocalization(context).register_title,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: context.lowValue,
                  ),
                  Text(appLocalization(context).register_body,
                      style: TextStyle(fontSize: 15, color: Colors.grey[700])),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          label: Text(appLocalization(context).name_label),
                          hintText: appLocalization(context).name_hint,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return appLocalization(context).name_not_empty;
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: context.lowValue,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          label: Text(appLocalization(context).email_label),
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
                        stream: registerBloc.streamIsShowPassword,
                        initialData: _isPasswordVisible,
                        builder: (context, isShowPasswordSnapshot) {
                          return TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              label:
                                  Text(appLocalization(context).password_label),
                              hintText: appLocalization(context).password_hint,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isShowPasswordSnapshot.data!
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  _isPasswordVisible = !_isPasswordVisible;
                                  registerBloc.sinkIsShowPassword
                                      .add(_isPasswordVisible);
                                },
                              ),
                            ),
                            obscureText: !_isPasswordVisible,
                            onChanged: (text) {
                              _password = text;
                            },
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
                    SizedBox(
                      height: context.lowValue,
                    ),
                    StreamBuilder<bool>(
                        initialData: _isConfirmPasswordVisible,
                        stream: registerBloc.streamIsConfirmPassword,
                        builder: (context, isConfirmPasswordSnapshot) {
                          return TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              label: Text(appLocalization(context)
                                  .password_confirm_label),
                              // hintText: appLocalization(context).email_hint,
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
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                  registerBloc.sinkIsConfirmPassword
                                      .add(_isConfirmPasswordVisible);
                                },
                              ),
                            ),
                            // textAlign: TextAlign.center,
                            obscureText: !_isConfirmPasswordVisible,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return appLocalization(context)
                                    .password_not_empty;
                              }
                              if (text != _password) {
                                return appLocalization(context)
                                    .password_not_match;
                              }
                              return null;
                            },
                          );
                        }),
                    SizedBox(
                      height: context.lowValue,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
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
                    onPressed: () async {
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
                      appLocalization(context).register_button_title,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
