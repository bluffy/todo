import 'package:blutodo/data/notes_repository.dart';
import 'package:flutter/material.dart';

class NoteDialog extends StatelessWidget {
  NoteDialog({
    required this.onClose,
    required this.notesRepository,
    Key? key,
  }) : super(key: key);

  final VoidCallback onClose;

  final NotesRepository notesRepository;

  final titleText = TextEditingController();
  final descripionText = TextEditingController();
  save() {
    final model = NoteModel(title: titleText.text);
    notesRepository.createNote(model: model);
    onClose();
  }

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
                  controller: titleText,
                  decoration: const InputDecoration(
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
