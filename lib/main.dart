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
  double joystickRadius = 50.0; // Radio del joystick interior
  double joystickX = 150.0; // Ajusta la posición X del joystick interior
  double joystickY = 150.0; // Ajusta la posición Y del joystick interior

  double outerCircleRadius = 100.0; // Radio del círculo exterior
  double outerCircleX = 150.0; // Ajusta la posición X del círculo exterior
  double outerCircleY = 150.0; // Ajusta la posición Y del círculo exterior

  String direction = ''; // Variable para mantener la dirección actual

  bool leftButtonPressed = false; // Indica si el botón izquierdo está presionado
  bool rightButtonPressed = false; // Indica si el botón derecho está presionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control del Juego'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.grey[800], // Cambia el fondo a gris oscuro
      body: Center(
        child: Stack(
          children: [
            // Círculo exterior
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
                      if (angle >= -pi / 4 && angle < pi / 4) {
                        direction = 'derecha';
                      } else if (angle >= pi / 4 && angle < 3 * pi / 4) {
                        direction = 'arriba';
                      } else if ((angle >= 3 * pi / 4 && angle <= pi) || (angle >= -pi && angle < -3 * pi / 4)) {
                        direction = 'izquierda';
                      } else {
                        direction = 'abajo';
                      }

                      // Envía señales a la consola mientras el joystick se mueve
                      print('Joystick en posición X: $joystickX, Y: $joystickY');
                      print('Dirección actual: $direction');
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
            // Botón de disparo con efecto de "ripple"
            Positioned(
              right: 20.0, // Ajusta la posición X del botón de disparo
              bottom: 60.0, // Ajusta la posición Y del botón de disparo
              child: InkWell(
                onTap: () {
                  // Agrega aquí la lógica de disparo
                  print('¡Disparo en dirección: $direction!');
                },
                borderRadius: BorderRadius.circular(50.0), // Ajusta el radio de borde del "ripple"
                child: Container(
                  width: 160.0, // Ajusta el tamaño del botón de disparo
                  height: 160.0, // Ajusta el tamaño del botón de disparo
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red, // Color del botón de disparo
                  ),
                  child: Center(
                    child: Text(
                      'Disparar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0, // Ajusta el tamaño del texto
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Botones izquierda/derecha de la torreta
            Positioned(
              left: 280.0, // Ajusta la posición X del botón izquierdo
              bottom: 40.0, // Ajusta la posición Y del botón izquierdo
              child: GestureDetector(
                onTapDown: (details) {
                  // Detecta la posición del toque y mueve la torreta hacia la izquierda
                  print('Mover torreta hacia la izquierda');
                  // Inicia señales constantes
                  leftButtonPressed = true;
                  rightButtonPressed = false;
                },
                onTapUp: (details) {
                  // Cuando se levanta el dedo, detén el movimiento de la torreta
                  print('Detener movimiento de la torreta');
                  // Detiene las señales constantes
                  leftButtonPressed = false;
                },
                child: Container(
                  width: 100.0, // Ajusta el ancho del botón izquierdo
                  height: 60.0, // Ajusta la altura del botón izquierdo
                  decoration: BoxDecoration(
                    color: leftButtonPressed ? Colors.green : Colors.yellow, // Color del botón izquierdo
                    borderRadius: BorderRadius.circular(10.0), // Hace que el botón sea redondeado
                  ),
                  child: Icon(Icons.arrow_left, size: 36.0), // Símbolo de izquierda
                ),
              ),
            ),
            Positioned(
              right: 280.0, // Ajusta la posición X del botón derecho
              bottom: 40.0, // Ajusta la posición Y del botón derecho
              child: GestureDetector(
                onTapDown: (details) {
                  // Detecta la posición del toque y mueve la torreta hacia la derecha
                  print('Mover torreta hacia la derecha');
                  // Inicia señales constantes
                  rightButtonPressed = true;
                  leftButtonPressed = false;
                },
                onTapUp: (details) {
                  // Cuando se levanta el dedo, detén el movimiento de la torreta
                  print('Detener movimiento de la torreta');
                  // Detiene las señales constantes
                  rightButtonPressed = false;
                },
                child: Container(
                  width: 100.0, // Ajusta el ancho del botón derecho
                  height: 60.0, // Ajusta la altura del botón derecho
                  decoration: BoxDecoration(
                    color: rightButtonPressed ? Colors.green : Colors.yellow, // Color del botón derecho
                    borderRadius: BorderRadius.circular(10.0), // Hace que el botón sea redondeado
                  ),
                  child: Icon(Icons.arrow_right, size: 36.0), // Símbolo de derecha
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
