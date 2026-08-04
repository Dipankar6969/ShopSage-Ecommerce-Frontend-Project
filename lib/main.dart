import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants/app_constants.dart';
import 'controller/auth_controller.dart';
import 'controller/cart_controller.dart';
import 'controller/product_controller.dart';
import 'services/api_service.dart';
import 'views/auth/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(AuthController());
  Get.put(CartController());
  Get.put(ProductController());
  runApp(const ShopSageApp());
}

class ShopSageApp extends StatelessWidget {
  const ShopSageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: Colors.black),
      ),
      initialRoute: '/khalti-payment',
      getPages: [
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/khalti-payment', page: () => const CheckoutScreen()),
      ],
    );
  }
}

enum PaymentMethod { khalti, cashOnDelivery }

class CheckoutController extends GetxController {
  final ApiService _apiService = ApiService();
  final cartController = Get.find<CartController>();
  final authController = Get.find<AuthController>();

  final RxBool isPaying = false.obs;
  final Rx<PaymentMethod> selectedMethod = PaymentMethod.khalti.obs;

  Future<void> placeOrder() async {
    if (authController.currentUser.value == null) {
      Get.snackbar('Auth Error', 'Please log in before placing an order.');
      return;
    }

    if (cartController.items.isEmpty) {
      Get.snackbar('Cart Empty', 'Your cart is empty. Add an item before checking out.');
      return;
    }

    isPaying.value = true;

    try {
      final orderItems = cartController.items.map((product) => {
        'product': product.id,
        'quantity': 1,
      }).toList();

      final order = await _apiService.createOrder(
        orderItems: orderItems.cast<Map<String, dynamic>>(),
        shippingAddress: {
          'city': authController.currentUser.value?.address?.city ?? 'Kathmandu',
          'province': 'Bagmati',
          'country': authController.currentUser.value?.address?.country ?? 'Nepal',
        },
        totalPrice: cartController.totalAmount.toInt(),
        paymentMethod: selectedMethod.value == PaymentMethod.khalti ? 'khalti' : 'cod',
      );

      if (selectedMethod.value == PaymentMethod.khalti) {
        final paymentData = await _apiService.payOrderViaKhalti(order.id ?? '');
        final paymentUrl = paymentData['payment_url']?.toString() ?? '';

        if (paymentUrl.isNotEmpty) {
          final launched = await launchUrl(
            Uri.parse(paymentUrl), 
            mode: LaunchMode.externalApplication,
          );
          if (!launched) {
            Get.snackbar('Error', 'Unable to open the Khalti payment page.');
          }
        } else {
          Get.snackbar('Error', 'Khalti did not return a payment URL.');
        }
      } else {
        cartController.items.clear();
        Get.snackbar('Success', 'Order placed! Pay in cash when it arrives.');
      }
    } catch (error) {
      Get.snackbar('Error', error.toString().replaceFirst('Exception: ', ''));
    } finally {
      isPaying.value = false;
    }
  }
}

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckoutController());

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.payment, size: 56, color: Color(0xFF2E7D32)),
                  const SizedBox(height: 16),
                  const Text(
                    'Choose Payment Method',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Obx(() => Text(
                    'Total payable: Rs. ${controller.cartController.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  )),
                  const SizedBox(height: 20),
                  _MethodTile(
                    method: PaymentMethod.khalti,
                    icon: Icons.account_balance_wallet,
                    title: 'Khalti',
                    subtitle: 'Pay securely online via Khalti',
                    controller: controller,
                  ),
                  const SizedBox(height: 12),
                  _MethodTile(
                    method: PaymentMethod.cashOnDelivery,
                    icon: Icons.local_shipping,
                    title: 'Cash on Delivery',
                    subtitle: 'Pay in cash when your order arrives',
                    controller: controller,
                  ),
                  const SizedBox(height: 24),
                  Obx(() {
                    final isCod = controller.selectedMethod.value == PaymentMethod.cashOnDelivery;
                    final isPaying = controller.isPaying.value;

                    return ElevatedButton.icon(
                      onPressed: isPaying ? null : () => controller.placeOrder(),
                      icon: isPaying
                          ? const SizedBox(
                              width: 18, 
                              height: 18, 
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Icon(isCod ? Icons.check_circle_outline : Icons.launch),
                      label: Text(
                        isPaying
                            ? 'Processing...'
                            : (isCod ? 'Place Order (COD)' : 'Pay Now'),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Get.toNamed('/login'),
                    child: const Text('Open login screen'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  final PaymentMethod method;
  final IconData icon;
  final String title;
  final String subtitle;
  final CheckoutController controller;

  const _MethodTile({
    required this.method,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedMethod.value == method;
      final isPaying = controller.isPaying.value;

      return InkWell(
        onTap: isPaying ? null : () => controller.selectedMethod.value = method,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? const Color(0xFF2E7D32).withValues(alpha: 0.06) : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade600),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade600,
              ),
            ],
          ),
        ),
      );
    });
  }
}