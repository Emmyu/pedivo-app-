import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pedivo_activity_verification/constants/app_theme.dart';
import 'package:pedivo_activity_verification/providers/activity_provider.dart';
import 'package:pedivo_activity_verification/screens/index.dart';
import 'package:pedivo_activity_verification/services/index.dart';

void main() {
  runApp(const PedivoApp());
}

/// Main application widget
class PedivoApp extends StatelessWidget {
  const PedivoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ActivityService>(create: (_) => ActivityService()),
        Provider<VerificationService>(create: (_) => VerificationService()),
        ChangeNotifierProvider(
          create: (context) => ActivityNotifier(
            context.read<ActivityService>(),
            context.read<VerificationService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Pedivo Activity Verification',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        home: const ActivityFeedScreen(),
      ),
    );
  }

  /// Build the app theme
  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        centerTitle: true,
      ),
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.cardBackground,
      dividerColor: AppColors.divider,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.white,
          textStyle: AppTextStyles.label,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          textStyle: AppTextStyles.label,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          textStyle: AppTextStyles.label,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}
