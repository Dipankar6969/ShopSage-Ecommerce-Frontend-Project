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
        GetPage(name: '/khalti-payment', page: () => const KhaltiPaymentDemoScreen()),
      ],
    );
  }
}

class KhaltiPaymentDemoScreen extends StatefulWidget {
  const KhaltiPaymentDemoScreen({super.key});

  @override
  State<KhaltiPaymentDemoScreen> createState() => _KhaltiPaymentDemoScreenState();
}

class _KhaltiPaymentDemoScreenState extends State<KhaltiPaymentDemoScreen> {
  final ApiService _apiService = ApiService();
  final cartController = Get.find<CartController>();
  final authController = Get.find<AuthController>();
  bool isPaying = false;

  Future<void> _startKhaltiPayment(BuildContext context) async {
    if (authController.currentUser.value == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in before trying Khalti payment.')),
      );
      return;
    }

    if (cartController.items.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty. Add an item before paying.')),
      );
      return;
    }

    setState(() => isPaying = true);

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
      );

      final paymentData = await _apiService.payOrderViaKhalti(order.id ?? '');
      final paymentUrl = paymentData['payment_url']?.toString() ?? '';

      if (!mounted) return;

      if (paymentUrl.isNotEmpty) {
        final launched = await launchUrl(Uri.parse(paymentUrl), mode: LaunchMode.externalApplication);
        if (!launched) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to open the Khalti payment page.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Khalti did not return a payment URL.')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() => isPaying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = cartController.totalAmount.toStringAsFixed(0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Khalti Payment'),
      ),
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
                    'Pay with Khalti',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Total payable: Rs. $total',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This flow creates an order and opens the Khalti payment page for completion.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: isPaying ? null : () => _startKhaltiPayment(context),
                    icon: isPaying
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.launch),
                    label: Text(isPaying ? 'Processing...' : 'Pay Now'),
                  ),
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
