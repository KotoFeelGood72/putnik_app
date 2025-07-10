import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:putnik_app/present/components/button/icon_btn.dart';

class SectionHead extends StatelessWidget {
  final String? title;
  final String? link;
  const SectionHead({super.key, this.title, this.link});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(
            title!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          IconBtn(
            iconName: 'arrow_right',
            onTap: () => AutoRouter.of(context).pushNamed(link!),
          ),
        ],
      ),
    );
  }
}
