import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'src/home_page.dart';
import 'src/onboarding_page.dart';

void main() {
  initialConfig();
  runApp(const MyApp());
}

// String initialRoute = Home.route;
String initialRoute = OnboardingPage.route;
Future<void> initialConfig() async {
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: goRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

final goRouter = GoRouter(initialLocation: OnboardingPage.route, routes: [
  GoRoute(
      path: OnboardingPage.route,
      name: OnboardingPage.route,
      builder: (context, state) => const OnboardingPage(),
      routes: [
        GoRoute(path: HomePage.route, name: HomePage.route, builder: (context, state) => const HomePage()),
      ])
]);
