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
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _emailSent = false;

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final auth = ref.read(authServiceProvider);

    try {
      await auth.resetPassword(_emailCtrl.text.trim());

      if (!mounted) return;
      setState(() {
        _emailSent = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Письмо для восстановления пароля отправлено на ваш e-mail',
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
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
        case 'user-not-found':
          return 'Пользователь с таким e-mail не найден';
        case 'invalid-email':
          return 'Неверный формат e-mail';
        case 'too-many-requests':
          return 'Слишком много попыток. Попробуйте позже';
      }
    }
    return 'Ошибка восстановления пароля: $e';
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
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
                        'Восстановление пароля',
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
                        'Введите ваш e-mail для получения ссылки на восстановление пароля',
                        style: t.bodyMedium?.copyWith(
                          color: AppColors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Форма восстановления
                if (!_emailSent) ...[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email поле
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
                              if (v == null || v.isEmpty)
                                return 'Введите e-mail';
                              final reg = RegExp(
                                r'^[\w\.-]+@[\w\.-]+\.\w{2,}$',
                              );
                              return reg.hasMatch(v) ? null : 'Неверный e-mail';
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Кнопка отправки
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.accentLight,
                              ],
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
                            text: 'Отправить письмо',
                            loading: _loading,
                            onPressed: _loading ? null : _resetPassword,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Сообщение об успешной отправке
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: AppColors.success,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Письмо отправлено!',
                          style: t.headlineSmall?.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Проверьте вашу почту и следуйте инструкциям для восстановления пароля',
                          style: t.bodyMedium?.copyWith(
                            color: AppColors.white.withOpacity(0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // Ссылки навигации
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
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: t.bodyMedium?.copyWith(
                              color: AppColors.white.withOpacity(0.8),
                            ),
                            children: [
                              const TextSpan(text: 'Вспомнили пароль?  '),
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
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: t.bodyMedium?.copyWith(
                              color: AppColors.white.withOpacity(0.8),
                            ),
                            children: [
                              const TextSpan(text: 'Нет аккаунта?  '),
                              TextSpan(
                                text: 'Зарегистрироваться',
                                style: TextStyle(
                                  color: AppColors.accentLight,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap =
                                          () => context.router.replace(
                                            const RegisterRoute(),
                                          ),
                              ),
                            ],
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
      ),
    );
  }
}
