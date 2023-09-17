import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ControlPage(),
    );
  }
}

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  double joystickRadius = 50.0;
  double joystickX = 150.0;
  double joystickY = 210.0;

  double secondJoystickRadius = 50.0;
  double secondJoystickX = 650.0; // Ajusta la posición X del segundo joystick
  double secondJoystickY = 210.0; // Ajusta la posición Y del segundo joystick

  double outerCircleRadius = 100.0;
  double outerCircleX = 150.0;
  double outerCircleY = 210.0;

  double outerCircleRadius2 = 100.0;
  double outerCircleX2 =
      650.0; // Ajusta la posición X del círculo exterior del segundo joystick
  double outerCircleY2 =
      210.0; // Ajusta la posición Y del círculo exterior del segundo joystick

  String direction = '';
  String secondJoystickDirection = '';

  bool leftButtonPressed = false;
  bool rightButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Stack(
          children: [
            // Círculo exterior para el primer joystick
            Positioned(
              left: outerCircleX - outerCircleRadius,
              top: outerCircleY - outerCircleRadius,
              child: Container(
                width: outerCircleRadius * 2,
                height: outerCircleRadius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2.0),
                ),
              ),
            ),
            // Joystick interior
            Positioned(
              left: joystickX - joystickRadius,
              top: joystickY - joystickRadius,
              child: GestureDetector(
                onPanUpdate: (details) {
                  // Calcula las nuevas coordenadas del joystick
                  double newJoystickX = joystickX + details.delta.dx;
                  double newJoystickY = joystickY + details.delta.dy;

                  // Calcula las coordenadas relativas al círculo exterior
                  double relativeX = newJoystickX - outerCircleX;
                  double relativeY = newJoystickY - outerCircleY;

                  // Calcula la distancia desde el centro del círculo exterior
                  double distance = sqrt(pow(relativeX, 2) + pow(relativeY, 2));

                  // Calcula el ángulo del joystick
                  double angle = atan2(relativeY, relativeX);

                  // Verifica si el joystick se mantiene dentro del radio del círculo exterior
                  if (distance <= outerCircleRadius) {
                    setState(() {
                      joystickX = newJoystickX;
                      joystickY = newJoystickY;

                      // Detecta la dirección actual
                      direction = calculateDirection(joystickX, joystickY);
                    });
                  }
                },
                onPanEnd: (details) {
                  // Cuando se suelta el joystick, vuelve a la posición central del círculo exterior
                  setState(() {
                    joystickX = outerCircleX;
                    joystickY = outerCircleY;
                    direction = ''; // Limpia la dirección
                  });
                },
                child: Container(
                  width: joystickRadius * 2,
                  height: joystickRadius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue, // Color del joystick
                  ),
                ),
              ),
            ),
            // Círculo exterior para el segundo joystick
            Positioned(
              left: outerCircleX2 - outerCircleRadius2,
              top: outerCircleY2 - outerCircleRadius2,
              child: Container(
                width: outerCircleRadius2 * 2,
                height: outerCircleRadius2 * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 2.0),
                ),
              ),
            ),
            // Segundo joystick interior
            Positioned(
              left: secondJoystickX - secondJoystickRadius,
              top: secondJoystickY - secondJoystickRadius,
              child: GestureDetector(
                onPanUpdate: (details) {
                  // Calcula las nuevas coordenadas del segundo joystick
                  double newSecondJoystickX =
                      secondJoystickX + details.delta.dx;
                  double newSecondJoystickY =
                      secondJoystickY + details.delta.dy;

                  // Calcula las coordenadas relativas al círculo exterior del segundo joystick
                  double relativeX = newSecondJoystickX - outerCircleX2;
                  double relativeY = newSecondJoystickY - outerCircleY2;

                  // Calcula la distancia desde el centro del círculo exterior del segundo joystick
                  double distance = sqrt(pow(relativeX, 2) + pow(relativeY, 2));

                  // Calcula el ángulo del segundo joystick
                  double angle = atan2(relativeY, relativeX);

                  // Verifica si el segundo joystick se mantiene dentro del radio del círculo exterior
                  if (distance <= outerCircleRadius2) {
                    setState(() {
                      secondJoystickX = newSecondJoystickX;
                      secondJoystickY = newSecondJoystickY;

                      // Detecta la dirección actual del segundo joystick
                      secondJoystickDirection =
                          calculateDirection(secondJoystickX, secondJoystickY);
                    });
                  }
                },
                onPanEnd: (details) {
                  // Cuando se suelta el segundo joystick, vuelve a la posición central del círculo exterior del segundo joystick
                  setState(() {
                    secondJoystickX = outerCircleX2;
                    secondJoystickY = outerCircleY2;
                    secondJoystickDirection = ''; // Limpia la dirección
                  });
                },
                child: Container(
                  width: secondJoystickRadius * 2,
                  height: secondJoystickRadius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green, // Color del segundo joystick
                  ),
                ),
              ),
            ),
            // Zona de apuntado
            Positioned(
              left: 500.0,
              top: 20.0,
              child: GestureDetector(
                onPanUpdate: (details) {
                  print(
                      'Posición del dedo en X: ${details.localPosition.dx}, Y: ${details.localPosition.dy}');
                },
                child: Container(
                  width: 329.0,
                  height: 340.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2.0),
                  ),
                ),
              ),
            ),
            // Botones izquierda/derecha de la torreta
            Positioned(
              left: 280.0,
              bottom: 40.0,
              child: GestureDetector(
                onTapDown: (details) {
                  print('Mover torreta hacia la izquierda');
                  leftButtonPressed = true;
                  rightButtonPressed = false;
                },
                onTapUp: (details) {
                  print('Detener movimiento de la torreta');
                  leftButtonPressed = false;
                },
                child: Container(
                  width: 100.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: leftButtonPressed ? Colors.green : Colors.yellow,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(Icons.arrow_left, size: 36.0),
                ),
              ),
            ),
            Positioned(
              right: 280.0,
              bottom: 40.0,
              child: GestureDetector(
                onTapDown: (details) {
                  print('Mover torreta hacia la derecha');
                  rightButtonPressed = true;
                  leftButtonPressed = false;
                },
                onTapUp: (details) {
                  print('Detener movimiento de la torreta');
                  rightButtonPressed = false;
                },
                child: Container(
                  width: 100.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: rightButtonPressed ? Colors.green : Colors.yellow,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(Icons.arrow_right, size: 36.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String calculateDirection(double x, double y) {
    double centerX = joystickX;
    double centerY = joystickY;
    double deltaX = x - centerX;
    double deltaY = y - centerY;

    double angle = atan2(deltaY, deltaX);

    if (angle >= -pi / 4 && angle < pi / 4) {
      return 'derecha';
    } else if (angle >= pi / 4 && angle < 3 * pi / 4) {
      return 'arriba';
    } else if ((angle >= 3 * pi / 4 && angle <= pi) ||
        (angle >= -pi && angle < -3 * pi / 4)) {
      return 'izquierda';
    } else {
      return 'abajo';
    }
  }
}
