import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import 'custom_note_dialog.dart';
import '../screens/note_detail_screen.dart';

class CustomNoteTile extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> doc;
  final Color _azulPrincipal = const Color(0xFF1E3A8A);
  final Color _fondoNotas = const Color(0xFFEFF6FF);

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
    final imagenUrl = data['imagenUrl'];

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NoteDetailScreen(doc: doc),
        ),
      ),
      child: Card(
        color: _fondoNotas,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: Column(
          children: [
            if (imagenUrl != null && tipo == 'blog')
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imagenUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                ),
              ),
            ListTile(
              title: Text(
                tipo.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _azulPrincipal,
                ),
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
                        imagenUrlInit: imagenUrl,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _mostrarDialogoConfirmacion(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoConfirmacion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de eliminar esta nota?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop(); // Cierra el diálogo primero
                try {
                  await FirestoreService().eliminarNota(doc.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nota eliminada')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}