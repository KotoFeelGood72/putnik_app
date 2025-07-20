import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:putnik_app/present/components/button/btn.dart';
import 'package:putnik_app/present/routes/app_router.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_friendlyMessage(e)),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
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
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.surface, AppColors.background],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок с фэнтезийным стилем
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.accentLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColorLight,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Регистрация',
                        style: t.headlineLarge?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: AppColors.black.withOpacity(0.3),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Создайте аккаунт, чтобы управлять персонажами в любимой D&D-игре',
                        style: t.bodyMedium?.copyWith(
                          color: AppColors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ── Форма ───────────────────────────────────────
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowColorLight,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: AppColors.white),
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            labelStyle: TextStyle(
                              color: AppColors.white.withOpacity(0.7),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: AppColors.primary,
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
                      const SizedBox(height: 16),

                      // Пароль
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowColorLight,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _pwdCtrl,
                          obscureText: _obscurePwd,
                          style: TextStyle(color: AppColors.white),
                          decoration: InputDecoration(
                            labelText: 'Пароль',
                            labelStyle: TextStyle(
                              color: AppColors.white.withOpacity(0.7),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: AppColors.primary,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePwd
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.primary,
                              ),
                              onPressed:
                                  () => setState(
                                    () => _obscurePwd = !_obscurePwd,
                                  ),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator:
                              (v) =>
                                  v != null && v.length >= 6
                                      ? null
                                      : 'Минимум 6 символов',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Повтор пароля
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowColorLight,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _confirmPwdCtrl,
                          obscureText: _obscurePwd,
                          style: TextStyle(color: AppColors.white),
                          decoration: InputDecoration(
                            labelText: 'Повторите пароль',
                            labelStyle: TextStyle(
                              color: AppColors.white.withOpacity(0.7),
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: AppColors.primary,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator:
                              (v) =>
                                  v == _pwdCtrl.text
                                      ? null
                                      : 'Пароли не совпадают',
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Кнопка регистрации
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.accentLight],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowColorLight,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Btn(
                          text: 'Зарегистрироваться',
                          loading: _loading,
                          onPressed: _loading ? null : _register,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Ссылка «Войти» ──────────────────────────────
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: t.bodyMedium?.copyWith(
                          color: AppColors.white.withOpacity(0.8),
                        ),
                        children: [
                          const TextSpan(text: 'Уже есть аккаунт?  '),
                          TextSpan(
                            text: 'Войти',
                            style: TextStyle(
                              color: AppColors.accentLight,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap =
                                      () => context.router.replace(
                                        const AuthRoute(),
                                      ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
