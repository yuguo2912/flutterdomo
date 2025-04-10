import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_domotic/pages/login_page.dart';
import 'package:flutter_domotic/services/api_services.dart';
import 'package:flutter_domotic/widget/animated_sensor_card.dart';

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