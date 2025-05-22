import 'package:flutter/material.dart';

ThemeData darkTheme() {
  final ColorScheme customDarkColorScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFBCC3FF),
    onPrimary: Color(0xFF242C61),
    primaryContainer: Color(0xFF3B4279),
    onPrimaryContainer: Color(0xFFDFE0FF),
    secondary: Color(0xFFC4C5DD),
    onSecondary: Color(0xFF2D2F42),
    secondaryContainer: Color(0xFF434559),
    onSecondaryContainer: Color(0xFFE0E1F9),
    tertiary: Color(0xFFE6BAD7),
    onTertiary: Color(0xFF45263D),
    tertiaryContainer: Color(0xFF5D3C54),
    onTertiaryContainer: Color(0xFFFFD7F0),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF131318),
    onSurface: Color(0xFFE4E1E9),
    onSurfaceVariant: Color(0xFFC7C5D0),
    outline: Color(0xFF90909A),
    inverseSurface: Color(0xFFE4E1E9),
    onInverseSurface: Color(0xFF303036),
    inversePrimary: Color(0xFF535A92),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFBCC3FF),
  );

  final ThemeData theme = ThemeData(
    useMaterial3: true,
    colorScheme: customDarkColorScheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: customDarkColorScheme.primaryContainer,
        foregroundColor: customDarkColorScheme.onPrimaryContainer,
        shadowColor: customDarkColorScheme.shadow,
        elevation: 2,
      ),
    ),
    textTheme: TextTheme(titleLarge: TextStyle(fontWeight: FontWeight.bold)),
  );
  return theme;
}

ThemeData lightTheme() {
  final ColorScheme customLightColorScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF3B4279),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFDFE0FF),
    onPrimaryContainer: Color(0xFF242C61),
    secondary: Color(0xFF434559),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE0E1F9),
    onSecondaryContainer: Color(0xFF2D2F42),
    tertiary: Color(0xFF5D3C54),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFD7F0),
    onTertiaryContainer: Color(0xFF45263D),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF690005),
    surface: Color(0xFFFFFBFF),
    onSurface: Color(0xFF1C1B1F),
    onSurfaceVariant: Color(0xFF48464F),
    outline: Color(0xFF797780),
    inverseSurface: Color(0xFF303036),
    onInverseSurface: Color(0xFFF2F0F4),
    inversePrimary: Color(0xFFBCC3FF),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF3B4279),
  );


  final ThemeData theme = ThemeData(
    useMaterial3: true,
    colorScheme: customLightColorScheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: customLightColorScheme.primaryContainer,
        foregroundColor: customLightColorScheme.onPrimaryContainer,
        shadowColor: customLightColorScheme.shadow,
        elevation: 2,
      ),
    ),
    textTheme: TextTheme(titleLarge: TextStyle(fontWeight: FontWeight.bold)),
  );
  return theme;
}