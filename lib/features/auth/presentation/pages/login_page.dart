import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nodelabs_shartflix/core/constants/app_colors.dart';

import '../../../../core/widgets/language_selector.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      context.read<AuthBloc>().add(
            LoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          LanguageSelector(
            onLocaleChanged: () => setState(() {}),
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is Authenticated) {
            setState(() {
              _isLoading = false;
            });
            context.go('/discover');
          } else if (state is AuthError) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),

                  // Header Section
                  Text(
                    'login_title'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'login_subtitle'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Email Input
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'email'.tr(),
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'email_required'.tr();
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'email_invalid'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Input
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'password'.tr(),
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    isPassword: true,
                    isPasswordVisible: _isPasswordVisible,
                    onSuffixIconTap: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'password_required'.tr();
                      }
                      if (value.length < 6) {
                        return 'password_min_length'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('forgot_password_message'.tr()),
                          ),
                        );
                      },
                      child: Text(
                        'forgot_password'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Login Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'login_button'.tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 32),

                  // Social Login Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton(
                        icon: 'G',
                        onTap: () {
                          // TODO: Implement Google login
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('google_register'.tr()),
                            ),
                          );
                        },
                      ),
                      _buildSocialButton(
                        icon: 'A',
                        onTap: () {
                          // TODO: Implement Apple login
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('apple_register'.tr()),
                            ),
                          );
                        },
                      ),
                      _buildSocialButton(
                        icon: 'f',
                        onTap: () {
                          // TODO: Implement Facebook login
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('facebook_register'.tr()),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const Spacer(),

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'no_account'.tr(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go('/register');
                        },
                        child: Text(
                          'sign_up'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        padding: icon == 'A' ? const EdgeInsets.all(16) : null,
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(8),
        ),
        child: icon == 'A'
            ? Image.asset(
                'assets/animations/apple.png',
                width: 36,
                height: 36,
                color: Colors.white,
              )
            : Center(
                child: Text(
                  icon,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}
