import 'package:blutodo/data/notes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../utils/tools.dart';

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

  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();

  Future<NoteModel> note() async {
    print(" Future<NoteModel> note() async:" + noteID.toString());
    if (noteID != null) {
      return notesRepository.getNote(noteID.toString());
    }
    return Future.delayed(
      const Duration(),
      () => NoteModel(),
    );
  }

  save(noteModel) {
    noteModel.title = controllerTitle.text.trim();
    noteModel.description = controllerDescription.text.trim();

    if (noteModel.title == "" && noteModel.description == "") {
      onClose();
      return;
    }
    if (noteID == null) {
      notesRepository.createNote(model: noteModel);
    } else {
      notesRepository.updateNote(model: noteModel);
    }
    onClose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NoteModel>(
        future: note(),
        builder: (BuildContext context, AsyncSnapshot<NoteModel> note) {
          if (note.hasData) {
            print("titel: " + note.data!.title.toString());

            if (noteID != null) {
              controllerTitle.text = Tools.nvlString(note.data!.title);
              controllerDescription.text =
                  Tools.nvlString(note.data!.description);
            }
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
                        onPressed: () => {save(note.data!)},
                        icon: const Icon(Icons.save),
                        label: const Text('Speichern'),
                      ))
                ],
              ),
            );
          } else {
            return Text("loading");
          }
        });
  }
}
