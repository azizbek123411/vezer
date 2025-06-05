import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vezer/provider/theme_provider.dart';
import 'package:vezer/theme/theme.dart';
import 'package:vezer/view/splash_screens/splash_screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final themeMode=ref.watch(themeNotifierProvider);
    return MaterialApp(
      themeMode: themeMode,
      theme:lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
    
      home: const SplashScreen(),
    );
  }
}
