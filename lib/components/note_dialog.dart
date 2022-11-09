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

  Future<NoteModel> holen() async {
    if (noteID != null) {
      return notesRepository.getNote(noteID.toString());
    }
    return Future.delayed(
      const Duration(),
      () => NoteModel(),
    );
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
  Widget build(BuildContext context) {
    /*
        if (noteID != null) {
    
            final test =  notesRepository.getNote(noteID.toString());
     
        }
*/

    final data = notesRepository.getNote(noteID.toString());

    return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
    });
  }
}
