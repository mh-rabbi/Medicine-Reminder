import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const GradientButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.25), blurRadius: 18)],
        ),
        child: Center(
          child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
