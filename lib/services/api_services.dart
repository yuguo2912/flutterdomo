import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


String URL_GET_USER = 'http://localhost:8080/auth/register';
String URL_GET_TOKEN = 'http://localhost:8080/auth/login';
String URL_GET_SENSOR = 'http://localhost:8080/sensor-data';
String URL_GET_SENSOR_BY_MINUTES = 'http://localhost:8080/sensor-data/recent';
String URL_DELETE_SENSOR = 'http://localhost:8080/sensor-data/remove';
String? bearerToken; // Variable globale pour stocker le token


class ApiServices{
  static Future<http.Response> createUserRegister(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(URL_GET_USER),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "username": username,
          "email": email,
          "password": password,
        }),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> getUserToken(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(URL_GET_TOKEN),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "username": username,
          "password": password,
        }),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> getAllSensor() async {
    try {
      final response = await http.get(
        Uri.parse(URL_GET_SENSOR),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> getSensorById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$URL_GET_SENSOR/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> getSensorByMinutes(int minutes) async {
    try {
      final response = await http.get(
        Uri.parse('$URL_GET_SENSOR_BY_MINUTES/$minutes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> deleteSensorById(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$URL_DELETE_SENSOR/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}