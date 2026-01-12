import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/services/storage_service.dart';
import 'core/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'noTime',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF0F2F5), // Soft grey background
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E1E1E), // Dark primary
          secondary: const Color(0xFF6B4EFF), // Purple accent
          surface: const Color(0xFFFFFFFF),
          surfaceContainerHighest: const Color(0xFFFFFFFF), // Cards are white
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(), // Poppins for that clean look
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 0,
        ),
      ),
      routerConfig: router,
    );
  }
}
