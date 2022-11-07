import 'package:flutter/material.dart';

class NoteDialog extends StatelessWidget {
  NoteDialog({
    Key? key,
  }) : super(key: key);

  final titleText = TextEditingController();

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
            )
          ],
        ),
      );
}
