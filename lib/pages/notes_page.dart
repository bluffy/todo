import 'dart:async';

import 'package:blutodo/data/notes_repository.dart';
import 'package:flutter/material.dart';
import '../components/note_dialog.dart';
import 'package:provider/provider.dart';
import 'package:keybinder/keybinder.dart';
import 'package:flutter/services.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  StreamController<NoteEvents> events =
      StreamController<NoteEvents>.broadcast(onListen: () {
    print(
        "################################################################listen");
  });

  @override
  void initState() {
    super.initState();

    final keybinding = Keybinding.from(
        {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyS});

    Keybinder.bind(keybinding, saveNote);
  }

  @override
  void dispose() {
    events.close();
    Keybinder.dispose();
    super.dispose();
  }

//final KeyBindSave = Keybinding({KeyCode.ctrl, KeyCode.from(KeyboardKey) });

  final KeyBindSave = KeyCode.fromSet(
      {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyS});

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

  void closeDialog(String? id) {
    setState(() {
      noteModel = NoteModel();
      selecedID = id.toString();
      isOpen = false;
    });
  }

  Color getColor(BuildContext context, String id) {
    //return setState(() {

    // setState(() {
    if (id == selecedID) {
      return Theme.of(context).highlightColor;
    }
    return Colors.transparent;

    //  });

    // });
  }

  void saveNote() {
    events.sink.add(NoteEvents.saveNote);
  }

  void onKeyToggled(Keybinding keybinding, bool pressed) {
    print('$keybinding was ${pressed ? 'pressed' : 'released'}');
  }

  // ItemScrollController _scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    NotesRepository notesRepository = context.read();
    final notes = notesRepository.searchNotes();

    List<NoteSearchResult> list;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
          actions: <Widget>[
            Visibility(
              visible: !isOpen,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: "Neue Notiz",
                  onPressed: () {
                    openDialog("new");
                  },
                ),
              ),
            ),
            Visibility(
              visible: isOpen,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: IconButton(
                  icon: const Icon(Icons.save),
                  tooltip: "speichern",
                  onPressed: () {
                    events.sink.add(NoteEvents.saveNote);
                  },
                ),
              ),
            )
          ],
        ),
        body: Container(
          color: (isOpen) ? Theme.of(context).unselectedWidgetColor : null,
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: isOpen && selecedID == 'new',
                  child: NoteDialog(
                    noteEvents: events.stream,
                    notesRepository: notesRepository,
                    onClose: (id) {
                      closeDialog(id);
                    },
                  )),
              FutureBuilder<List<NoteSearchResult>>(
                  future: notes,
                  builder: (context, future) {
                    if (!future.hasData) {
                      return const Text(
                          ''); // Display empty container if the list is empty
                    } else {
                      list = future.data!;
                      if (list.isNotEmpty) {
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
                                  onClose: (id) {
                                    closeDialog(id);
                                  },
                                );
                              } else {
                                return Row(children: [
                                  Checkbox(
                                    onChanged:
                                        !isOpen ? (bool? value) => {} : null,
                                    value: false,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      autofocus: (!isOpen &&
                                          list[index].id == selecedID),
                                      onTap: () {
                                        setState(() {
                                          if (!isOpen) {
                                            if (selecedID == list[index].id) {
                                              openDialog(list[index].id);
                                            }
                                            selecedID = list[index].id;
                                          } else {
                                            events.sink
                                                .add(NoteEvents.saveNote);
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(list[index].title +
                                            ': ' +
                                            list[index].sort.toString()),
                                      ),
                                    ),
                                  )
                                ]);
                              }
                            });
                      } else {
                        return const Text('');
                      }
                    }
                  }),
              /*
              Visibility(
                  visible: isOpen && selecedID == 'new',
                  child: NoteDialog(
                    noteEvents: events.stream,
                    notesRepository: notesRepository,
                    onClose: (id) {
                      closeDialog(id);
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
              ),
              */
            ],
          )),
        ));
  }
}
