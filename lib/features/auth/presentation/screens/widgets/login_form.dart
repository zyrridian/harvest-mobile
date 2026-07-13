import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../core/utils/validators.dart';

// Design constants matching current style
const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class LoginForm extends ConsumerStatefulWidget {
  final Function(String email, String password) onSubmit;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !widget.isLoading,
            style: TextStyle(color: kDarkGreen),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: kTextGrey),
              hintText: 'Enter your email',
              hintStyle: TextStyle(color: kTextGrey.withOpacity(0.5)),
              prefixIcon: const PhosphorIcon(PhosphorIconsRegular.envelope, color: kDarkGreen),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: kPillGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: kPillGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: kDarkGreen, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFDC2626)),
              ),
            ),
            validator: Validators.email,
          ),
          const SizedBox(height: 16),

          // Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            enabled: !widget.isLoading,
            style: TextStyle(color: kDarkGreen),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: kTextGrey),
              hintText: 'Enter your password',
              hintStyle: TextStyle(color: kTextGrey.withOpacity(0.5)),
              prefixIcon: const PhosphorIcon(PhosphorIconsRegular.lock, color: kDarkGreen),
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
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: kPillGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: kPillGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: kDarkGreen, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFDC2626)),
              ),
            ),
            validator: Validators.password,
            onFieldSubmitted: (_) => _handleSubmit(),
          ),
          const SizedBox(height: 24),

          // Login Button
          ElevatedButton(
            onPressed: widget.isLoading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              disabledBackgroundColor: kPillGrey,
            ),
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
