import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../widget/custom_note_tile.dart';
import '../widget/custom_note_dialog.dart';

class PaginaPrincipal extends StatelessWidget {
  const PaginaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido al FYP de BlueDraft'),
        backgroundColor: const Color.fromARGB(255, 51, 131, 250),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirestoreService().leerNotas(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar notas'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('No hay notas aún'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return CustomNoteTile(doc: docs[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => CustomNoteDialog.show(context),
        backgroundColor: const Color.fromARGB(255, 15, 196, 216),
        child: const Icon(Icons.add),
      ),
    );
  }
}
