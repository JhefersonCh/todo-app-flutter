import 'package:flutter/material.dart';
import '../models/task.dart';

class DetailScreen extends StatelessWidget {
  final Task task;

  const DetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Cambia el color del icono de retroceso
        ),
        title: const Text(
          'Detalles de la Tarea',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(241, 43, 114, 185),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                task.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              task.description.isNotEmpty
                  ? task.description
                  : 'No hay descripción',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: 'Estado: ', // Texto "Estado:"
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black, // Color del texto principal
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: task.isCompleted
                        ? 'Completada'
                        : 'Pendiente', // Texto "Completada" o "Pendiente"
                    style: TextStyle(
                      color: task.isCompleted
                          ? Colors.green
                          : Colors.red, // Verde o rojo según el estado
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
