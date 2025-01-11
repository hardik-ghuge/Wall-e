import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:sem5_walle/CONSTANTS/constants.dart';
import 'package:sem5_walle/PAGES/homepage1.dart';

void main()async{
  Gemini.init(apiKey: API_KEY);
  runApp( const MyApp1());
}

class MyApp1 extends StatefulWidget {
  const MyApp1({super.key});

  @override
  State<MyApp1> createState() => _MyApp1State();
}

class _MyApp1State extends State<MyApp1> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Wall-e",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const HomePage1(),
    );
  }
}