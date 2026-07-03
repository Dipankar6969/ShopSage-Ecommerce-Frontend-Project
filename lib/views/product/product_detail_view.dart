import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/cart_controller.dart';
import '../../models/product_model.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    return Scaffold(
      appBar: AppBar(title: Text(product.name ?? 'Product')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.imageUrls.isNotEmpty)
              Image.network(product.imageUrls.first, height: 260, width: double.infinity, fit: BoxFit.cover)
            else
              Container(height: 260, color: Colors.grey[200]),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(product.description ?? '', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Rs. ${product.price}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                      const Spacer(),
                      Text('Stock: ${product.stock}', style: const TextStyle(color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      cartController.addToCart(product);
                      Get.snackbar('Added', '${product.name} added to cart');
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text('Add to cart'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
