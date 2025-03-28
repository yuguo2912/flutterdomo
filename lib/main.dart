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
      debugShowCheckedModeBanner: false, // Supprime la banderole "debug"
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
        child: SingleChildScrollView( // Permet le défilement si l'écran est petit
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
              Center(
                child: SizedBox(
                  width: 300, // Définit une largeur fixe pour centrer le champ
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 300, // Définit une largeur fixe pour centrer le champ
                  child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              Center(
                  child: SizedBox(
                    width: 300, // Définit une largeur fixe pour centrer le champ
                  child:TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
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
              Center( 
                child: SizedBox(
                width: 300, // Définit une largeur fixe pour centrer le champ
                child: TextField(
                  controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 300, // Définit une largeur fixe pour centrer le champ
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedValue;
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

    if (inputValue != null) {
      if (type == 'minutes') {
        await fetchSensors(() => ApiServices.getSensorByMinutes(int.parse(inputValue!)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Change la couleur de la barre de navigation
        elevation: 0,
        titleSpacing: 0,
        leading: isLargeScreen
            ? null
            : IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Dashboard",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Assurez-vous que le texte reste lisible
                  letterSpacing: 1.5,
                ),
              ),
              if (isLargeScreen) Expanded(child: _navBarItems())
            ],
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: _ProfileIcon()),
          )
        ],
      ),
      drawer: isLargeScreen ? null : _drawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 2,
                  crossAxisSpacing: 40,
                  mainAxisSpacing: 40,
                ),
                itemCount: sensors.length,
                itemBuilder: (context, index) {
                  final sensor = sensors[index];
                  return Center(
                    child: AnimatedSensorCard(
                      id: sensor['id'],
                      timeStamp: sensor['timeStamp'],
                      onDelete: () async {
                        await ApiServices.deleteSensorById(sensor['id']);
                        setState(() {
                          sensors.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _drawer() => Drawer(
        child: ListView(
          children: _menuItems
              .map((item) => ListTile(
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    title: Text(item),
                  ))
              .toList(),
        ),
      );

  Widget _navBarItems() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _menuItems
            .map(
              (item) => InkWell(
                onTap: () async {
                  if (_menuItems.indexOf(item) == 0) {
                    // All Sensors
                    await fetchSensors(ApiServices.getAllSensor);
                  } else if (_menuItems.indexOf(item) == 1) {
                    // Recent Sensors
                    await _showInputDialog('minutes'); // Demande à l'utilisateur d'entrer un nombre de minutes
                  } else if (_menuItems.indexOf(item) == 2) {
                    // Home (ou autre action)
                    // Naviguer vers une autre page ou effectuer une autre action
                  } else if (_menuItems.indexOf(item) == 3) {
                    // Logout
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white, // Change la couleur du texte en noir
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      );
}

final List<String> _menuItems = <String>[
  'All Sensors',
  'Recent Sensors',
  'Home',
  'Logout',
];

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.person),
        offset: const Offset(0, 40),
        onSelected: (Menu item) {},
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
              const PopupMenuItem<Menu>(
                value: Menu.itemOne,
                child: Text('Account'),
              ),
              const PopupMenuItem<Menu>(
                value: Menu.itemTwo,
                child: Text('Settings'),
              ),
              const PopupMenuItem<Menu>(
                value: Menu.itemThree,
                child: Text('Sign Out'),
              ),
            ]);
  }
}

enum Menu { itemOne, itemTwo, itemThree }

class AnimatedSensorCard extends StatefulWidget {
  final int id;
  final String? timeStamp; // Changez en String? pour accepter les valeurs nulles
  final VoidCallback onDelete;

  const AnimatedSensorCard({
    super.key,
    required this.id,
    required this.timeStamp,
    required this.onDelete,
  });

  @override
  State<AnimatedSensorCard> createState() => _AnimatedSensorCardState();
}

class _AnimatedSensorCardState extends State<AnimatedSensorCard> {
  double _rotationX = 0.0;
  double _rotationY = 0.0;

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _rotationX += details.delta.dy * 0.01;
      _rotationY -= details.delta.dx * 0.01;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _rotationX = 0.0;
      _rotationY = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Vérifiez si timeStamp est null
    String timeAgoText;
    if (widget.timeStamp != null) {
      DateTime timestamp = DateTime.parse(widget.timeStamp!);
      int minutesAgo = DateTime.now().difference(timestamp).inMinutes;
      timeAgoText = 'Taken $minutesAgo minutes ago';
    } else {
      timeAgoText = 'Timestamp unavailable';
    }

    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Stack(
        children: [
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(_rotationX)
              ..rotateY(_rotationY),
            alignment: FractionalOffset.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: AssetImage('assets/images/capteur.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
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
                    ),
                  ),
                  Text(
                    timeAgoText, // Affiche le texte basé sur timeStamp
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: widget.onDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, // Couleur de fond blanche
                      foregroundColor: Colors.white, // Couleur du texte noire
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