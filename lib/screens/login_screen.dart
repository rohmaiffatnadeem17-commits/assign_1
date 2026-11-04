import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'product_list_screen.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState<String>>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) =>
      emailRegex.hasMatch((v ?? '').trim()) ? null : AppStrings.errEmail;

  String? _validatePassword(String? v) =>
      (v ?? '').length >= 6 ? null : AppStrings.errPassword;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text,
      );
      if (!mounted) return;
      // clear the back stack: Back will not return to login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ProductListScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      showMessage(context, e.message ?? 'Login failed. Please try again.');
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      showMessage(context, 'Something went wrong: $e');
    }
  }

  Future<void> _resetPassword() async {
    // validate only the email field
    if (!(_emailKey.currentState?.validate() ?? false)) return;
    final email = _email.text.trim();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      showMessage(context, 'Reset link sent to $email');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showMessage(context, e.message ?? 'Could not send reset email.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Welcome back',
      subtitle: 'Log in to continue shopping',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextField(
              fieldKey: _emailKey,
              controller: _email,
              label: 'Email',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _password,
              label: 'Password',
              icon: Icons.lock_outline_rounded,
              isPassword: true,
              textInputAction: TextInputAction.done,
              validator: _validatePassword,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _resetPassword,
                child: const Text('Forgot password?',
                    style: TextStyle(
                        color: AppColors.navy, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 8),
            PrimaryButton(label: 'Log in', loading: _loading, onPressed: _login),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('New here?', style: TextStyle(color: Colors.grey.shade600)),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  ),
                  child: const Text('Sign up',
                      style: TextStyle(
                          color: AppColors.navy, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
