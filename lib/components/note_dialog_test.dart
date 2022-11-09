import 'package:blutodo/data/notes_repository.dart';
import 'package:flutter/material.dart';

class InheritedDataProvider extends InheritedWidget {
  final Data data;
  InheritedDataProvider({
    Widget child,
    this.data,
  }) : super(child: child);
  @override
  bool updateShouldNotify(InheritedDataProvider oldWidget) =>
      data != oldWidget.data;
  static InheritedDataProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(InheritedDataProvider);
}

class NoteDialog extends StatelessWidget {
  NoteDialog({
    required this.onClose,
    required this.notesRepository,
    Key? key,
  }) : super(key: key);

  final VoidCallback onClose;

  final NotesRepository notesRepository;

  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();

  save() {
    final model = NoteModel(
        title: controllerTitle.text.trim(),
        description: controllerTitle.text.trim());

    if (model.title == "" && model.description == "") {
      onClose();
      return;
    }
    notesRepository.createNote(model: model);
    onClose();
  }

  @override
  Widget build(BuildContext context) {
    final data = InheritedDataProvider.of(context).data;

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
  }
}
