import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:harvest_app/features/auth/domain/entities/user.dart';
import 'package:harvest_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:harvest_app/features/auth/presentation/providers/auth_state.dart';
import 'package:harvest_app/features/auth/presentation/screens/widgets/login_form.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// Design constants matching current style
const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class LoginScreen extends ConsumerWidget {
  final String role;
  const LoginScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft, color: kDarkGreen),
          onPressed: () => context.go(AppRouter.roleSelection),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo or App Name
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F5F2), // Light green tint
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.agriculture,
                    size: 50,
                    color: kDarkGreen,
                  ),
                ),
                const SizedBox(height: 32),

                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                Text(
                  'Login to your account to continue',
                  style: TextStyle(
                    color: kTextGrey,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Login Form
                LoginForm(
                  onSubmit: (email, password) async {
                    await ref.read(authControllerProvider.notifier).login(
                          email: email,
                          password: password,
                        );
                  },
                  isLoading: authState.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  ),
                ),
                const SizedBox(height: 24),

                // Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: kTextGrey,
                        fontSize: 15,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('${AppRouter.register}?role=$role'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: kDarkGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
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
    );
  }
}
