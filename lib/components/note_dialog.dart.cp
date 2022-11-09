import 'package:blutodo/data/notes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class NoteDialog extends StatefulWidget {
  method() => createState().methodInPage2();
  method2(value) => createState().method2(value);

  @override
  _NoteDialog createState() => _NoteDialog();
}

class _NoteDialog extends State<NoteDialog> {
  methodInPage2() => print("method in page 2");
  method2(value) => print("method in page 2${value}");

  final noteModel = NoteModel();

  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();

  @override
  Widget build(BuildContext context) => Padding(
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
                  onPressed: () => {},
                  icon: const Icon(Icons.save),
                  label: const Text('Speichern'),
                ))
          ],
        ),
      );
}
