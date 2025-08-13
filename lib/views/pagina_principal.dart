import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../widget/custom_note_tile.dart';
import '../widget/custom_note_dialog.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  String _filtro = 'todos';
  final Color _azulPrincipal = const Color.fromARGB(255, 14, 44, 128);
  final Color _azulClaro = const Color.fromARGB(255, 17, 91, 209);
  final Color _fondoNotas = const Color(0xFFEFF6FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _azulPrincipal,
      appBar: AppBar(
        title: const Text('ClearNote', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _azulPrincipal,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: _azulPrincipal,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('Todos', style: TextStyle(color: Colors.white)),
                        onTap: () {
                          setState(() => _filtro = 'todos');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Blogs', style: TextStyle(color: Colors.white)),
                        onTap: () {
                          setState(() => _filtro = 'blog');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Diarios', style: TextStyle(color: Colors.white)),
                        onTap: () {
                          setState(() => _filtro = 'diario');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: _fondoNotas,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirestoreService().leerNotas(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar notas'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            var docs = snapshot.data?.docs ?? [];
            if (_filtro != 'todos') {
              docs = docs.where((doc) => doc['tipo'] == _filtro).toList();
            }

            if (docs.isEmpty) {
              return const Center(child: Text('No hay notas aún'));
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 15),
              itemCount: docs.length,
              itemBuilder: (context, index) => CustomNoteTile(doc: docs[index]),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => CustomNoteDialog.show(context),
        backgroundColor: _azulClaro,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}