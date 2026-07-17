import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxBool isLoading = false.obs;
  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final RxString errorMessage = ''.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      currentUser.value = await _apiService.login(email, password);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      currentUser.value = await _apiService.register(data);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    currentUser.value = null;
  }

  Future<void> updateProfileImage(String filePath) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      currentUser.value = await _apiService.uploadProfileImage(filePath);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkSession() async {
    final token = await _apiService.getStoredToken();
    if (token != null && token.isNotEmpty) {
      // Keep local session for demo purposes; login/register will populate the user.
    }
  }
}
