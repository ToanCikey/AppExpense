import 'package:doancuoiky/providers/auth_provider.dart';
import 'package:doancuoiky/providers/category_provider.dart';
import 'package:doancuoiky/providers/report_provider.dart';
import 'package:doancuoiky/providers/transaction_provider.dart';
import 'package:doancuoiky/views/auth/login_screen.dart';
import 'package:doancuoiky/views/auth/register_screen.dart';
import 'package:doancuoiky/views/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('vi', null);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
      ],
      child: OKToast(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/login' : '/home',
      routes: {
        "/login": (context) => LoginScreen(),
        "/register": (context) => RegisterScreen(),
        "/home": (context) => HomePage(),
      },
    );
  }
}
