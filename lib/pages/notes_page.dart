import 'dart:async';

import 'package:blutodo/data/notes_repository.dart';
import 'package:flutter/material.dart';
import '../components/note_dialog.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  StreamController<NoteEvents> events =
      StreamController<NoteEvents>.broadcast();

  @override
  void dispose() {
    events.close();
    super.dispose();
  }

  //var _isInitialized = false;
  bool isOpen = false;
  var selecedID = "0";
  var test = "";

  var noteModel = NoteModel();

  void modelChanged(m) {
    setState(() {
      noteModel = m;
    });
  }

  void openDialog(String id) {
    setState(() {
      selecedID = id;
      isOpen = true;
    });
  }

  void closeDialog() {
    setState(() {
      noteModel = NoteModel();
      selecedID = "0";
      isOpen = false;
    });
  }

  Color getColor(id) {
    //return setState(() {

    // setState(() {
    if (id == selecedID) {
      return Colors.red;
    }
    return Colors.transparent;

    //  });

    // });
  }

  @override
  Widget build(BuildContext context) {
    NotesRepository notesRepository = context.read();
    final notes = notesRepository.searchNotes();

    return Scaffold(
        appBar: AppBar(title: const Text('Notes')),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(test),
                    FutureBuilder<List<NoteSearchResult>>(
                        future: notes,
                        builder: (context, future) {
                          if (!future.hasData) {
                            return const Text(
                                ''); // Display empty container if the list is empty
                          } else {
                            List<NoteSearchResult>? list = future.data;
                            if (list != null && list.isNotEmpty) {
                              return ListView.builder(
                                  primary: false,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    if (isOpen && selecedID == list[index].id) {
                                      return NoteDialog(
                                        noteEvents: events.stream,
                                        noteID: list[index].id,
                                        notesRepository: notesRepository,
                                        onClose: () {
                                          closeDialog();
                                        },
                                      );
                                    } else {
                                      return Row(children: [
                                        Checkbox(
                                          onChanged: !isOpen
                                              ? (bool? value) => {}
                                              : null,
                                          value: false,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (!isOpen) {
                                                    if (selecedID ==
                                                        list[index].id) {
                                                      openDialog(
                                                          list[index].id);
                                                    }
                                                    selecedID = list[index].id;
                                                  } else {
                                                    events.sink.add(
                                                        NoteEvents.saveNote);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                color: getColor(list[index].id),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child:
                                                      Text(list[index].title),
                                                ),
                                              )),
                                        )
                                      ]);
                                    }
                                  });
                            } else {
                              return const Text('');
                            }
                          }
                        }),
                    Visibility(
                        visible: isOpen && selecedID == 'new',
                        child: NoteDialog(
                          noteEvents: events.stream,
                          notesRepository: notesRepository,
                          onClose: () {
                            closeDialog();
                          },
                        )),
                    Visibility(
                      visible: !isOpen,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        onPressed: () => {openDialog("new")},
                        label: const Text('Neue Notiz'),
                      ),
                    ),
                    Visibility(
                      visible: isOpen,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        onPressed: () => {events.sink.add(NoteEvents.saveNote)},
                        label: const Text('Speichern'),
                      ),
                    )
                  ],
                ))));
  }
}
