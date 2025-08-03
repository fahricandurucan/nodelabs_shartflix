import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nodelabs_shartflix/core/constants/app_colors.dart';

import '../../../../core/widgets/language_selector.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      if (!_acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'terms_agreement_part1'.tr()} ${'terms_agreement_part2'.tr()}'),
            backgroundColor: AppColors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      context.read<AuthBloc>().add(
            RegisterRequested(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  void _handlePhotoUploaded() {
    // Photo was uploaded successfully, now proceed with registration
    _handleRegister();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
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
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 24.0,
              bottom: 24.0 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Header Section
                  Text(
                    'register_title'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'register_subtitle'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Name Input
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'full_name'.tr(),
                    prefixIcon: Icons.person_add_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'full_name_required'.tr();
                      }
                      if (value.trim().split(' ').length < 2) {
                        return 'full_name_invalid'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

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

                  // Confirm Password Input
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: 'confirm_password'.tr(),
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    isPassword: true,
                    isPasswordVisible: _isConfirmPasswordVisible,
                    onSuffixIconTap: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'confirm_password_required'.tr();
                      }
                      if (value != _passwordController.text) {
                        return 'passwords_not_match'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  // Terms and Conditions
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptedTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptedTerms = value ?? false;
                          });
                        },
                        activeColor: AppColors.red,
                        checkColor: Colors.white,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _showTermsDialog();
                          },
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(text: 'terms_agreement_part1'.tr()),
                                TextSpan(
                                  text: 'terms_agreement_part2'.tr(),
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: AppColors.red,
                                  ),
                                ),
                                TextSpan(text: 'please_read_terms'.tr()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Register Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
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
                            'register_button'.tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton(
                        icon: 'G',
                        onTap: () {
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
                          // TODO: Implement Facebook register
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('facebook_register'.tr()),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'has_account'.tr(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go('/login');
                        },
                        child: Text(
                          'login_link'.tr(),
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

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          title: Text(
            'terms_title'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              'terms_content'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'terms_close'.tr(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _acceptedTerms = true;
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'terms_accept'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
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
