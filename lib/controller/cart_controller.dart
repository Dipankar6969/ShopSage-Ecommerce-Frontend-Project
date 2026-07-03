import 'package:get/get.dart';
import '../models/product_model.dart';

class CartController extends GetxController {
  final RxList<ProductModel> items = <ProductModel>[].obs;

  void addToCart(ProductModel product) {
    items.add(product);
  }

  void removeFromCart(ProductModel product) {
    items.remove(product);
  }

  void clearCart() {
    items.clear();
  }

  int get itemCount => items.length;
  double get totalAmount => items.fold(0.0, (sum, item) => sum + (item.price ?? 0));
}
