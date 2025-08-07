import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class CustomNoteDialog {
  static void show(
    BuildContext context, {
    String? id,
    String? contenidoInit,
    String tipoInit = 'blog',
  }) {
    final TextEditingController contenidoCtrl =
        TextEditingController(text: contenidoInit ?? '');
    String tipoSeleccionado = tipoInit;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(id == null ? 'Nueva Nota' : 'Editar Nota'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: tipoSeleccionado,
              decoration: const InputDecoration(labelText: 'Tipo de Nota'),
              items: const [
                DropdownMenuItem(value: 'blog', child: Text('Blog')),
                DropdownMenuItem(value: 'diario', child: Text('Diario')),
              ],
              onChanged: (value) => tipoSeleccionado = value ?? 'blog',
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contenidoCtrl,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Contenido'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final contenido = contenidoCtrl.text.trim();
              if (contenido.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Escribe algo')),
                );
                return;
              }

              if (id == null) {
                await FirestoreService().agregarNota(
                  tipoSeleccionado,
                  contenido,
                  DateTime.now(),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nota guardada')),
                );
              } else {
                await FirestoreService().actualizarNota(
                  id,
                  contenido,
                  tipoSeleccionado,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nota actualizada')),
                );
              }

              Navigator.pop(context);
            },
            child: Text(id == null ? 'Guardar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }
}
