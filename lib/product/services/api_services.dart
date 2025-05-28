// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:quan_ly_chi_tieu/product/constants/app/api_path_constants.dart';
import 'package:quan_ly_chi_tieu/product/network/network_manager.dart';
import '../cache/locale_manager.dart';
import '../constants/app/app_constants.dart';
import '../constants/enums/app_route_enums.dart';
import '../constants/enums/locale_keys_enum.dart';

class APIServices {
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    "Access-Control-Allow-Credentials": "false",
    "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    'Access-Control-Allow-Origin': "*",
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS, PUT, PATCH, DELETE',
  };

  Future<Map<String, String>> getHeaders() async {
    String? token =
        LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN);
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Access-Control-Allow-Credentials": "false",
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      'Access-Control-Allow-Origin': "*",
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS, PUT, PATCH, DELETE',
      'Authorization': token,
    };
    return headers;
  }

  Future<http.Response> register(Map<String, dynamic> registerRequest) async {
    final response = await NetworkManager.instance!
        .createDataInServer(ApiPathConstants.REGISTER_PATH, registerRequest);
    return response;
  }

  Future<http.Response> login(Map<String, dynamic> loginRequest) async {
    final response = await NetworkManager.instance!
        .createDataInServer(ApiPathConstants.LOGIN_PATH, loginRequest);
    return response;
  }

  Future<void> logOut(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Bạn chắc chắn muốn đăng xuất?",
                  textAlign: TextAlign.center),
              actions: [
                TextButton(
                  onPressed: () async {
                    LocaleManager.instance
                        .deleteStringValue(PreferencesKeys.UID);
                    LocaleManager.instance
                        .deleteStringValue(PreferencesKeys.TOKEN);
                    LocaleManager.instance
                        .deleteStringValue(PreferencesKeys.EXP);
                    LocaleManager.instance
                        .deleteStringValue(PreferencesKeys.EMAIL);
                    LocaleManager.instance
                        .deleteStringValue(PreferencesKeys.NAME);
                    context.goNamed(AppRoutes.WELCOME.name);
                  },
                  child: Text("Đăng xuất",
                      style: const TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Hủy bỏ"),
                ),
              ],
            ));
  }

  Future<http.Response> getUserInfomation() async {
    final response = await NetworkManager.instance!
        .getDataFromServer(ApiPathConstants.USER_INFO_PATH);
    return response;
  }

  Future<int> updateUserInfomation(Map<String, dynamic> body) async {
    final response = await NetworkManager.instance!
        .createDataInServer(ApiPathConstants.USER_UPDATE_PATH, body);
    return response.statusCode;
  }

  Future<int> sendOTPMail(Map<String, dynamic> body) async {
    final response = await NetworkManager.instance!
        .createDataInServer(ApiPathConstants.USER_FORGOT_PASSWORD_PATH, body);
    return response.statusCode;
  }

  Future<int> refreshPassword(Map<String, dynamic> body) async {
    final response = await NetworkManager.instance!
        .createDataInServer(ApiPathConstants.USER_REFRESH_PASSWORD_PATH, body);
    return response.statusCode;
  }

  Future<http.Response> getAllLabels() async {
    final response = await NetworkManager.instance!
        .getDataFromServer(ApiPathConstants.GET_ALL_LABELS_PATH);
    return response;
  }

  Future<int> createOrUpdateLabel(Map<String, dynamic> body) async {
    final response = await NetworkManager.instance!
        .createDataInServer(ApiPathConstants.CREATE_OR_UPDATE_LABEL_PATH, body);
    return response.statusCode;
  }

  Future<int> createOrUpdateSpendingNote(Map<String, dynamic> body) async {
    final response = await NetworkManager.instance!.createDataInServer(
        ApiPathConstants.CREATE_OR_UPDATE_SPENDING_NOTE_PATH, body);
    return response.statusCode;
  }

  Future<http.Response> changePassword(Map<String, dynamic> body) async {
    final response = await NetworkManager.instance!
        .createDataInServer(ApiPathConstants.USER_CHANGE_PASSWORD_PATH, body);
    return response;
  }

  Future<http.Response> getAllNotes(Map<String, dynamic> body) async {
    final response = await NetworkManager.instance!
        .createDataInServer(ApiPathConstants.GET_ALL_NOTES_PATH, body);
    return response;
  }

  Future<http.Response> getAllNotesInYear(int year) async {
    final params = {
      "year": "$year",
    };
    final response = await NetworkManager.instance!.getDataFromServerWithParams(
        ApiPathConstants.GET_ALL_NOTE_IN_YEAR_PATH, params);
    return response;
  }

  Future<int> deleteNote(String noteID) async {
    Map<String, dynamic> parameters = {"id": noteID};
    final response = await NetworkManager.instance!
        .deleteDataInServer(ApiPathConstants.DELETE_NOTE_PATH, parameters);
    return response.statusCode;
  }

  Future<http.Response> uploadNoteImage(File file) async {
    final response = await NetworkManager.instance!.uploadImageToServer(
        path: ApiPathConstants.UPLOAD_IMAGE, imageFile: file);
    return response;
  }

  Future<String> checkTheme() async {
    String theme = LocaleManager.instance.getStringValue(PreferencesKeys.THEME);
    return theme;
  }

  Future<String> checkLanguage() async {
    String language =
        LocaleManager.instance.getStringValue(PreferencesKeys.LANGUAGE_CODE);
    return language;
  }
}
