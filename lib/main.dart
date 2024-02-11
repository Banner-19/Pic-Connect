import 'package:flutter/material.dart';
import 'package:picconnect/pages/homePage.dart';
import 'package:picconnect/pages/loginPage.dart';
import 'package:picconnect/pages/registerPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:picconnect/services/firebase_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:const FirebaseOptions(
      apiKey: "AIzaSyBOhnfQ2syLsAcckU4Fe60kDLJy8Q7zFVE", 
      appId: "1:8675328586:android:3651d61653d9919d26dcb3", 
      messagingSenderId: "8675328586", 
      projectId: "pic-connect",
      storageBucket: "pic-connect.appspot.com"
    )
  );
  GetIt.instance.registerSingleton<FirebaseService>(
    FirebaseService()
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pic Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'ProtestRiot',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginPage(),
        'register':(context) => RegisterPage(),
        'home':(context) => HomePage(),
      },
    );
  }
}

