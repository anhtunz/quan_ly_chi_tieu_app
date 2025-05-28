import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppThemeLight extends AppTheme {
  static AppThemeLight? _instance;
  static AppThemeLight get instance {
    _instance ??= AppThemeLight._init();
    return _instance!;
  }

  AppThemeLight._init();

  @override
  ThemeData get theme => FlexThemeData.light(
        // Using FlexColorScheme built-in FlexScheme enum based colors
         scheme: FlexScheme.green,
        // Convenience direct styling properties.
        bottomAppBarElevation: 20.0,
        // Component theme configurations for light mode.
        subThemesData: const FlexSubThemesData(
          interactionEffects: true,
          tintedDisabledControls: true,
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
