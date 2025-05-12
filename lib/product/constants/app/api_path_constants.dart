// ignore_for_file: constant_identifier_names

class ApiPathConstants {
  static const REGISTER_PATH = "/api/account/register";
  static const LOGIN_PATH = "/api/account/login";
  static const USER_INFO_PATH = "/api/account/get-account-info";
  static const USER_UPDATE_PATH = "/api/account/update-account-info";
  static const USER_FORGOT_PASSWORD_PATH = "/api/account/forgot-password";
  static const USER_REFRESH_PASSWORD_PATH = "/api/account/refresh-password";
  static const USER_CHANGE_PASSWORD_PATH = "/api/account/change-password";
  static const GET_ALL_LABELS_PATH = "/api/label/get-all-label";
  static const UPLOAD_IMAGE = "/api/UploadImage/upload-image";
  static const CREATE_OR_UPDATE_LABEL_PATH =
      "/api/label/create-or-update-label";
  static const CREATE_OR_UPDATE_SPENDING_NOTE_PATH =
      "/api/spending/create-or-update-spending-note";
  static const DELETE_NOTE_PATH = "/api/spending/delete-spending-note";

  static const GET_ALL_NOTES_PATH =
      "/api/calander-spending-note/get-list-spending-note";
  static const GET_ALL_NOTE_IN_YEAR_PATH =
      "/api/calander-spending-note/get-list-spending-note-by-year";
}
