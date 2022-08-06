import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotsong/pages/home_page.dart';
import 'package:spotsong/services/showlist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? light, ColorScheme? dark) {
      return MaterialApp(
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0))),
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
          ),
          useMaterial3: true,
          colorScheme: light ??
              ColorScheme.fromSeed(
                seedColor: Colors.blueAccent,
                brightness: Brightness.light,
              ),
        ),
        themeMode: ThemeMode.system,
        darkTheme: ThemeData(
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
          ),
          useMaterial3: true,
          colorScheme: dark ??
              ColorScheme.fromSeed(
                seedColor: Colors.blueAccent,
                brightness: Brightness.dark,
              ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const Home(),
          '/showinfo':(context) => const ShowInfo(),
        },
      );
    });
  }
}
