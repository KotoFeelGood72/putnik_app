import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:putnik_app/present/components/button/btn.dart';
import 'package:putnik_app/present/components/head/default_head.dart';
import 'package:putnik_app/present/routes/app_router.dart';
import 'package:putnik_app/present/screens/hero/input_field.dart';
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
      body: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultHead(
                  title: 'Восстановление пароля',
                  description:
                      'Введите ваш e-mail для получения ссылки на восстановление пароля',
                ),
                SizedBox(height: 40),

                if (!_emailSent) ...[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InputField(
                          placeholder: 'E-mail',
                          keyboardType: TextInputType.emailAddress,
                          initialValue: _emailCtrl.text,
                          onChanged: (v) {
                            _emailCtrl.text = v;
                            _emailCtrl.selection = TextSelection.fromPosition(
                              TextPosition(offset: v.length),
                            );
                          },
                          textSize: 16,
                          height: 56,
                          customSuffixIcon: null,
                          label: null,
                        ),
                        const SizedBox(height: 24),
                        Btn(
                          text: 'Отправить письмо',
                          onPressed: _resetPassword,
                          loading: _loading,
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
                        const TextSpan(text: 'Вспомнили пароль?  '),
                        TextSpan(
                          text: 'Войти',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap =
                                    () =>
                                        context.router.push(const AuthRoute()),
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
      ),
    );
  }
}
