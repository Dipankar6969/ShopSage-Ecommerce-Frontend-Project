import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchProducts({String? category}) async {
    try {
      isLoading.value = true;
      final result = await _apiService.getProducts(category: category);
      products.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      final result = await _apiService.getCategories();
      categories.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }
}
