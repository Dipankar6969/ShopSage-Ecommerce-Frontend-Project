import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/auth_controller.dart';
import '../../controller/cart_controller.dart';
import '../../services/api_service.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final cartController = Get.find<CartController>();
  final authController = Get.find<AuthController>();
  final ApiService _apiService = ApiService();

  late final TextEditingController cityController;
  late final TextEditingController provinceController;
  late final TextEditingController countryController;
  String selectedPayment = 'cash';
  bool isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    final user = authController.currentUser.value;
    cityController = TextEditingController(text: user?.address?.city ?? '');
    provinceController = TextEditingController(text: '');
    countryController = TextEditingController(text: user?.address?.country ?? 'Nepal');
  }

  @override
  void dispose() {
    cityController.dispose();
    provinceController.dispose();
    countryController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (cartController.items.isEmpty) {
      Get.snackbar('Cart empty', 'Add some products before placing an order.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (authController.currentUser.value == null) {
      Get.snackbar('Login required', 'Please login to place an order.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final city = cityController.text.trim();
    final province = provinceController.text.trim();
    final country = countryController.text.trim();

    if (city.isEmpty || country.isEmpty) {
      Get.snackbar('Missing details', 'Please enter city and country for delivery.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => isPlacingOrder = true);

    try {
      final navigator = Navigator.of(context);
      final orderItems = cartController.items.map((product) => {
        'product': product.id,
        'quantity': 1,
      }).toList();

      final order = await _apiService.createOrder(
        orderItems: orderItems.cast<Map<String, dynamic>>(),
        shippingAddress: {
          'city': city,
          'province': province,
          'country': country,
        },
        totalPrice: cartController.totalAmount.toInt(),
        paymentMethod: selectedPayment == 'khalti' ? 'khalti' : 'cash',
      );

      if (selectedPayment == 'cash') {
        await _apiService.payOrderViaCash(order.id ?? '');
        cartController.clearCart();
        if (!mounted) return;
        Get.snackbar('Order placed', 'Your order is confirmed. Pay on delivery.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green.shade700, colorText: Colors.white);
        if (navigator.mounted) {
          navigator.pop();
        }
      } else {
        final paymentData = await _apiService.payOrderViaKhalti(order.id ?? '');
        final paymentUrl = paymentData['payment_url']?.toString() ?? '';
        cartController.clearCart();
        if (!mounted) return;
        if (paymentUrl.isNotEmpty) {
          final launched = await launchUrl(Uri.parse(paymentUrl), mode: LaunchMode.externalApplication);
          if (!launched) {
            Get.snackbar('Khalti payment', 'Could not open the Khalti payment page.', snackPosition: SnackPosition.BOTTOM);
          }
        } else {
          Get.snackbar('Khalti payment', 'Payment link was not returned. Please try cash or contact support.', snackPosition: SnackPosition.BOTTOM);
        }
        if (navigator.mounted) {
          navigator.pop();
        }
      }
    } catch (e) {
      if (!mounted) return;
      Get.snackbar('Checkout failed', e.toString().replaceFirst('Exception: ', ''), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      if (mounted) {
        setState(() => isPlacingOrder = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: Obx(() {
        if (cartController.items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  const Text('Your cart is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Add products from the home page to get started.', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Items', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...cartController.items.map((product) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(product.name ?? ''),
                  subtitle: Text('Rs. ${product.price}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => cartController.removeFromCart(product),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Delivery details', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextField(controller: cityController, decoration: const InputDecoration(labelText: 'City')),
                    const SizedBox(height: 10),
                    TextField(controller: provinceController, decoration: const InputDecoration(labelText: 'Province')),
                    const SizedBox(height: 10),
                    TextField(controller: countryController, decoration: const InputDecoration(labelText: 'Country')),
                    const SizedBox(height: 16),
                    Text('Payment method', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('Cash'),
                          selected: selectedPayment == 'cash',
                          onSelected: (_) => setState(() => selectedPayment = 'cash'),
                          selectedColor: Colors.green.shade100,
                        ),
                        ChoiceChip(
                          label: const Text('Khalti'),
                          selected: selectedPayment == 'khalti',
                          onSelected: (_) => setState(() => selectedPayment = 'khalti'),
                          selectedColor: Colors.orange.shade100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Rs. ${cartController.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        final total = cartController.totalAmount.toStringAsFixed(0);
        return Container(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: cartController.items.isEmpty || isPlacingOrder ? null : _placeOrder,
            icon: isPlacingOrder ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.check_circle_outline),
            label: Text(isPlacingOrder ? 'Placing order...' : 'Place order • Rs. $total'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
          ),
        );
      }),
    );
  }
}
