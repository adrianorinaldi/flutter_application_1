import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = new List<Item>();

  HomePage() {
    items = [];
    // items.add(Item(title: "Item 1", done: false));
    // items.add(Item(title: "Item 2", done: true));
    // items.add(Item(title: "Item 3", done: false));
  }
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();
  
  _HomePageState() {
    load();
  }

  void add() {
    if(newTaskCtrl.text.isEmpty) {
      return;
    }
    setState(() {
      widget.items.add(
        Item(
          title: newTaskCtrl.text, 
          done: false
        ));
      newTaskCtrl.text = "";
      save();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;  
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }


 @override
 Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      leading: Text("Oi"),
      title: TextFormField(
        controller: newTaskCtrl,
        keyboardType: TextInputType.text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          labelText: "Nova Tarefa",
          labelStyle: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      actions: <Widget>[
        Icon(Icons.plus_one)
      ],
    ),
    body: ListView.builder(
      itemCount: widget.items.length,  
      itemBuilder: (BuildContext ctxt, int index) {
        final item = widget.items[index];
        return CheckboxListTile(
          title: Text(item.title),
          key: Key(item.title),
          value: item.done, 
          onChanged: (value) {
            setState(() {
              item.done = value;
            });
          },
        );
      },
    ),floatingActionButton: FloatingActionButton(
      onPressed: add,
      child: Icon(Icons.add),
      backgroundColor: Colors.pink,
    ),
  );
 }
}




