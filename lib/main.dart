// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
//
// void main()
// {
//   runApp(MaterialApp(
//     home: first(),
//     debugShowCheckedModeBanner:  false,
//   ));
// }
// class first extends StatefulWidget {
//   const first({super.key});
//
//   @override
//   State<first> createState() => _firstState();
// }
//
// class _firstState extends State<first> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:g_note_app/adapter.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
//
// void main() async {
//   await Hive.initFlutter();
//   Hive.registerAdapter(NoteAdapter());
//   await Hive.openBox<Note>('notes');
//
//   runApp(MyApp());
// }
//
// @HiveType(typeId: 0)
// class Note extends HiveObject {
//   @HiveField(0)
//   late String title;
//
//   @HiveField(1)
//   late String content;
//
//   @HiveField(2)
//   late DateTime createdAt;
//
//   //Note(this.title, this.content, this.createdAt);
//   Note({
//     required this.title,
//     required this.content,
//     required this.createdAt
//   });
// }
// class MyApp extends StatelessWidget {
//   @override
//   final int typeId=0;
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Note App',
//       home: NoteList(),
//     );
//   }
// }
//
// class NoteList extends StatefulWidget {
//   @override
//   _NoteListState createState() => _NoteListState();
// }
//
// class _NoteListState extends State<NoteList> {
//   late Box<Note> noteBox;
//
//   @override
//   void initState() {
//     super.initState();
//     noteBox = Hive.box<Note>('notes');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Note List'),
//       ),
//
//       body: ValueListenableBuilder(
//         valueListenable: noteBox.listenable(),
//         builder: (context, Box<Note> box, _) {
//           return ListView.builder(
//             itemCount: box.length,
//             itemBuilder: (context, index) {
//               Note note = box.getAt(index)!;
//               return ListTile(
//                 title: Text(note.title),
//                 subtitle: Text(note.content),
//                 onTap: () {
//                   // Handle note tap (e.g., navigate to note details)
//                 },
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to a screen to add a new note
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddNoteScreen()),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
//
// class AddNoteScreen extends StatelessWidget {
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController contentController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Note'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: InputDecoration(labelText: 'Title'),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: contentController,
//               decoration: InputDecoration(labelText: 'Content'),
//               maxLines: null,
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//
//                 final title = titleController.text.trim();
//                 final contact = titleController.text.trim();
//                 if(title.isNotEmpty && contact.isNotEmpty)
//                   {
//                       final noteBox = Hive.box<Note>('notes');
//                       noteBox.add(Note(
//                         title: title,
//                         content: content,
//                       ));
//                   }
//
//                 // final newNote = Note()
//                 //   ..title = titleController.text
//                 //   ..content = contentController.text
//                 //   ..createdAt = DateTime.now();
//                 //
//                 // Hive.box<Note>('notes').add(newNote);
//
//
//                 Navigator.pop(context);
//               },
//               child: Text('Save Note'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notes');

  runApp(MyApp());
}

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String content;

  Note({
    required this.title,
    required this.content,
  });
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 0;

  @override
  Note read(BinaryReader reader) {
    return Note(
      title: reader.readString(),
      content: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.content);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive Note',
      color: Colors.black,
      // theme: ThemeData(

      // primarySwatch: Colors.blue,
      //),
      home: NoteList(),
    );
  }
}

class NoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey.shade500,
      appBar: AppBar(backgroundColor: Colors.grey.shade800,
        title: Center(child: Text('Notes')),
      ),
      body: ValueListenableBuilder<Box<Note>>(
        valueListenable: Hive.box<Note>('notes').listenable(),
        builder: (context, box, _) {
          return  Container(
            margin: EdgeInsets.only(top: 10),
            //decoration: BoxDecoration(border: Border.all(width: 2)),
            child: GridView.builder(
              itemCount: box.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,crossAxisSpacing: 10,mainAxisSpacing: 10),
                itemBuilder: (context, index) {
                  final note = box.getAt(index)!;
                  return Container(
                    margin: EdgeInsets.all(5),
                    // height: 50,
                    // width: 50,
                    decoration: BoxDecoration(border: Border.all(width: 1),borderRadius: BorderRadius.circular(20),),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        SizedBox(height: 5,),
                        Container(
                          // decoration: BoxDecoration(border: Border.all(width: 2)),
                          child: Text(note.title),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          child: Text(note.content),
                        ),
                        Row(
                          children: [
                            IconButton(onPressed: () {
                              box.deleteAt(index);

                            }, icon: Icon(Icons.delete)),
                            IconButton(onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return EditNoteScreen(note: note,);
                              },));

                            }, icon: Icon(Icons.edit)),
                          ],
                        )
                      ],
                    ),
                  );

                },),
          );

          // return ListView.builder(
          //   itemCount: box.length,
          //   itemBuilder: (context, index) {
          //     final note = box.getAt(index)!;
          //     return ListTile(
          //       title: Text(note.title),
          //       subtitle: Text(note.content),
          //       trailing: IconButton(
          //         icon: Icon(Icons.delete),
          //         onPressed: () {
          //           box.deleteAt(index);
          //         },
          //       ),
          //     );
          //   },
          // );
        },
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.grey.shade800,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddNoteScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey.shade500,
        appBar: AppBar(backgroundColor: Colors.grey.shade800,
          title: Center(child: Text('Add Note')),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: contentController,style: TextStyle(backgroundColor: Colors.grey),
                  decoration: InputDecoration(
                    labelText: 'Content',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  maxLines: null,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final content = contentController.text.trim();
                    if (title.isNotEmpty && content.isNotEmpty) {
                      final noteBox = Hive.box<Note>('notes');
                      noteBox.add(Note(
                        title: title,
                        content: content,
                      ));
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save Note'),
                ),
              ],
            ),
        ),
        );
  }
}


class EditNoteScreen extends StatefulWidget {
  final Note note;
  const EditNoteScreen({required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Note'),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.grey.shade900,
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade400,
                    filled: true,
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade400,
                    filled: true,
                    labelText: 'Content',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: null,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    final title = _titleController.text.trim();
                    final content = _contentController.text.trim();
                    if (title.isNotEmpty && content.isNotEmpty) {
                      final noteBox = Hive.box<Note>('notes');
                      noteBox.putAt(
                        noteBox.values.toList().indexOf(widget.note),
                        Note(
                          title: title,
                          content: content,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save Changes'),
                ),
              ],
            ),
            ),
        );
    }
}

