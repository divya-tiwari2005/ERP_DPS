import 'package:flutter/material.dart';
import '../../Services/auth_services.dart';
import '../../Services/storage_service.dart';
import '../main_navigation.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool _isLoading = false;

  static const Color primaryGreen = Color(0xFF087F70);
  static const Color darkGreen = Color(0xFF075E56);
  static const Color textColor = Color(0xFF153449);
  static const Color secondaryText = Color(0xFF617781);

  @override
  void dispose() {
    userIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_background.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 34,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 42),
                          Center(
                            child: Image.asset(
                              'assets/images/school_logo.png',
                              width: 205,
                              height: 165,
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 28),

                          const Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                              letterSpacing: -0.4,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            'Login to your student account',
                            style: TextStyle(
                              fontSize: 14,
                              color: secondaryText,
                            ),
                          ),

                          const SizedBox(height: 26),

                          _LoginTextField(
                            controller: userIdController,
                            hintText: 'Student ID / Username',
                            icon: Icons.person_outline_rounded,
                          ),

                          const SizedBox(height: 13),

                          _LoginTextField(
                            controller: passwordController,
                            hintText: 'Password',
                            icon: Icons.lock_outline_rounded,
                            obscureText: obscurePassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                              splashRadius: 20,
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF66858B),
                                size: 20,
                              ),
                            ),
                          ),

                          const SizedBox(height: 23),

                          SizedBox(
                            width: double.infinity,
                            height: 51,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                final userId = userIdController.text.trim();
                                final password = passwordController.text;

                                if (userId.isEmpty || password.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter User ID and Password'),
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  _isLoading = true;
                                });

                                try {
                                  final result = await ApiService.login(
                                    userId,
                                    password,
                                  );

                                  final token = result['token'];

                                  if (token != null) {
                                    await StorageService.saveToken(token);
                                  }
                                  if (!mounted) return;

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MainNavigation(),
                                    ),
                                  );
                                  print('LOGIN SUCCESS: $result');

                                  if (!mounted) return;

                                  // We will navigate to Student Home in the next step.
                                } catch (error) {
                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        error.toString().replaceFirst('Exception: ', ''),
                                      ),
                                    ),
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryGreen,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text('Login')
                            ),
                          ),

                          const SizedBox(height: 12),

                          Center(
                            child: TextButton(
                              onPressed: () async {
                                final loginId = userIdController.text.trim();

                                if (loginId.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter your Student ID first.'),
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  await ApiService.forgotPassword(loginId);

                                  if (!mounted) return;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OtpScreen(
                                        loginId: loginId,
                                      ),
                                    ),
                                  );
                                } catch (error) {
                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        error.toString().replaceFirst('Exception: ', ''),
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: primaryGreen,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 5,
                                ),
                              ),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),

                          GestureDetector(
                            onTap: () {
                              // Login ID recovery will be added later.
                            },
                            child: const Text(
                              'Forgot your Login ID? Please contact your school administration.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFE39B2E),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(
                                alpha: 0.58,
                              ),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withValues(
                                  alpha: 0.75,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF5B8FA8).withValues(alpha: 0.22),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Column(
                              children: [
                                Text(
                                  'Not a student?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: darkGreen,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Contact your school administration.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: primaryGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;

  const _LoginTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF153449),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF71868D),
          fontSize: 13,
        ),

        // Left icon
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF55757D),
          size: 20,
        ),

        // Eye icon
        suffixIcon: suffixIcon,

        // Background
        filled: true,
        fillColor: Colors.white.withValues(
          alpha: 0.76,
        ),

        // Internal spacing
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),

        // Normal border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withValues(
              alpha: 0.9,
            ),
            width: 1,
          ),
        ),

        // Focused border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF087F70),
            width: 1.3,
          ),
        ),

        // Default border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}