import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:putnik_app/present/components/button/btn.dart';
import 'package:putnik_app/present/routes/app_router.gr.dart';
import 'package:putnik_app/present/theme/app_colors.dart';

@RoutePage()
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Spacer(),
                Image.asset(
                  'assets/images/logo.jpg',
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 24),
                Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Btn(
                        text: 'Войти',
                        onPressed:
                            () => AutoRouter.of(context).push(AuthRoute()),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(child: Btn(text: 'Регистрация', onPressed: () {})),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
