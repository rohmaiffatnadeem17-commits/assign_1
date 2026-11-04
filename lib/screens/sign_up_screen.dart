import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'product_list_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final name = _name.text.trim();
    final email = _email.text.trim();

    try {
      // 1) create the user in Firebase Authentication
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: _password.text,
      );

      // 2) save the profile in Firestore at users/{uid}
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ProductListScreen()),
        (route) => false,
      );
    } on FirebaseException catch (e) {
      // covers FirebaseAuthException too
      _showError(e.message ?? 'Sign up failed. Please try again.');
    } catch (e) {
      _showError('Something went wrong: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    setState(() => _loading = false);
    showMessage(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Create account',
      subtitle: 'Join ShopEase in a few seconds',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextField(
              controller: _name,
              label: 'Full name',
              icon: Icons.person_outline_rounded,
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? AppStrings.errName : null,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _email,
              label: 'Email',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => emailRegex.hasMatch((v ?? '').trim())
                  ? null
                  : AppStrings.errEmail,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _password,
              label: 'Password',
              icon: Icons.lock_outline_rounded,
              isPassword: true,
              validator: (v) =>
                  (v ?? '').length >= 6 ? null : AppStrings.errPassword,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _confirm,
              label: 'Confirm password',
              icon: Icons.lock_reset_rounded,
              isPassword: true,
              textInputAction: TextInputAction.done,
              validator: (v) =>
                  v == _password.text ? null : AppStrings.errMatch,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
                label: 'Sign up', loading: _loading, onPressed: _signUp),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Have an account?',
                    style: TextStyle(color: Colors.grey.shade600)),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Log in',
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
