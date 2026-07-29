import 'package:get/get.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final currentUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    setDummyUser();
  }

  void setDummyUser() {
    currentUser.value = UserModel(
      id: '1',
      name: 'Dikshya Thakur',
      email: 'dikshya123@gmail.com',
      phone: '9803987647',
      isActive: true,
      roles: ['user'],
      address: Address(city: 'Kathmandu', country: 'Nepal'),
    );
  }

  void logout() {
    currentUser.value = null;
  }
}
