import 'package:flutter/material.dart';
import 'package:practica2/database/database_notas.dart';
import 'package:practica2/models/notes_model.dart';
import 'package:practica2/screens/add_note_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late DatabaseNotes dbNotes;

  @override
  void initState() {
    super.initState();
    dbNotes = DatabaseNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Notes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add').whenComplete(() {
                  setState(() {});
                });
              },
              icon: Icon(Icons.note_add))
        ],
      ),
      body: FutureBuilder(
          future: dbNotes.getAllNotes(),
          builder:
              (BuildContext context, AsyncSnapshot<List<NotesDAO>> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Ocurrio un error al ejecutar :('));
            } else {
              if (snapshot.connectionState == ConnectionState.done) {
                return _listNotes(snapshot.data!);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          }),
    );
  }

  Widget _listNotes(List<NotesDAO> notes) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(notes[index].titulo!),
          subtitle: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddNoteScreen(objNote: notes[index])))
                      .whenComplete(() {
                    setState(() {});
                  });
                },
                icon: Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Mensaje de la APP'),
                          content: Text('¿Estas seguro de borrar la nota?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  dbNotes
                                      .delete(notes[index].idNota!)
                                      .then((value) {
                                    if (value == 1) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'La nota se eliminó correctamente')));
                                      setState(() {});
                                    }
                                  });
                                },
                                child: Text('Si')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('No'))
                          ],
                        );
                      });
                },
                icon: Icon(Icons.delete))
          ]),
        );
      },
      itemCount: notes.length,
    );
  }
}
