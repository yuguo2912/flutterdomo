import 'package:flutter/material.dart';

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