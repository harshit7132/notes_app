import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_app/Database/Notes_Model.dart';

import 'Database/AppDataBase.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  late DbHelper myDb;
  List<noteModel> arrNotes = [];

  @override
  void initState() {
    super.initState();
    myDb = DbHelper.db;
    getNotes();
  }

  void getNotes() async {
    arrNotes = await myDb.fetchAllNotes();
    setState(() {});
  }

  void addNotes(String title, String desc) async {
    bool check = await myDb.addNotes(noteModel(title: title, desc: desc));

    if (check) {
      arrNotes = await myDb.fetchAllNotes();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
            itemCount: arrNotes.length,
            itemBuilder: (_, index) {
              return Container(
margin: EdgeInsets.all(10),
                height:100,
                width: double.infinity,
                color:Colors.primaries[Random().nextInt(Colors.primaries.length)],
                child: InkWell(
                  onTap: () {
                    titleController.text = arrNotes[index].title;
                    descController.text = arrNotes[index].desc;
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                              height: 300,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Update Notes'),
                                  TextField(
                                    controller: titleController,
                                  ),
                                  TextField(
                                    controller: descController,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        var Utitle =
                                            titleController.text.toString();
                                        var Udesc = descController.text.toString();
                                        myDb.updateNotes(noteModel(
                                            note_id: arrNotes[index].note_id,
                                            title: Utitle,
                                            desc: Udesc));
                                        getNotes();
                                        Navigator.pop(context);
                                      },
                                      child: Text('Update Notes'))
                                ],
                              ));
                        });
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(arrNotes[index].note_id.toString()),
                    ),
                    title: Text(arrNotes[index].title.toString()),
                    subtitle: Text(arrNotes[index].desc.toString()),
                    trailing: IconButton(
                        onPressed: () async {
                          await myDb.deleteNotes(arrNotes[index].note_id!);
                          getNotes();
                        },
                        icon: Icon(Icons.delete)),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return SizedBox(
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Add Notes'),
                        TextField(
                          controller: titleController,
                        ),
                        TextField(
                          controller: descController,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              var title = titleController.text.toString();
                              var desc = descController.text.toString();
                              addNotes(title, desc);
                              Navigator.pop(context);
                            },
                            child: Text('add'))
                      ],
                    ));
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
