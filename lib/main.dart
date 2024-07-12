import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'models/tarea.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tareas CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TareaListScreen(),
    );
  }
}

class TareaListScreen extends StatefulWidget {
  @override
  _TareaListScreenState createState() => _TareaListScreenState();
}

class _TareaListScreenState extends State<TareaListScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Tarea> _tareas = [];

  @override
  void initState() {
    super.initState();
    _loadTareas();
  }

  Future<void> _loadTareas() async {
    final tareas = await _databaseHelper.getTareas();
    setState(() {
      _tareas = tareas;
      print('Loaded tasks: $_tareas');
    });
  }

  Future<void> _addTarea(String nombre) async {
    final tarea = Tarea(nombre: nombre);
    await _databaseHelper.insertTarea(tarea);
    print('Inserted task: $tarea');
    _loadTareas();
  }

  Future<void> _updateTarea(Tarea tarea) async {
    await _databaseHelper.updateTarea(tarea);
    print('Updated task: $tarea');
    _loadTareas();
  }

  Future<void> _deleteTarea(int id) async {
    await _databaseHelper.deleteTarea(id);
    print('Deleted task with id: $id');
    _loadTareas();
  }

  void _showAddTareaDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String nombre = '';
        return AlertDialog(
          title: Text('Nueva Tarea'),
          content: TextField(
            onChanged: (value) {
              nombre = value;
            },
            decoration: InputDecoration(hintText: 'Nombre de la tarea'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (nombre.isNotEmpty) {
                  _addTarea(nombre);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTareaDialog(Tarea tarea) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String nombre = tarea.nombre;
        return AlertDialog(
          title: Text('Editar Tarea'),
          content: TextField(
            onChanged: (value) {
              nombre = value;
            },
            controller: TextEditingController(text: tarea.nombre),
            decoration: InputDecoration(hintText: 'Nombre de la tarea'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (nombre.isNotEmpty) {
                  _updateTarea(Tarea(id: tarea.id, nombre: nombre));
                  Navigator.of(context).pop();
                }
              },
              child: Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tareas'),
      ),
      body: ListView.builder(
        itemCount: _tareas.length,
        itemBuilder: (context, index) {
          final tarea = _tareas[index];
          return ListTile(
            title: Text(tarea.nombre),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditTareaDialog(tarea);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteTarea(tarea.id!);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showAddTareaDialog,
      ),
    );
  }
}
