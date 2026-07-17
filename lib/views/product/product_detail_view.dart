import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/product_model.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key, required this.product});

  final ProductModel product;

  static ProductModel mockProduct() {
    return ProductModel(
      id: 'mock-product-01',
      name: 'Casual Premium Shirt',
      brand: 'ShopSage',
      category: 'Fashion',
      price: 2490,
      stock: 12,
      createdAt: DateTime(2024, 10, 1),
      createdBy: 'Local Mock',
      imageUrls: const [
        'images/casual.webp',
        'images/racing.webp',
        'images/strategy.webp',
      ],
      description:
          'A clean and comfortable everyday shirt designed for a relaxed look. Crafted for all-day wear with a soft texture and polished finish.',
      v: 1,
    );
  }

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int activeImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final imageUrls = product.imageUrls.isNotEmpty ? product.imageUrls : [''];

    return Scaffold(
      appBar: AppBar(title: Text(product.name ?? 'Product'), elevation: 0),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: () {
            Get.snackbar(
              'Added to cart',
              '${product.name} has been added to your cart.',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          icon: const Icon(Icons.shopping_cart_outlined),
          label: const Text('Add to cart'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index, realIndex) {
                    final imageUrl = imageUrls[index];
                    return imageUrl.isNotEmpty
                        ? (imageUrl.startsWith('images/')
                            ? Image.asset(
                                imageUrl,
                                height: 320,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 320,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 72,
                                      color: Colors.white70,
                                    ),
                                  );
                                },
                              )
                            : Image.network(
                                imageUrl,
                                height: 320,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 320,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 72,
                                      color: Colors.white70,
                                    ),
                                  );
                                },
                              ))
                        : Container(
                            height: 320,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 72,
                              color: Colors.white70,
                            ),
                          );
                  },
                  options: CarouselOptions(
                    height: 320,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    onPageChanged: (index, reason) =>
                        setState(() => activeImageIndex = index),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imageUrls.asMap().entries.map((entry) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: activeImageIndex == entry.key ? 10 : 8,
                        height: activeImageIndex == entry.key ? 10 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: activeImageIndex == entry.key
                              ? Colors.white
                              : Colors.white54,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? '',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Rs. ${product.price}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Stock: ${product.stock ?? 0}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: (product.stock ?? 0) > 0
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          product.description ?? 'No description available.',
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.7,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
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
