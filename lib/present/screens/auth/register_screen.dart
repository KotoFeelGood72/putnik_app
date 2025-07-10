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
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _confirmPwdCtrl = TextEditingController();

  bool _obscurePwd = true;
  bool _loading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final auth = ref.read(authServiceProvider);

    try {
      await auth.signUp(
        email: _emailCtrl.text.trim(),
        password: _pwdCtrl.text.trim(),
      );

      // ✅ зарегистрировались — ведём на Dashboard
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
        case 'email-already-in-use':
          return 'Такой e-mail уже зарегистрирован';
        case 'invalid-email':
          return 'Неверный e-mail';
        case 'weak-password':
          return 'Слишком простой пароль';
      }
    }
    return 'Ошибка регистрации: $e';
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    _confirmPwdCtrl.dispose();
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
              Text('Регистрация', style: t.headlineLarge),
              const SizedBox(height: 8),
              Text(
                'Создайте аккаунт, чтобы управлять персонажами в любимой D&D-игре',
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

                    // Пароль
                    TextFormField(
                      controller: _pwdCtrl,
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
                              v != null && v.length >= 6
                                  ? null
                                  : 'Минимум 6 символов',
                    ),
                    const SizedBox(height: 16),

                    // Повтор пароля
                    TextFormField(
                      controller: _confirmPwdCtrl,
                      obscureText: _obscurePwd,
                      decoration: const InputDecoration(
                        labelText: 'Повторите пароль',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator:
                          (v) =>
                              v == _pwdCtrl.text ? null : 'Пароли не совпадают',
                    ),
                    const SizedBox(height: 24),

                    Btn(
                      text: 'Зарегистрироваться',
                      loading: _loading,
                      onPressed: _loading ? null : _register,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Ссылка «Войти» ──────────────────────────────
              Center(
                child: RichText(
                  text: TextSpan(
                    style: t.bodyMedium!.copyWith(color: Colors.grey[700]),
                    children: [
                      const TextSpan(text: 'Уже есть аккаунт?  '),
                      TextSpan(
                        text: 'Войти',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap =
                                  () =>
                                      context.router.replace(const AuthRoute()),
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
