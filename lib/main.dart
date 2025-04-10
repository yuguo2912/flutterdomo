

import 'package:flutter/material.dart';
import 'package:flutter_domotic/pages/register_page.dart';

// String URL_GET_USER = 'http://localhost:8080/auth/register';
// String URL_GET_TOKEN = 'http://localhost:8080/auth/login';
// String URL_GET_SENSOR = 'http://localhost:8080/sensor-data';
// String URL_GET_SENSOR_BY_MINUTES = 'http://localhost:8080/sensor-data/recent';
// String URL_DELETE_SENSOR = 'http://localhost:8080/sensor-data/remove';
// String? bearerToken; // Variable globale pour stocker le token

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Domotic',
      debugShowCheckedModeBanner: false, // Supprime la banderole "debug"
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: RegisterPage(),
    );
  }
}

