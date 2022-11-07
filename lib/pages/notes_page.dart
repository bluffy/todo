import 'package:flutter/material.dart';
import '../components/note_dialog.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

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
    return Scaffold(
        appBar: AppBar(title: const Text('Notes')),
        body: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const NoteDialog(),
                Visibility(
                  visible: !isAdd,
                  child: ElevatedButton(
                    onPressed: () => {showAdd()},
                    child: new Text('Addßßß'),
                  ),
                )
              ],
            )));
  }
}
