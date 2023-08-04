import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:wallet_app/loading_page.dart';
import 'package:wallet_app/themes.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.init((await getApplicationDocumentsDirectory()).path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: ResponsiveSizer(
        builder: (p0, p1, p2) => MaterialApp(
          title: 'Wallet',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: "/loading",
          routes: {
            "/loading": (context) => const LoadingPage(),
            "/home": (context) => const HomePage(),
          },
        ),
      ),
    );
  }
}
