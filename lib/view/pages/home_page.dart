import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vezer/provider/theme_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
      final themeMode=ref.watch(themeNotifierProvider);
  final notifier=ref.read(themeNotifierProvider.notifier);
  final isDark= themeMode==ThemeMode.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
       actions: [
        SizedBox(width: 25,),
        SizedBox(
          height: 50,
          width: 300,
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Search city',
            prefixIcon: Icon(Icons.search,color: Theme.of(context).colorScheme.surface,),
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.surface,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.surface,
              ),  
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ),),
        Spacer(),
        IconButton(
          onPressed: notifier.toggleTheme,
          icon: Icon(isDark?Icons.dark_mode: Icons.light_mode,
          color: Theme.of(context).colorScheme.surface,),
        )
       ],
      ),
    );
  }
}