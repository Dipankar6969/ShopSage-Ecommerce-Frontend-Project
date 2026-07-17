import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_constants.dart';
import '../../controller/auth_controller.dart';
import '../../controller/cart_controller.dart';
import '../../controller/product_controller.dart';
import '../account/account_view.dart';
import '../cart/cart_view.dart';
import '../product/product_detail_view.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Sign in to continue your seamless shopping experience'),
              const SizedBox(height: 24),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'demo@example.com',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (authController.errorMessage.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    authController.errorMessage.value,
                    style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                );
              }),
              Obx(() {
                return ElevatedButton(
                  onPressed: authController.isLoading.value
                      ? null
                      : () async {
                          await authController.login(emailController.text.trim(), passwordController.text);
                          if (authController.currentUser.value != null) {
                            Get.offAll(() => const HomeView());
                          }
                        },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                  child: authController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login'),
                );
              }),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Get.to(() => const RegisterView());
                },
                child: const Text('Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final authController = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => (value == null || value.trim().length < 3) ? 'Name must be at least 3 characters' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => (value == null || !value.contains('@')) ? 'Enter a valid email' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) => (value == null || value.trim().length < 6) ? 'Enter a valid phone number' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  helperText: 'Min 6 chars, uppercase, lowercase, number, special char',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                    return 'Include at least one lowercase letter';
                  }
                  if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                    return 'Include at least one uppercase letter';
                  }
                  if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
                    return 'Include at least one number';
                  }
                  if (!RegExp(r'(?=.*[@\$!%*?&])').hasMatch(value)) {
                    return 'Include at least one special character';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm password'),
                validator: (value) {
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Obx(() {
                return ElevatedButton(
                  onPressed: authController.isLoading.value
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          await authController.register({
                            'name': nameController.text.trim(),
                            'email': emailController.text.trim(),
                            'phone': phoneController.text.trim(),
                            'password': passwordController.text,
                            'address': {
                              'city': 'Kathmandu',
                              'country': 'Nepal',
                            },
                          });
                          if (authController.currentUser.value != null) {
                            Get.offAll(() => const HomeView());
                          }
                        },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                  child: authController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Register'),
                );
              }),
              const SizedBox(height: 12),
              Obx(() {
                if (authController.errorMessage.isEmpty) return const SizedBox.shrink();
                return Text(authController.errorMessage.value, style: const TextStyle(color: Colors.red));
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();
  final AuthController authController = Get.find<AuthController>();
  int _selectedIndex = 0;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    productController.fetchProducts();
    productController.fetchCategories();
  }

  Future<void> _selectCategory(String category) async {
    setState(() {
      _selectedCategory = category;
      _selectedIndex = 0;
    });
    await productController.fetchProducts(category: category == 'All' ? null : category);
  }

  Widget _buildHomePage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            final categories = productController.categories;
            final items = ['All', ...categories];
            return Wrap(
              spacing: 8,
              children: items.map((category) {
                final selected = category == _selectedCategory;
                return ChoiceChip(
                  label: Text(category),
                  selected: selected,
                  onSelected: (_) => _selectCategory(category),
                  selectedColor: Colors.green.shade100,
                );
              }).toList(),
            );
          }),
        ),
        Expanded(
          child: Obx(() {
            if (productController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (productController.products.isEmpty) {
              return const Center(child: Text('No products available yet'));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.64,
              ),
              itemCount: productController.products.length,
              itemBuilder: (context, index) {
                final product = productController.products[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(() => ProductDetailView(product: product)),
                        child: product.imageUrls.isNotEmpty
                            ? Image.network(
                                product.imageUrls.first,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(height: 120, color: Colors.grey[200], child: const Center(child: Text('No image'))),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(product.category ?? '', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                  const SizedBox(height: 6),
                                  Text('Rs. ${product.price}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                                ],
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    cartController.addToCart(product);
                                    Get.snackbar(
                                      'Added to cart',
                                      '${product.name ?? 'Product'} has been added.',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.green.shade700,
                                      colorText: Colors.white,
                                    );
                                  },
                                  icon: const Icon(Icons.add_shopping_cart),
                                  label: const Text('Add to cart'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade700,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCategoryPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Browse categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Tap a category to filter products on the home page.', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 16),
          Obx(() {
            final categories = productController.categories;
            if (productController.isLoading.value && categories.isEmpty) {
              return const Expanded(child: Center(child: CircularProgressIndicator()));
            }
            final items = ['All', ...categories];
            return Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final category = items[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: ListTile(
                      title: Text(category),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _selectCategory(category),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomePage(),
      _buildCategoryPage(),
      const AccountView(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () => Get.to(() => const CartView()), icon: const Icon(Icons.shopping_cart_outlined)),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
