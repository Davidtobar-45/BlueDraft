import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import 'custom_note_dialog.dart';

class CustomNoteTile extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> doc;

  const CustomNoteTile({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final data = doc.data()!;
    final contenido = data['contenido'] ?? '';
    final tipo = data['tipo'] ?? 'Sin tipo';
    final fechaStr = data['fecha'];
    final fecha = DateTime.tryParse(fechaStr ?? '');
    final fechaFormateada = fecha != null
        ? DateFormat('dd/MM/yyyy – HH:mm').format(fecha)
        : 'Fecha desconocida';

    return Card(
      child: ListTile(
        title: Text(
          tipo.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(contenido),
            const SizedBox(height: 5),
            Text(
              fechaFormateada,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.green),
              onPressed: () {
                CustomNoteDialog.show(
                  context,
                  id: doc.id,
                  contenidoInit: contenido,
                  tipoInit: tipo,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await FirestoreService().eliminarNota(doc.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nota eliminada')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
