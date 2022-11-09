import 'package:blutodo/data/notes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class NoteDialog extends StatelessWidget {
  NoteDialog({
    this.noteID,
    required this.onClose,
    required this.notesRepository,
    Key? key,
  }) : super(key: key);

  final VoidCallback onClose;
  final NotesRepository notesRepository;
  final String? noteID;

  NoteModel noteModel;

  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();

  holen(){
      notesRepository.getNote(noteID.toString());
  }

  save() {
    noteModel.title = controllerTitle.text.trim();
    noteModel.description = controllerDescription.text.trim();

    if (noteModel.title == "" && noteModel.description == "") {
      onClose();
      return;
    }
    notesRepository.createNote(model: noteModel);
    onClose();
  }

  @override
  Future<Widget> build(BuildContext context) async   {
    /*
        if (noteID != null) {
    
            final test =  notesRepository.getNote(noteID.toString());
     
        }
*/

    final test = awaeit notesRepository.getNote(noteID.toString());


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: controllerTitle,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "Aufgabe",
                ),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                minLines: 2,
                maxLines: 100,
                controller: controllerDescription,
                decoration: const InputDecoration(
                  hintText: "Beschreibung",
                  border: UnderlineInputBorder(),
                ),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton.icon(
                onPressed: () => {save()},
                icon: const Icon(Icons.save),
                label: const Text('Speichern'),
              ))
        ],
      ),
    );
  }
}
