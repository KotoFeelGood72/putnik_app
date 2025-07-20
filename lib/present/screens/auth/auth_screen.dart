import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:putnik_app/present/components/button/btn.dart';
import 'package:putnik_app/present/routes/app_router.dart';

import 'package:putnik_app/present/theme/app_colors.dart';
import 'package:putnik_app/services/auth/firebase_auth_service.dart';

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
              // Заголовок
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
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),

              // Форма
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[800]!, width: 1),
                      ),
                      child: TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey[400],
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Введите e-mail';
                          final reg = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
                          return reg.hasMatch(v) ? null : 'Неверный e-mail';
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[800]!, width: 1),
                      ),
                      child: TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscurePwd,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Пароль',
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.lock, color: Colors.grey[400]),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePwd
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey[400],
                            ),
                            onPressed:
                                () =>
                                    setState(() => _obscurePwd = !_obscurePwd),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        validator:
                            (v) =>
                                (v == null || v.length < 6)
                                    ? 'Минимум 6 символов'
                                    : null,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Кнопка входа
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5B2333),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: const Color(0xFF5B2333).withOpacity(0.3),
                        ),
                        onPressed: _loading ? null : _loginWithEmail,
                        child:
                            _loading
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : const Text(
                                  'Войти',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Ссылка на восстановление пароля
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    children: [
                      const TextSpan(text: 'Забыли пароль?  '),
                      TextSpan(
                        text: 'Восстановить',
                        style: const TextStyle(
                          color: Color(0xFF5B2333),
                          decoration: TextDecoration.underline,
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

              // Ссылка на регистрацию
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    children: [
                      const TextSpan(text: 'Нет аккаунта?  '),
                      TextSpan(
                        text: 'Регистрация',
                        style: const TextStyle(
                          color: Color(0xFF5B2333),
                          decoration: TextDecoration.underline,
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
