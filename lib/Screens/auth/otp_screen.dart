import 'dart:async';
import 'package:flutter/material.dart';
import 'package:erp_sample/Screens/auth/reset_password_screen.dart';
import '../../Services/auth_services.dart';

class OtpScreen extends StatefulWidget {
  final String loginId;

  const OtpScreen({
    super.key,
    required this.loginId,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());

  final List<FocusNode> _focusNodes =
  List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _secondsRemaining = 60;

  static const Color primaryGreen = Color(0xFF087F70);
  static const Color darkGreen = Color(0xFF075E56);
  static const Color mudOrange = Color(0xFFC47A45);
  static const Color lightOrange = Color(0xFFE6A56E);
  static const Color textColor = Color(0xFF153449);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    setState(() {
      _secondsRemaining = 60;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (_secondsRemaining > 0) {
          setState(() {
            _secondsRemaining--;
          });
        } else {
          timer.cancel();
        }
      },
    );
  }

  String get _enteredOtp {
    return _controllers.map((controller) => controller.text).join();
  }

  void _handleOtpInput(int index, String value) {
    if (value.length > 1) {
      final characters = value.split('');

      for (int i = 0; i < characters.length; i++) {
        final position = index + i;

        if (position < 6) {
          _controllers[position].text = characters[i];
        }
      }

      final nextPosition = index + characters.length;

      if (nextPosition < 6) {
        _focusNodes[nextPosition].requestFocus();
      } else {
        _focusNodes[5].unfocus();
      }

      setState(() {});
      return;
    }

    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    setState(() {});
  }

  void _handleBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }

    setState(() {});
  }

  Future<void> _verifyOtp() async {
    if (_enteredOtp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 6-digit OTP.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      await ApiService.verifyOtp(
        widget.loginId,
        _enteredOtp,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(
            loginId: widget.loginId,
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
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _resendOtp() async {
    if (_secondsRemaining > 0) return;

    try {
      await ApiService.forgotPassword(widget.loginId);

      if (!mounted) return;

      _startTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A new OTP has been sent to your email.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Exception: ', ''),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();

    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final node in _focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Soft overlay
          Positioned.fill(
            child: Container(
              color: const Color(0xFFFAF8F0).withValues(alpha: 0.28),
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
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo
                          Image.asset(
                            'assets/images/school_logo.png',
                            width: 180,
                            height: 145,
                            fit: BoxFit.contain,
                          ),

                          const SizedBox(height: 8),

                          // Main card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(
                              22,
                              26,
                              22,
                              24,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAF8F0)
                                  .withValues(alpha: 0.94),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: darkGreen.withValues(alpha: 0.16),
                                  blurRadius: 22,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Icon
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: mudOrange.withValues(alpha: 0.13),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: mudOrange.withValues(alpha: 0.25),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.mark_email_read_outlined,
                                    size: 30,
                                    color: mudOrange,
                                  ),
                                ),

                                const SizedBox(height: 18),

                                const Text(
                                  'Verify Your Email',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                const Text(
                                  'Enter the 6-digit OTP sent to your\nregistered email address.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.5,
                                    color: Color(0xFF71868D),
                                  ),
                                ),
                                const SizedBox(height: 6),

                                const Text(
                                  'This OTP is valid for 5 minutes.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: mudOrange,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // OTP boxes
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: List.generate(
                                    6,
                                        (index) {
                                      return SizedBox(
                                        width: 43,
                                        height: 52,
                                        child: TextField(
                                          controller: _controllers[index],
                                          focusNode: _focusNodes[index],
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          maxLength: 1,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: textColor,
                                          ),
                                          decoration: InputDecoration(
                                            counterText: '',
                                            filled: true,
                                            fillColor: Colors.white
                                                .withValues(alpha: 0.82),
                                            contentPadding:
                                            EdgeInsets.zero,
                                            enabledBorder:
                                            OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Colors.grey
                                                    .withValues(alpha: 0.20),
                                              ),
                                            ),
                                            focusedBorder:
                                            OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(12),
                                              borderSide:
                                              const BorderSide(
                                                color: mudOrange,
                                                width: 1.8,
                                              ),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            _handleOtpInput(
                                              index,
                                              value,
                                            );
                                          },
                                          onTapOutside: (_) {
                                            FocusScope.of(context).unfocus();
                                          },
                                          onEditingComplete: () {
                                            _handleBackspace(index);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(height: 22),

                                // Timer / resend
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Didn't receive the code? ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF71868D),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _resendOtp,
                                      child: Text(
                                        _secondsRemaining > 0
                                            ? 'Resend in ${_secondsRemaining}s'
                                            : 'Resend OTP',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: _secondsRemaining > 0
                                              ? const Color(0xFF9B9B9B)
                                              : primaryGreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 22),

                                // Verify button
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: _verifyOtp,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryGreen,
                                      foregroundColor: Colors.white,
                                      elevation: 3,
                                      shadowColor: darkGreen
                                          .withValues(alpha: 0.30),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(13),
                                      ),
                                    ),
                                    child: const Text(
                                      'Verify OTP',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // Back
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_rounded,
                                    size: 17,
                                    color: Color(0xFF55757D),
                                  ),
                                  label: const Text(
                                    'Back to Login',
                                    style: TextStyle(
                                      color: Color(0xFF55757D),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Security note
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_outline_rounded,
                                size: 14,
                                color: darkGreen.withValues(alpha: 0.65),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Your account information is secure',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: darkGreen.withValues(alpha: 0.70),
                                ),
                              ),
                            ],
                          ),
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