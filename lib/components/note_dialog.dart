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
  save() {
    notesRepository.createNote(title: titleText.text);
    onClose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleText,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () => {save()},
              child: new Text('Speichern'),
            )
          ],
        ),
      );
}
