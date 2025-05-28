import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppThemeDark extends AppTheme {
  static AppThemeDark? _instance;
  static AppThemeDark get instance {
    _instance ??= AppThemeDark._init();
    return _instance!;
  }

  AppThemeDark._init();

  @override
  ThemeData get theme => FlexThemeData.dark(
        // Using FlexColorScheme built-in FlexScheme enum based colors.
        scheme: FlexScheme.green,
        // Component theme configurations for dark mode.
        subThemesData: const FlexSubThemesData(
          interactionEffects: true,
          tintedDisabledControls: true,
          blendOnColors: true,
          useM2StyleDividerInM3: true,
          inputDecoratorBorderType: FlexInputBorderType.outline,
          alignedDropdown: true,
          tooltipRadius: 20,
          tooltipWaitDuration: Duration(milliseconds: 1600),
          tooltipShowDuration: Duration(milliseconds: 1500),
          navigationRailUseIndicator: true,
        ),
        // Direct ThemeData properties.
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      );
}
