import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_constants.dart';
import '../../controller/auth_controller.dart';

// ============================================================================
// RESPONSIVE HELPER
// ============================================================================

const double kMaxContentWidth = 480;

bool _isWideScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > kMaxContentWidth;
}

// ============================================================================
// RESPONSIVE AUTH SCAFFOLD BODY
// ============================================================================

class ResponsiveAuthScaffoldBody extends StatelessWidget {
  const ResponsiveAuthScaffoldBody({
    super.key,
    required this.child,
    required this.backgroundImage,
  });

  final Widget child;
  final String backgroundImage;

  @override
  Widget build(BuildContext context) {
    final isWide = _isWideScreen(context);

    return Container(
      key: const ValueKey('responsive-auth-backdrop'),
      width: double.infinity,
      height: double.infinity,

      // OUTER BACKGROUND FOR DESKTOP
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/background.png'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),

      child: Center(
        child: Container(
          width: isWide ? kMaxContentWidth : double.infinity,
          height: double.infinity,

          // MAIN BACKGROUND
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
            boxShadow: isWide
                ? const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 5),
                    ),
                  ]
                : null,
          ),

          child: child,
        ),
      ),
    );
  }
}

// ============================================================================
// HOME VIEWS
// ============================================================================

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home View'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Home screen is currently under development.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}

// ============================================================================
// LOGIN VIEWS
// ============================================================================

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final AuthController authController;

  bool obscurePassword = true;

  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color primaryLightColor = Color(0xFF66BB6A);
  static const Color primaryDarkColor = Color(0xFF1B5E20);

  static const Color primaryShadowColor = Color.fromRGBO(46, 125, 50, 0.25);

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();

    if (Get.isRegistered<AuthController>()) {
      authController = Get.find<AuthController>();
    } else {
      authController = Get.put(AuthController());
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ==========================================================================
  // LOGIN
  // ==========================================================================

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      _showError('Please enter your email address.');
      return;
    }

    if (!_isValidEmail(email)) {
      _showError('Please enter a valid email address.');
      return;
    }

    if (password.isEmpty) {
      _showError('Please enter your password.');
      return;
    }

    if (authController.isLoading.value) {
      return;
    }

    await authController.login(email, password);

    if (!mounted) return;

    if (authController.currentUser.value != null) {
      Get.offAll(() => const HomeView());
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email);
  }

  void _showError(String message) {
    Get.snackbar(
      'Login',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('login-view-scaffold'),
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        top: false,
        bottom: false,

        child: ResponsiveAuthScaffoldBody(
          backgroundImage: 'images/background2.png',

          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

            child: Column(
              children: [
                _buildAnimatedHeader(context),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 18,
                  ),
                  child: Column(
                    children: [
                      _buildLoginForm(),

                      const SizedBox(height: 20),

                      _buildErrorMessage(),

                      const SizedBox(height: 8),

                      _buildLoginButton(),

                      const SizedBox(height: 24),

                      _buildRegisterLink(),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // LOGIN HEADER
  // ==========================================================================

  Widget _buildAnimatedHeader(BuildContext context) {
    final isWide = _isWideScreen(context);

    final headerHeight = isWide ? 340.0 : 380.0;

    return SizedBox(
      height: headerHeight,
      width: double.infinity,

      child: Stack(
        children: [
          Positioned(
            left: 30,
            top: 0,
            width: 80,
            height: 200,
            child: FadeInUp(
              duration: const Duration(milliseconds: 1000),
              child: const Image(
                image: AssetImage('images/light-1.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            left: 140,
            top: 0,
            width: 80,
            height: 150,
            child: FadeInUp(
              duration: const Duration(milliseconds: 1200),
              child: const Image(
                image: AssetImage('images/light-2.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            right: 40,
            top: 40,
            width: 80,
            height: 150,
            child: FadeInUp(
              duration: const Duration(milliseconds: 1300),
              child: const Image(
                image: AssetImage('images/clock.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned.fill(
            child: FadeInUp(
              duration: const Duration(milliseconds: 1600),

              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 45),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 55,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        AppConstants.appName.isNotEmpty
                            ? AppConstants.appName
                            : 'Welcome',

                        textAlign: TextAlign.center,

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Welcome back!',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // LOGIN FORM
  // ==========================================================================

  Widget _buildLoginForm() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1800),

      child: Container(
        padding: const EdgeInsets.all(6),

        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(16),

          border: Border.all(color: primaryColor, width: 1),

          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(46, 125, 50, 0.20),
              blurRadius: 25,
              offset: Offset(0, 12),
            ),
          ],
        ),

        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: primaryColor)),
              ),

              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,

                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Email Address',

                  hintStyle: TextStyle(color: Colors.grey[600]),

                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: primaryColor,
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

              child: TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _login(),

                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Password',

                  hintStyle: TextStyle(color: Colors.grey[600]),

                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: primaryColor,
                  ),

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },

                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // LOGIN ERROR
  // ==========================================================================

  Widget _buildErrorMessage() {
    return Obx(() {
      if (authController.errorMessage.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,

        margin: const EdgeInsets.only(bottom: 8),

        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),

        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(10),

          border: Border.all(color: Colors.red.shade200),
        ),

        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                authController.errorMessage.value,

                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ==========================================================================
  // LOGIN BUTTON
  // ==========================================================================

  Widget _buildLoginButton() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1900),

      child: Obx(() {
        final loading = authController.isLoading.value;

        return SizedBox(
          width: double.infinity,
          height: 52,

          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),

              gradient: loading
                  ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                  : const LinearGradient(
                      colors: [primaryDarkColor, primaryLightColor],
                    ),

              boxShadow: loading
                  ? null
                  : const [
                      BoxShadow(
                        color: primaryShadowColor,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
            ),

            child: ElevatedButton(
              onPressed: loading ? null : _login,

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              child: loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,

                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'Sign In',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        );
      }),
    );
  }

  // ==========================================================================
  // REGISTER LINK
  // ==========================================================================

  Widget _buildRegisterLink() {
    return FadeInUp(
      duration: const Duration(milliseconds: 2000),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Text(
            "Don't have an account?",

            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),

          TextButton(
            onPressed: () {
              Get.to(() => const RegisterView());
            },

            child: const Text(
              'Sign Up',

              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// REGISTER VIEW
// ============================================================================

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  late final AuthController authController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color primaryLightColor = Color(0xFF66BB6A);
  static const Color primaryDarkColor = Color(0xFF1B5E20);

  static const Color primaryShadowColor = Color.fromRGBO(46, 125, 50, 0.25);

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    if (Get.isRegistered<AuthController>()) {
      authController = Get.find<AuthController>();
    } else {
      authController = Get.put(AuthController());
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email);
  }

  // ==========================================================================
  // REGISTER
  // ==========================================================================

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    if (authController.isLoading.value) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    await authController.register({
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'password': passwordController.text,

      'address': {'city': 'Kathmandu', 'country': 'Nepal'},
    });

    if (!mounted) return;

    if (authController.currentUser.value != null) {
      Get.offAll(() => const HomeView());
    }
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: hint,

      hintStyle: TextStyle(color: Colors.grey[600]),

      prefixIcon: Icon(icon, color: primaryColor),

      suffixIcon: suffixIcon,
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('register-view-scaffold'),
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        top: false,
        bottom: false,

        child: ResponsiveAuthScaffoldBody(
          backgroundImage: 'images/background2.png',

          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

            child: Column(
              children: [
                _buildRegisterHeader(context),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 18,
                  ),

                  child: Form(
                    key: _formKey,

                    child: Column(
                      children: [
                        _buildRegisterCard(),

                        const SizedBox(height: 18),

                        _buildRegisterError(),

                        const SizedBox(height: 6),

                        _buildRegisterButton(),

                        const SizedBox(height: 20),

                        _buildLoginLink(),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // REGISTER HEADER
  // ==========================================================================

  Widget _buildRegisterHeader(BuildContext context) {
    final isWide = _isWideScreen(context);

    final headerHeight = isWide ? 300.0 : 330.0;

    return SizedBox(
      height: headerHeight,
      width: double.infinity,

      child: Stack(
        children: [
          Positioned(
            left: 25,
            top: 0,
            width: 75,
            height: 180,

            child: FadeInUp(
              duration: const Duration(milliseconds: 900),

              child: const Image(
                image: AssetImage('images/light-1.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            left: 130,
            top: 0,
            width: 75,
            height: 140,

            child: FadeInUp(
              duration: const Duration(milliseconds: 1100),

              child: const Image(
                image: AssetImage('images/light-2.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            right: 35,
            top: 30,
            width: 75,
            height: 140,

            child: FadeInUp(
              duration: const Duration(milliseconds: 1200),

              child: const Image(
                image: AssetImage('images/clock.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            top: 45,
            left: 12,

            child: FadeInLeft(
              duration: const Duration(milliseconds: 1000),

              child: IconButton(
                onPressed: () => Get.back(),

                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: FadeInUp(
              duration: const Duration(milliseconds: 1500),

              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 35),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      const Icon(
                        Icons.person_add_alt_1_outlined,
                        color: Colors.white,
                        size: 52,
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Create Account',

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 7),

                      const Text(
                        'Join us and get started',

                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // REGISTER CARD
  // ==========================================================================

  Widget _buildRegisterCard() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1700),

      child: Container(
        padding: const EdgeInsets.all(6),

        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(16),

          border: Border.all(color: primaryColor),

          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(46, 125, 50, 0.20),
              blurRadius: 25,
              offset: Offset(0, 12),
            ),
          ],
        ),

        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,

              decoration: _inputDecoration(
                hint: 'Full Name',
                icon: Icons.person_outline,
              ),

              validator: (value) {
                final name = value?.trim() ?? '';

                if (name.isEmpty) {
                  return 'Please enter your name';
                }

                if (name.length < 3) {
                  return 'Name must be at least 3 characters';
                }

                return null;
              },
            ),

            const Divider(height: 1, color: primaryColor),

            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autocorrect: false,

              decoration: _inputDecoration(
                hint: 'Email Address',
                icon: Icons.email_outlined,
              ),

              validator: (value) {
                final email = value?.trim() ?? '';

                if (email.isEmpty) {
                  return 'Please enter your email';
                }

                if (!_isValidEmail(email)) {
                  return 'Enter a valid email address';
                }

                return null;
              },
            ),

            const Divider(height: 1, color: primaryColor),

            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,

              decoration: _inputDecoration(
                hint: 'Phone Number',
                icon: Icons.phone_outlined,
              ),

              validator: (value) {
                final phone = value?.trim() ?? '';

                if (phone.isEmpty) {
                  return 'Please enter your phone number';
                }

                if (phone.length < 6) {
                  return 'Enter a valid phone number';
                }

                return null;
              },
            ),

            const Divider(height: 1, color: primaryColor),

            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              textInputAction: TextInputAction.next,

              decoration: _inputDecoration(
                hint: 'Password',
                icon: Icons.lock_outline,

                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },

                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: primaryColor,
                  ),
                ),
              ),

              validator: (value) {
                final password = value ?? '';

                if (password.isEmpty) {
                  return 'Please enter a password';
                }

                if (password.length < 6) {
                  return 'Password must be at least 6 characters';
                }

                if (!RegExp(r'[a-z]').hasMatch(password)) {
                  return 'Include a lowercase letter';
                }

                if (!RegExp(r'[A-Z]').hasMatch(password)) {
                  return 'Include an uppercase letter';
                }

                if (!RegExp(r'\d').hasMatch(password)) {
                  return 'Include a number';
                }

                if (!RegExp(r'[@$!%*?&]').hasMatch(password)) {
                  return 'Include a special character';
                }

                return null;
              },
            ),

            const Divider(height: 1, color: primaryColor),

            TextFormField(
              controller: confirmPasswordController,
              obscureText: obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _register(),

              decoration: _inputDecoration(
                hint: 'Confirm Password',
                icon: Icons.lock_clock_outlined,

                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscureConfirmPassword = !obscureConfirmPassword;
                    });
                  },

                  icon: Icon(
                    obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: primaryColor,
                  ),
                ),
              ),

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }

                if (value != passwordController.text) {
                  return 'Passwords do not match';
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // REGISTER ERROR
  // ==========================================================================

  Widget _buildRegisterError() {
    return Obx(() {
      if (authController.errorMessage.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,

        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),

        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(10),

          border: Border.all(color: Colors.red.shade200),
        ),

        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                authController.errorMessage.value,

                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ==========================================================================
  // REGISTER BUTTON
  // ==========================================================================

  Widget _buildRegisterButton() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1900),

      child: Obx(() {
        final loading = authController.isLoading.value;

        return SizedBox(
          width: double.infinity,
          height: 52,

          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),

              gradient: loading
                  ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                  : const LinearGradient(
                      colors: [primaryDarkColor, primaryLightColor],
                    ),

              boxShadow: loading
                  ? null
                  : const [
                      BoxShadow(
                        color: primaryShadowColor,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
            ),

            child: ElevatedButton(
              onPressed: loading ? null : _register,

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              child: loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,

                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'Create Account',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        );
      }),
    );
  }

  // ==========================================================================
  // LOGIN LINK
  // ==========================================================================

  Widget _buildLoginLink() {
    return FadeInUp(
      duration: const Duration(milliseconds: 2000),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Text(
            'Already have an account?',

            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),

          TextButton(
            onPressed: () => Get.back(),

            child: const Text(
              'Sign In',

              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
