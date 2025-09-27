import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:pharmaplus_flutter/presentation/screens/splash_screen.dart';
import 'package:pharmaplus_flutter/providers/email_authenticafion_provider.dart';
import 'package:pharmaplus_flutter/providers/google_signin_provider.dart';
import 'package:pharmaplus_flutter/providers/login_providers.dart';
import 'package:pharmaplus_flutter/providers/medicine_provider.dart';
import 'package:pharmaplus_flutter/providers/signup_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        // StreamProvider for authentication state
        StreamProvider<User?>(
          create: (_) => FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),

        ChangeNotifierProvider(create: (_) => EmailAuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}
