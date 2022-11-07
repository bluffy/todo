import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const NotePage());
  }
}

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
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
          child: Row(
            children: [
              Visibility(
                visible: !isAdd,
                child: ElevatedButton(
                  onPressed: () => {showAdd()},
                  child: new Text('Click me ${isAdd}'),
                ),
              )
            ],
          ),
        ));
  }
}
