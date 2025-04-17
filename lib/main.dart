import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/screens/splash_screen/splash_screen.dart';
import 'package:expense_tracker/view_models/add_transaction_provider.dart';
import 'package:expense_tracker/view_models/transaction_list_provider.dart';
import 'package:expense_tracker/view_models/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  // Register adapter before opening the box
  Hive.registerAdapter(TransactionAdapter());

  // Open the Hive box and wait for it
  await Hive.openBox<Transaction>(Strings.trs);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
        ChangeNotifierProvider(create: (context) => AddTransactionProvider()),
        ChangeNotifierProvider(create: (context) => TransactionListProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
