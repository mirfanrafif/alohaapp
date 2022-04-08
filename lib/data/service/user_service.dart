import 'package:aloha/data/response/User.dart';
import 'package:aloha/utils/api_response.dart';
import 'package:aloha/utils/constants.dart';
import 'package:http/http.dart';

class UserService {
  Future<ApiResponse<LoginData>> login(
      {required String username, required String password}) async {
    try {
      var response = await post(Uri.https(BASE_URL, "/auth/login"),
          body: <String, String>{'username': username, 'password': password});
      if (response.statusCode < 400) {
        var userResponse = userResponseFromJson(response.body);
        return ApiResponse(
            success: true, data: userResponse.data, message: "Success login");
      } else {
        var error = apiErrorResponseFromJson(response.body);
        return ApiResponse(
            success: false,
            data: null,
            message: "Failed to login: " + error.message);
      }
    } catch (e) {
      return ApiResponse(
          success: false,
          data: null,
          message: "Failed to login: " + e.toString());
    }
  }
}
