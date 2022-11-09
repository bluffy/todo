import 'package:flutter/material.dart';

class MyInherited extends StatefulWidget {
  static MyInheritedData of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(MyInheritedData) as MyInheritedData;

  const MyInherited({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _MyInheritedState createState() => _MyInheritedState();
}

class _MyInheritedState extends State<MyInherited> {
  String myField;

  void onMyFieldChange(String newValue) {
    setState(() {
      myField = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyInheritedData(
      myField: myField,
      onMyFieldChange: onMyFieldChange,
      child: widget.child,
    );
  }
}

class MyInheritedData extends InheritedWidget {
  final String myField;
  final ValueChanged<String> onMyFieldChange;

  MyInheritedData({
    Key key,
    this.myField,
    this.onMyFieldChange,
    Widget child,
  }) : super(key: key, child: child);

  static MyInheritedData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedData>();
  }

  @override
  bool updateShouldNotify(MyInheritedData oldWidget) {
    return oldWidget.myField != myField ||
        oldWidget.onMyFieldChange != onMyFieldChange;
  }
}
