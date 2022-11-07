import 'dart:async';

import 'package:blutodo/data/notes_repository.dart';
import 'package:flutter/material.dart';
import '../components/note_dialog.dart';
import 'package:provider/provider.dart';
import '../blocs/bloc_helper.dart';
import '../blocs/notes_bloc.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

/*
  static Widget withProviders({required String id}) => ChangeNotifierProvider(
        /*
        create: (context) => NotesBloc(
          id: id,
          notesRepository: context.read(),
        ),*/
        create: (context) => {
          notesRepository: context.read()
        },
        child: const NotesPage(),
        
      );
*/

/*
  static Widget withProviders({required String id}) => ChangeNotifierProvider(
        create: (context) => CounterBloc(
          id: id,
          counterRepository: context.read(),
        ),
        child: const CounterPage(),
      );
      */

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  var _isInitialized = false;
  bool isAdd = false;

  void showAdd() {
    setState(() {
      isAdd = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    NotesRepository notesRepository = context.read();

    final notes = notesRepository.searchNotes();

    return Scaffold(
        appBar: AppBar(title: const Text('Notes')),
        body: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                FutureBuilder<List<NoteSearchResult>>(
                    future: notes,
                    builder: (context, future) {
                      if (!future.hasData)
                        return Container(
                          child: Text('X'),
                        ); // Display empty container if the list is empty
                      else {
                        List<NoteSearchResult>? list = future.data;
                        if (list != null && list.length > 0) {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    child: Text(list[index].title +
                                        ' ' +
                                        list[index].id));
                              });
                        } else {
                          return Container(child: Text('X'));
                        }
                      }
                    }),
                /*
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notes.length,
                    itemBuilder: (ctx, index) {
                      final note = notes[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        child: Text(note.title),
                      );
                    }),
                    */
                Visibility(
                    visible: isAdd,
                    child: NoteDialog(
                      notesRepository: notesRepository,
                      onClose: () {
                        setState(() {
                          isAdd = false;
                        });
                      },
                    )),
                Visibility(
                  visible: !isAdd,
                  child: ElevatedButton(
                    onPressed: () => {showAdd()},
                    child: const Text('Add'),
                  ),
                )
              ],
            )));
  }
}
