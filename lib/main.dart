import 'package:did/appConstants.dart';
import 'package:did/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DID Task',
      initialRoute: "/",
      theme: ThemeData(
        brightness: Brightness.light,
        backgroundColor: AppConstants.appBackGroundColor,
        primarySwatch: Colors.yellow,
      ),
      home: const Splash(),
    );
  }
}
