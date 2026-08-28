import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:harvest_app/core/widgets/web_constrained_box.dart';
import 'package:harvest_app/features/auth/domain/entities/user.dart';
import 'package:harvest_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:harvest_app/features/auth/presentation/providers/auth_state.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// Design constants matching current style
const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class RegisterScreen extends ConsumerStatefulWidget {
  final String role;
  const RegisterScreen({super.key, required this.role});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please accept the terms and conditions',
            style: TextStyle(),
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final userType = widget.role;

    await ref.read(authControllerProvider.notifier).register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
          userType: userType,
          phoneNumber: _phoneController.text.trim().isNotEmpty
              ? _phoneController.text.trim()
              : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    // Listen to auth state changes
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      next.maybeWhen(
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message,
                style: TextStyle(),
              ),
              backgroundColor: const Color(0xFFDC2626),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        authenticated: (user) {
          if (user.userType == UserType.farmer) {
            context.go(AppRouter.farmerDashboard);
          } else {
            context.go(AppRouter.main);
          }
        },
        orElse: () {},
      );
    });

    return WebConstrainedBox(
      maxWidth: 600,
      child: Scaffold(
        backgroundColor: kBgColor,
        appBar: AppBar(
          backgroundColor: kBgColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft,
                color: kDarkGreen),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F5F2), // Light green tint
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kPillGrey, width: 1),
                    ),
                    child: const Icon(
                      Icons.agriculture,
                      size: 40,
                      color: kDarkGreen,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Join Harvest',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create an account to start ordering fresh produce',
                    style: TextStyle(
                      color: kTextGrey,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Name field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                      prefixIcon: const PhosphorIcon(PhosphorIconsRegular.user,
                          color: kTextGrey),
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: kTextGrey),
                      hintStyle: TextStyle(color: kTextGrey.withOpacity(0.5)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: kPillGrey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: kPillGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            const BorderSide(color: kDarkGreen, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFDC2626)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFFDC2626), width: 2),
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: const PhosphorIcon(
                          PhosphorIconsRegular.envelope,
                          color: kTextGrey),
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: kTextGrey),
                      hintStyle: TextStyle(color: kTextGrey.withOpacity(0.5)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: kPillGrey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: kPillGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            const BorderSide(color: kDarkGreen, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFDC2626)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFFDC2626), width: 2),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      final emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      );
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone field (optional)
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number (Optional)',
                      hintText: '+62 xxx xxxx xxxx',
                      prefixIcon: const PhosphorIcon(PhosphorIconsRegular.phone,
                          color: kTextGrey),
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: kTextGrey),
                      hintStyle: TextStyle(color: kTextGrey.withOpacity(0.5)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: kPillGrey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: kPillGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            const BorderSide(color: kDarkGreen, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFDC2626)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFFDC2626), width: 2),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value != null && value.trim().isNotEmpty) {
                        if (value.trim().length < 10) {
                          return 'Please enter a valid phone number';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: const PhosphorIcon(PhosphorIconsRegular.lock,
                          color: kTextGrey),
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: kTextGrey),
                      hintStyle: TextStyle(color: kTextGrey.withOpacity(0.5)),
                      suffixIcon: IconButton(
                        icon: PhosphorIcon(
                          _obscurePassword
                              ? PhosphorIconsRegular.eyeSlash
                              : PhosphorIconsRegular.eye,
                          color: kTextGrey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: kPillGrey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: kPillGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            const BorderSide(color: kDarkGreen, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFDC2626)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFFDC2626), width: 2),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password field
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Re-enter your password',
                      prefixIcon: const PhosphorIcon(PhosphorIconsRegular.lock,
                          color: kTextGrey),
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: kTextGrey),
                      hintStyle: TextStyle(color: kTextGrey.withOpacity(0.5)),
                      suffixIcon: IconButton(
                        icon: PhosphorIcon(
                          _obscureConfirmPassword
                              ? PhosphorIconsRegular.eyeSlash
                              : PhosphorIconsRegular.eye,
                          color: kTextGrey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: kPillGrey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: kPillGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            const BorderSide(color: kDarkGreen, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFDC2626)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFFDC2626), width: 2),
                      ),
                    ),
                    obscureText: _obscureConfirmPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Terms checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptTerms = value ?? false;
                          });
                        },
                        activeColor: kDarkGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _acceptTerms = !_acceptTerms;
                            });
                          },
                          child: Text.rich(
                            TextSpan(
                              text: 'I agree to the ',
                              style: TextStyle(
                                fontSize: 13,
                                color: kTextGrey,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyle(
                                    color: kDarkGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.push(AppRouter.termsOfService);
                                    },
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: kDarkGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.push(AppRouter.privacyPolicy);
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Register button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (!_acceptTerms || authState.maybeWhen(
                        loading: () => true,
                        orElse: () => false,
                      ))
                          ? null
                          : _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kDarkGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        disabledBackgroundColor: kDarkGreen.withOpacity(0.5),
                      ),
                      child: authState.maybeWhen(
                        loading: () => true,
                        orElse: () => false,
                      )
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: kTextGrey,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: kDarkGreen,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
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
