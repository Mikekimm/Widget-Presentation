import 'package:flutter/material.dart';
import 'app_colors.dart';


class AppTextStyles {
  AppTextStyles._();

  // Heading Styles Inika font
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Inika',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: 'Inika',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: 'Inika',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: 'Inika',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Body Text Styles Jost font
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Jost',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Jost',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Jost',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Button Text Styles
  static const TextStyle button = TextStyle(
    fontFamily: 'Jost',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.background,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: 'Jost',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.background,
    letterSpacing: 0.5,
  );

  // Caption & Label Styles
  static const TextStyle caption = TextStyle(
    fontFamily: 'Jost',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'Jost',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );
}
