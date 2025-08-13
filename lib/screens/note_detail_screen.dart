import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteDetailScreen extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> doc;
  final Color _azulPrincipal = const Color.fromARGB(255, 13, 37, 102);
  final Color _fondoNotas = const Color(0xFFEFF6FF);

  const NoteDetailScreen({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final data = doc.data()!;
    final contenido = data['contenido'] ?? '';
    final tipo = data['tipo'] ?? 'Sin tipo';
    final imagenUrl = data['imagenUrl'];
    final fecha = DateTime.tryParse(data['fecha'] ?? '');

    return Scaffold(
      backgroundColor: _azulPrincipal,
      appBar: AppBar(
        title: Text('Nota de ${tipo.toUpperCase()}', 
          style: const TextStyle(color: Colors.white)),
        backgroundColor: _azulPrincipal,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _fondoNotas,
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imagenUrl != null && tipo == 'blog')
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imagenUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                contenido,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(fecha ?? DateTime.now()),
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}