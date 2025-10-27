import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/router/app_router.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../widgets/login_form.dart';

// Simple loading state provider for demo
final isLoadingProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);
    // final authState = ref.watch(authControllerProvider);

    // // Listen to auth state changes
    // ref.listen<AuthState>(authControllerProvider, (previous, next) {
    //   next.maybeWhen(
    //     error: (message) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text(message),
    //           backgroundColor: AppColors.error,
    //         ),
    //       );
    //     },
    //     authenticated: (_) {
    //       // Navigate to home screen
    //       // Navigator.of(context).pushReplacementNamed('/home');
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(
    //           content: Text('Login successful!'),
    //           backgroundColor: AppColors.success,
    //         ),
    //       );
    //     },
    //     orElse: () {},
    //   );
    // });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo or App Name
                const Icon(
                  Icons.agriculture,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),

                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                Text(
                  'Login to continue',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Login Form
                LoginForm(
                  // onSubmit: (email, password) {
                  //   ref.read(authControllerProvider.notifier).login(
                  //         email: email,
                  //         password: password,
                  //       );
                  // },
                  // isLoading: authState is AuthLoading,
                  onSubmit: (email, password) async {
                    // Set loading state
                    ref.read(isLoadingProvider.notifier).state = true;

                    // Simulate login delay
                    await Future.delayed(const Duration(seconds: 1));

                    // Reset loading state
                    ref.read(isLoadingProvider.notifier).state = false;

                    // Show success message
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Login successful!'),
                          backgroundColor: AppColors.success,
                          duration: Duration(seconds: 1),
                        ),
                      );

                      // Navigate to main screen
                      context.go(AppRouter.main);
                    }
                  },
                  isLoading: isLoading,
                ),
                const SizedBox(height: 16),

                // Forgot Password
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Forgot password feature coming soon'),
                      ),
                    );
                  },
                  child: const Text('Forgot Password?'),
                ),
                const SizedBox(height: 24),

                // Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        context.push(AppRouter.register);
                      },
                      child: const Text('Sign Up'),
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
