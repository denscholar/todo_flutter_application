import 'package:flutter/material.dart';
import 'package:todo_application/model/todo_item.dart';
import 'package:todo_application/utils/database_client.dart';
import 'package:todo_application/screens/add_note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';


class NoteList extends StatefulWidget {

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();

//  declare a notelist variable to display the notes within the listview

  List<Note>noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
//    instantiate the notelist function
    if (noteList == null){
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      backgroundColor: Colors.black87,
        appBar: AppBar(
          title: Text('TodoList'),
          backgroundColor: Colors.grey,
        ),
        body: getNoteListView(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink,
          onPressed: () {
            navigateToAdd(Note('', '', 2), 'Add Note');
          },
          tooltip: 'add todo',
          child: Icon(Icons.add),
        ));
  }

  //create a function for the notelist view as a listview builder
  ListView getNoteListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            elevation: 2.0,
            color: Colors.white,
            child: ListTile(
              title: Text(this.noteList[position].title),
              subtitle: Text(this.noteList[position].date),
              trailing: GestureDetector( //use the gesture detector to implement the delete function
                child: Icon(Icons.delete),
                onTap: (){
                  _delete(context, noteList[position]);
                },
              ),
              leading: CircleAvatar(
                backgroundColor: getPriorityColor(this.noteList[position].priority),
                child: getPriorityIcon(this.noteList[position].priority),
              ),
              onTap: () {
                navigateToAdd(this.noteList[position], 'Edit Note');
              },
            ),
          );
        });
  }

  //Create a push navigation function
  void navigateToAdd(Note note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddNote(note, title);
    }));

    if (result == true){
      updateListView();
    }
  }

  //helper function
//1. return the priority color
Color getPriorityColor(int priority){

    switch(priority){
      case 1:
        return Colors.red;
        break;

      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;

    }
}

//1. return the priority Icon
  Icon getPriorityIcon(int priority){

    switch(priority){
      case 1:
        return Icon(Icons.play_arrow);
        break;

      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);

    }
  }

  //CREATE A DELETE FUNCTION
void _delete (BuildContext context, Note note) async{
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0){
      _showSnackBar(context, 'Notes deleted successfully');
      updateListView();
    }
}

//function that handles the snackbar
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

//  update ListView

  void updateListView() {
    final Future<Database>dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note >> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}


