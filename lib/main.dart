import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmaplus_flutter/presentation/constants/theme.dart';
import 'package:pharmaplus_flutter/presentation/screens/medicine_list_screen.dart';
import 'package:pharmaplus_flutter/presentation/screens/splash_screen.dart';
import 'package:pharmaplus_flutter/providers/auth_state_provider.dart';
import 'package:pharmaplus_flutter/providers/email_authenticafion_provider.dart';
import 'package:pharmaplus_flutter/providers/google_signin_provider.dart';
import 'package:pharmaplus_flutter/providers/login_providers.dart';
import 'package:pharmaplus_flutter/providers/medicine_provider.dart';
import 'package:pharmaplus_flutter/providers/signup_provider.dart';
import 'package:pharmaplus_flutter/providers/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        StreamProvider<User?>(
          create: (_) => FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
        ChangeNotifierProvider(create: (_) => EmailAuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
        ChangeNotifierProvider(create: (_) => AuthStateProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // ✅ Correct
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Use ThemeProvider here
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pharma Plus',

      // 👇 This makes light/dark switch work
      themeMode: themeProvider.themeMode,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,

      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthStateProvider>(context);

    if (authState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return authState.isLoggedIn
        ? const MedicineListScreen()
        : const SplashScreen();
  }
}
