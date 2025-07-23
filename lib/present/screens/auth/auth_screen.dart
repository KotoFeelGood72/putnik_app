import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:putnik_app/present/components/button/btn.dart';

import 'package:putnik_app/present/routes/app_router.dart';
import 'package:putnik_app/present/theme/app_colors.dart';
import 'package:putnik_app/services/auth/firebase_auth_service.dart';
import 'package:putnik_app/present/screens/hero/input_field.dart';

@RoutePage()
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePwd = true;
  bool _loading = false;

  Future<void> _loginWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final auth = FirebaseAuthService();

    try {
      await auth.signIn(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );
      if (!mounted) return;
      context.router.replace(const DashboardRoute());
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_friendlyMessage(e))));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyMessage(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'Пользователь не найден';
        case 'wrong-password':
          return 'Неверный пароль';
        case 'invalid-email':
          return 'Неверный e-mail';
        case 'too-many-requests':
          return 'Слишком много попыток. Попробуйте позже';
      }
    }
    return 'Ошибка входа: $e';
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Вход',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Войдите в аккаунт для управления и ведения персонажа в любимой DND-игре',
                style: TextStyle(fontSize: 20, color: Colors.grey[400]),
              ),
              const SizedBox(height: 40),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email
                    InputField(
                      placeholder: 'E-mail',
                      initialValue: _emailCtrl.text,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (v) => _emailCtrl.text = v,
                      textSize: 20,
                      height: 60,
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      placeholder: 'Пароль',
                      initialValue: _passwordCtrl.text,
                      obscureText: true,
                      showToggle: true,
                      isObscured: _obscurePwd,
                      textSize: 20,
                      height: 60,
                      onToggle:
                          () => setState(() => _obscurePwd = !_obscurePwd),
                      onChanged: (v) => _passwordCtrl.text = v,
                    ),
                    const SizedBox(height: 32),
                    Btn(
                      text: 'Войти',
                      onPressed: _loginWithEmail,
                      loading: _loading,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Forum',
                      fontSize: 20,
                      color: Colors.grey[400],
                    ),
                    children: [
                      const TextSpan(text: 'Забыли пароль?  '),
                      TextSpan(
                        text: 'Восстановить',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap =
                                  () => context.router.push(
                                    const ResetPasswordRoute(),
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Forum',
                      fontSize: 20,
                      color: Colors.grey[400],
                    ),
                    children: [
                      const TextSpan(text: 'Нет аккаунта?  '),
                      TextSpan(
                        text: 'Регистрация',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap =
                                  () => context.router.push(
                                    const RegisterRoute(),
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
