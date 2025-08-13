import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class CustomNoteDialog {
  static void show(
    BuildContext context, {
    String? id,
    String? contenidoInit,
    String tipoInit = 'blog',
    String? imagenUrlInit,
  }) {
    final contenidoCtrl = TextEditingController(text: contenidoInit ?? '');
    final imagenUrlCtrl = TextEditingController(text: imagenUrlInit ?? '');
    String tipoSeleccionado = tipoInit;
    final Color _fondoNotas = const Color(0xFFEFF6FF);

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: _fondoNotas,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      id == null ? 'NUEVA NOTA' : 'EDITAR NOTA',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: tipoSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Nota',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'blog', child: Text('Blog')),
                        DropdownMenuItem(value: 'diario', child: Text('Diario')),
                      ],
                      onChanged: (value) => setState(() => tipoSeleccionado = value ?? 'blog'),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: contenidoCtrl,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Contenido',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    if (tipoSeleccionado == 'blog') ...[
                      const SizedBox(height: 15),
                      TextField(
                        controller: imagenUrlCtrl,
                        decoration: const InputDecoration(
                          labelText: 'URL de imagen (opcional)',
                          hintText: 'https://ejemplo.com/imagen.jpg',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            final contenido = contenidoCtrl.text.trim();
                            if (contenido.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Escribe algo')),
                              );
                              return;
                            }

                            final imagenUrl = imagenUrlCtrl.text.trim();
                            if (imagenUrl.isNotEmpty && !imagenUrl.startsWith('http')) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('La URL debe comenzar con http')),
                              );
                              return;
                            }

                            if (id == null) {
                              await FirestoreService().agregarNota(
                                tipoSeleccionado,
                                contenido,
                                DateTime.now(),
                                imagenUrl: imagenUrl.isNotEmpty ? imagenUrl : null,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Nota guardada')),
                              );
                            } else {
                              await FirestoreService().actualizarNota(
                                id,
                                contenido,
                                tipoSeleccionado,
                                imagenUrl: imagenUrl.isNotEmpty ? imagenUrl : null,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Nota actualizada')),
                              );
                            }

                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                          ),
                          child: Text(
                            id == null ? 'Guardar' : 'Actualizar',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}