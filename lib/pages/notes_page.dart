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
  //var _isInitialized = false;
  bool isOpen = false;
  var selecedID = "0";

  void openDialog(String id) {
    setState(() {
      selecedID = id;
      isOpen = true;
    });
  }
  void closeDialog() {
    setState(() {
      selecedID = "new";
      isOpen = false;
    });
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
                                                      
                                    return Row(
                                      children: [
                                         Checkbox(
                                          onChanged:  !isOpen  ? (bool? value) => {
                                          }: null,
                                          value: false,
                                        ),

                                        Expanded(
                                          child: InkWell(
                                            onTap: () => {
                                              openDialog(list[index].id);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(list[index].title),
                                            )
                                          ),
                                        )
                                      ]
                                    );



                                  });
                            } else {
                              return const Text('');
                            }
                          }
                        }),
                    Visibility(
                        visible: isOpen && selecedID == 'new',
                        child: NoteDialog(
                          notesRepository: notesRepository,
                          onClose: () {
                            closeDialog();
                          },
                        )),
                    Visibility(
                      visible: !isOpen,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        onPressed: () => {
                          openDialog("new")
                          },
                        label: const Text('Neue Notiz'),
                      ),
                    )
                  ],
                ))));
  }
}
