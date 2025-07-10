import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:putnik_app/present/components/button/btn.dart';
import 'package:putnik_app/present/routes/app_router.gr.dart';
import 'package:putnik_app/present/theme/app_colors.dart';
import 'package:putnik_app/services/providers/auth_provider.dart';

@RoutePage()
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePwd = true;
  bool _loading = false;

  Future<void> _loginWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final auth = ref.read(authServiceProvider);

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
    final t = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Вход', style: t.headlineLarge),
              const SizedBox(height: 8),
              Text(
                'Войдите в аккаунт для управления и ведения персонажа в любимой DND-игре',
                style: t.bodyMedium,
              ),
              const SizedBox(height: 32),

              // ── Форма ───────────────────────────────────────
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Введите e-mail';
                        final reg = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
                        return reg.hasMatch(v) ? null : 'Неверный e-mail';
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscurePwd,
                      decoration: InputDecoration(
                        labelText: 'Пароль',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePwd
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed:
                              () => setState(() => _obscurePwd = !_obscurePwd),
                        ),
                      ),
                      validator:
                          (v) =>
                              (v == null || v.length < 6)
                                  ? 'Минимум 6 символов'
                                  : null,
                    ),
                    const SizedBox(height: 24),

                    Btn(
                      text: 'Войти',
                      onPressed: _loading ? null : _loginWithEmail,
                      loading: _loading,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Ссылка «Регистрация» ───────────────────────
              Center(
                child: RichText(
                  text: TextSpan(
                    style: t.bodyMedium!.copyWith(color: Colors.grey[700]),
                    children: [
                      const TextSpan(text: 'Нет аккаунта?  '),
                      TextSpan(
                        text: 'Регистрация',
                        style: const TextStyle(
                          color: Colors.blue,
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
