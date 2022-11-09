import 'package:blutodo/data/notes_repository.dart';
import 'package:flutter/material.dart';
import '../utils/tools.dart';
import 'dart:async';

enum NoteEvents {
  saveNote,
}

class NoteDialog extends StatefulWidget {
  const NoteDialog({
    this.noteID,
    required this.noteEvents,
    this.onClose,
    this.notesRepository,
    Key? key,
  }) : super(key: key);

  final Stream<NoteEvents> noteEvents;
  final VoidCallback? onClose;
  final NotesRepository? notesRepository;
  final String? noteID;

  @override
  State<NoteDialog> createState() => _NoteDialog();
}

class _NoteDialog extends State<NoteDialog> {
  VoidCallback? onClose;
  NotesRepository? notesRepository;
  String? noteID;
  StreamSubscription<NoteEvents>? _subEvents;

  @override
  void initState() {
    super.initState();
    _subEvents = widget.noteEvents.asBroadcastStream().listen((event) {
      if (event == NoteEvents.saveNote) {
        saveNote();
      }
    });

    if (widget.noteID != null) {
      noteID = widget.noteID;
    }
    if (widget.notesRepository != null) {
      notesRepository = widget.notesRepository;
    }
    if (widget.onClose != null) {
      onClose = widget.onClose;
    }
  }

  @override
  void dispose() {
    _subEvents?.cancel();
    super.dispose();
  }

  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();

  Future<NoteModel> note() async {
    //print(" Future<NoteModel> note() async:" + noteID.toString());
    if (noteID != null) {
      return notesRepository!.getNote(noteID.toString());
    }
    return Future.delayed(
      const Duration(),
      () => NoteModel(),
    );
  }

  saveNote() {
    final noteModel = NoteModel();
    noteModel.title = controllerTitle.text.trim();
    noteModel.description = controllerDescription.text.trim();

    if (noteModel.title == "" && noteModel.description == "") {
      if (onClose != null) {
        onClose!();
      }

      return;
    }
    if (noteID == null) {
      notesRepository!.createNote(model: noteModel);
    } else {
      noteModel.id = noteID;
      notesRepository!.updateNote(model: noteModel);
    }
    if (onClose != null) {
      onClose!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NoteModel>(
        future: note(),
        builder: (BuildContext context, AsyncSnapshot<NoteModel> note) {
          if (note.hasData) {
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
                        onPressed: () => {saveNote()},
                        icon: const Icon(Icons.save),
                        label: const Text('Speichern'),
                      ))
                ],
              ),
            );
          } else {
            return const Text("loading");
          }
        });
  }
}
