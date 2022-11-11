import 'dart:ffi';

import 'package:blutodo/data/notes_repository.dart';
import 'package:flutter/material.dart';
import '../utils/tools.dart';
import 'dart:async';

enum NoteEvents {
  saveNote,
}

class NoteDialog extends StatefulWidget {
  const NoteDialog({
    required this.notesRepository,
    this.noteID,
    required this.noteEvents,
    this.onClose,
    this.selectedSort,
    this.selectedID,
    Key? key,
  }) : super(key: key);

  final Stream<NoteEvents> noteEvents;
  final Function(String?)? onClose;
  final NotesRepository notesRepository;
  final String? noteID;
  final String? selectedSort;
  final String? selectedID;
  @override
  State<NoteDialog> createState() => _NoteDialog();
}

class _NoteDialog extends State<NoteDialog> {
  Function(String?)? onClose;
  NotesRepository? notesRepository;
  String? noteID;
  StreamSubscription<NoteEvents>? _subEvents;
  NoteModel? note;
  String? selectedSort;
  String? selectedID;

  @override
  void initState() {
    super.initState();
    _subEvents = widget.noteEvents.asBroadcastStream().listen((event) {
      if (event == NoteEvents.saveNote) {
        saveNote();
      }
    });

    noteID = widget.noteID;
    selectedSort = widget.selectedSort;
    selectedID = widget.selectedID;
    notesRepository = widget.notesRepository;
    onClose = widget.onClose;
  }

  @override
  void dispose() {
    _subEvents?.cancel();
    super.dispose();
  }

  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();

  Future<NoteModel> getNote() async {
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
    if (note != null) {
      if (selectedSort != null && selectedSort != "") {
        note!.sort = int.parse(selectedSort.toString()) - 1000;
      }
      note!.title = controllerTitle.text.trim();
      note!.description = controllerDescription.text.trim();

      if (note!.title == "" && note!.description == "") {
        if (onClose != null) {
          onClose!("");
        }

        return;
      }
      if (noteID == null) {
        notesRepository!.createNote(model: note!);
      } else {
        note!.id = noteID;
        notesRepository!.updateNote(model: note!);
      }
      if (onClose != null) {
        onClose!(note!.id);
      }
    }
  }

  fillForm() {
    if (note != null) {
      controllerTitle.text = Tools.nvlString(note!.title);
      controllerDescription.text = Tools.nvlString(note!.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: FutureBuilder<NoteModel>(
          future: getNote(),
          builder: (BuildContext context, AsyncSnapshot<NoteModel> futureNote) {
            if (futureNote.hasData) {
              note = futureNote.data;

              if (noteID != null) {
                fillForm();
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
                          autofocus: true,
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
                          label: const Text(''),
                        )),
                  ],
                ),
              );
            } else {
              return const Text("loading");
            }
          }),
    );
  }
}
