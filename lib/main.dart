import 'package:astrotalk/Astrolgers%20list.dart';
import 'package:astrotalk/Bio.dart';
import 'package:astrotalk/Login.dart';
import 'package:astrotalk/SignUp%20Astrologer.dart';
import 'package:astrotalk/SignUp.dart';
import 'package:astrotalk/OtpScreen.dart';
import 'package:astrotalk/Splash.dart';
import 'package:astrotalk/feedback%20Screen.dart';
import 'package:astrotalk/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'Homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize Flutter bindings
  bool envLoaded = false;
  
  try {
    await dotenv.load(fileName: "lib/.env");
    final razorpayKey = dotenv.env['RAZORPAY_KEY'];
    if (razorpayKey == null || razorpayKey.isEmpty) {
      throw Exception('RAZORPAY_KEY not found in .env file');
    }
    envLoaded = true;
  } catch (e) {
    debugPrint('Error loading .env file: $e');
  }

  runApp(MyApp(envLoaded: envLoaded));
}

class MyApp extends StatelessWidget {
  final bool envLoaded;
  const MyApp({super.key, this.envLoaded = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AstroTalk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6B4E71),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B4E71)),
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) {
          if (!envLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Configuration Error'),
                    content: const Text('Payment system configuration is missing or invalid. Please contact support.'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            });
          }
          return const Splash();
        },
      ),
    );
  }
}
