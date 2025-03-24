import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String URL_GET_USER = 'http://localhost:8080/auth/register';
String URL_GET_TOKEN = 'http://localhost:8080/auth/login';
String URL_GET_SENSOR = 'http://localhost:8080/sensor-data';
String URL_GET_SENSOR_BY_MINUTES = 'http://localhost:8080/sensor-data/recent';
String URL_DELETE_SENSOR = 'http://localhost:8080/sensor-data/remove';
String? bearerToken; // Variable globale pour stocker le token

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Domotic',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: RegisterPage(),
    );
  }
}

class ApiServices {
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

class RegisterPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Register',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final response = await ApiServices.createUserRegister(
                    usernameController.text,
                    emailController.text,
                    passwordController.text,
                  );
                  if (response.statusCode == 201) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User registered successfully!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to register: ${response.body}')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text(
                  'Already registered? Go to Login',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final response = await ApiServices.getUserToken(
                    usernameController.text,
                    passwordController.text,
                  );
                  if (response.statusCode == 200) {
                    final responseBody = jsonDecode(response.body);
                    bearerToken = responseBody['token'];
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to login: ${response.body}')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: const Text(
                  'Not registered yet? Go to Register',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<dynamic> sensors = [];
  bool isLoading = false;

  Future<void> fetchSensors(Function fetchFunction, {bool isSingleSensor = false}) async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await fetchFunction();
      if (response.statusCode == 200) {
        setState(() {
          if (isSingleSensor) {
            sensors = [jsonDecode(response.body)];
          } else {
            sensors = jsonDecode(response.body);
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch sensors: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showInputDialog(String type) async {
    final TextEditingController inputController = TextEditingController();
    String? inputValue;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(type == 'minutes' ? 'Enter Minutes' : 'Enter Sensor ID'),
          content: TextField(
            controller: inputController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: type == 'minutes' ? 'e.g., 10' : 'e.g., 1',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                inputValue = inputController.text;
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (inputValue != null && inputValue!.isNotEmpty) {
      if (type == 'minutes') {
        await fetchSensors(() => ApiServices.getSensorByMinutes(int.parse(inputValue!)));
      } else if (type == 'id') {
        await fetchSensors(() => ApiServices.getSensorById(int.parse(inputValue!)), isSingleSensor: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Désactive la flèche de retour
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Réinitialise le token global
              bearerToken = null;

              // Redirige vers la page de connexion
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false, // Supprime toutes les routes précédentes
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            hint: const Text('Select an action'),
            items: [
              DropdownMenuItem(
                value: 'all',
                child: const Text('Get All Sensors'),
              ),
              DropdownMenuItem(
                value: 'minutes',
                child: const Text('Get Sensors by Minutes'),
              ),
              DropdownMenuItem(
                value: 'id',
                child: const Text('Get Sensor by ID'),
              ),
            ],
            onChanged: (value) async {
              if (value == 'all') {
                await fetchSensors(ApiServices.getAllSensor);
              } else if (value == 'minutes') {
                await _showInputDialog('minutes');
              } else if (value == 'id') {
                await _showInputDialog('id');
              }
            },
          ),
          isLoading
              ? const CircularProgressIndicator()
              : Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    padding: const EdgeInsets.all(10),
                    itemCount: sensors.length,
                    itemBuilder: (context, index) {
                      final sensor = sensors[index];
                      return AnimatedSensorCard(
                        id: sensor['id'],
                        temperature: sensor['temperature'],
                        room: sensor['room'] ?? "N/A",
                        onDelete: () async {
                          await ApiServices.deleteSensorById(sensor['id']);
                          setState(() {
                            sensors.removeAt(index);
                          });
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class AnimatedSensorCard extends StatefulWidget {
  final int id;
  final double temperature;
  final String room;
  final VoidCallback onDelete;

  const AnimatedSensorCard({
    super.key,
    required this.id,
    required this.temperature,
    required this.room,
    required this.onDelete,
  });

  @override
  State<AnimatedSensorCard> createState() => _AnimatedSensorCardState();
}

class _AnimatedSensorCardState extends State<AnimatedSensorCard> {
  double _rotationX = 0.0;
  double _rotationY = 0.0;
  bool _showAnimation = false;

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _rotationX += details.delta.dy * 0.01; // Ajuste la rotation sur l'axe X
      _rotationY -= details.delta.dx * 0.01; // Ajuste la rotation sur l'axe Y
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _rotationX = 0.0; // Réinitialise la rotation sur l'axe X
      _rotationY = 0.0; // Réinitialise la rotation sur l'axe Y
    });
  }

  void _onTap() {
    setState(() {
      _showAnimation = !_showAnimation; // Active ou désactive l'animation
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      onTap: _onTap,
      child: Stack(
        children: [
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateX(_rotationX)
              ..rotateY(_rotationY),
            alignment: FractionalOffset.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: AssetImage('assets/images/capteur.png'), // Image de fond
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
          ),
          if (_showAnimation)
            Positioned.fill(
              child: FallingIconsAnimation(
                icon: widget.temperature > 10 ? Icons.wb_sunny : Icons.ac_unit,
                color: widget.temperature > 10 ? Colors.orange : Colors.blue,
              ),
            ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sensor ID: ${widget.id}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Room: ${widget.room}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: _onTap,
                    child: Text(
                      'Temperature: ${widget.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: widget.onDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Remove'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FallingIconsAnimation extends StatefulWidget {
  final IconData icon;
  final Color color;

  const FallingIconsAnimation({
    super.key,
    required this.icon,
    required this.color,
  });

  @override
  State<FallingIconsAnimation> createState() => _FallingIconsAnimationState();
}

class _FallingIconsAnimationState extends State<FallingIconsAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _fallingAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Utilisez MediaQuery ici, car le contexte est maintenant disponible
    final screenHeight = MediaQuery.of(context).size.height;

    _fallingAnimations = List.generate(
      20,
      (index) => Tween<double>(begin: -50, end: screenHeight).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index * 0.05, 1.0, curve: Curves.linear),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        20,
        (index) => AnimatedBuilder(
          animation: _fallingAnimations[index],
          builder: (context, child) {
            return Positioned(
              top: _fallingAnimations[index].value,
              left: (index * 50) % MediaQuery.of(context).size.width,
              child: Icon(
                widget.icon,
                color: widget.color.withOpacity(0.7),
                size: 30,
              ),
            );
          },
        ),
      ),
    );
  }
}