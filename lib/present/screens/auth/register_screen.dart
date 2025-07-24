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
      body: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultHead(
                  title: 'Регистрация',
                  description:
                      'Создайте аккаунт, чтобы управлять персонажами в любимой D&D-игре',
                ),
                SizedBox(height: 40),

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
                      const SizedBox(height: 16),
                      InputField(
                        placeholder: 'Пароль',
                        obscureText: true,
                        isObscured: _obscurePwd,
                        showToggle: true,
                        onToggle:
                            () => setState(() => _obscurePwd = !_obscurePwd),
                        initialValue: _pwdCtrl.text,
                        onChanged: (v) {
                          _pwdCtrl.text = v;
                          _pwdCtrl.selection = TextSelection.fromPosition(
                            TextPosition(offset: v.length),
                          );
                        },
                        textSize: 16,
                        height: 56,
                        customSuffixIcon: null,
                        label: null,
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        placeholder: 'Повторите пароль',
                        obscureText: true,
                        isObscured: _obscurePwd,
                        showToggle: false,
                        initialValue: _confirmPwdCtrl.text,
                        onChanged: (v) {
                          _confirmPwdCtrl.text = v;
                          _confirmPwdCtrl
                              .selection = TextSelection.fromPosition(
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
                        text: 'Зарегистрироваться',
                        onPressed: _register,
                        loading: _loading,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Forum',
                        fontSize: 20,
                        color: Colors.grey[400],
                      ),
                      children: [
                        const TextSpan(text: 'Уже есть аккаунт? '),
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

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
