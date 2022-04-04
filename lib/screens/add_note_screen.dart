import 'package:flutter/material.dart';
import 'package:practica2/database/database_notas.dart';
import 'package:practica2/models/notes_model.dart';

class AddNoteScreen extends StatefulWidget {
  NotesDAO? objNote;
  AddNoteScreen({Key? key, this.objNote}) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  var txtTitleController = TextEditingController();
  var txtDescController = TextEditingController();
  late DatabaseNotes dbNotes;

  @override
  void initState() {
    super.initState();

    if (widget.objNote != null) {
      txtTitleController.text = widget.objNote!.titulo!;
      txtDescController.text = widget.objNote!.dscNota!;
    }

    dbNotes = DatabaseNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.objNote == null ? Text('Add Note') : Text('Edit Note'),
      ),
      body: ListView(children: [
        _createTextFieldTitle(),
        SizedBox(height: 5),
        _createTextFieldDesc(),
        SizedBox(height: 5),
        _createButtonSave()
      ]),
    );
  }

  Widget _createTextFieldTitle() {
    return TextField(
        keyboardType: TextInputType.text,
        controller: txtTitleController,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
  }

  Widget _createTextFieldDesc() {
    return TextField(
        keyboardType: TextInputType.text,
        controller: txtDescController,
        maxLines: 8,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
  }

  Widget _createButtonSave() {
    return ElevatedButton(
      child: Text('Save Note'),
      onPressed: () {
        if (widget.objNote == null) {
          NotesDAO objNote = NotesDAO(
              titulo: txtTitleController.text, dscNota: txtDescController.text);
          dbNotes.insertar(objNote.toMap()).then((value) {
            if (value > 0) {
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error in your request :(')));
            }
          });
        } else {
          widget.objNote!.titulo = txtTitleController.text;
          widget.objNote!.dscNota = txtDescController.text;
          dbNotes.update(widget.objNote!.toMap()).then((value) {
            if (value > 0) {
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error in your request :(')));
            }
          });
        }
      },
    );
  }
}
