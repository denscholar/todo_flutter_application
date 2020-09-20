import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_application/model/todo_item.dart';
import 'package:todo_application/utils/database_client.dart';
import 'package:todo_application/screens/add_note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class AddNote extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  AddNote(this.note, this.appBarTitle);

  @override
  _AddNoteState createState() => _AddNoteState(this.note, this.appBarTitle);
}

class _AddNoteState extends State<AddNote> {
  DatabaseHelper databaseHelper = DatabaseHelper();

//  Define the element which user can select
  static var _priorities = ['High', 'Low'];

  //define the text editing controller used for editing the value

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  var db = DatabaseHelper(); //an instance of the database

  String appBarTitle;
  Note note;

  _AddNoteState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    //theme textstyle
    TextStyle textStyle = Theme.of(context).textTheme.headline5;

    titleController.text = note.title;
    descriptionController.text = note.description;

    return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: Colors.purple,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                moveToLastScreen();
              }),
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: DropdownButton<String>(
                    items: _priorities.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(
                            dropDownStringItem,
                          ));
                    }).toList(),
                    style: textStyle,
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint(
                            'value selected by user $valueSelectedByUser');
                        updatePriorityAsInt(valueSelectedByUser);
                      });
                    },
                    value: getPriorityToString(note.priority),
                  ),
                ),

                //Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in the title text field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: ('Title'),
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                //Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint(
                          'Something changed in the description text field');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: ('Description'),
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                //Forth element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                            color: Colors.blueAccent,
                            child: Text(
                              'Save',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              debugPrint('save button click');
                              _save();
                            }),
                      ),

                      Container(
                        width: 5.0,
                      ),

                      //Fifth element
                      Expanded(
                        child: RaisedButton(
                            color: Colors.red,
                            child: Text(
                              'Delete',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint('Delete button clicked');
                                _delete();
                              });
                            }),
                      )
                    ],
                  ),
                )
              ],
            )));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  //convert the string priority into integer before saving it to database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;

      case 'Low':
        note.priority = 2;
        break;
    }
  }

//convert the priority to string and display it in the drop down
  String getPriorityToString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; //'High'
        break;

      case 2:
        priority = _priorities[1]; //'Low'
        break;
    }

    return priority;
  }

//update the title
  void updateTitle() {
    note.title = titleController.text;
  }

//update the description
  void updateDescription() {
    note.description = descriptionController.text;
  }

//save data to the database
  void _save() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());

    int result;
    if (note.id != null) {
      //case 1 update operation
      result = await databaseHelper.updateNote(note);
    } else {
      //insert operation
      result = await databaseHelper.insertNote(note);
    }
    if (result != 0) {
      _showAlertDialog('Status', 'Note saved successfully');
    } else {
      _showAlertDialog('Status', 'Problem saving Note');
    }
  }
  void _delete() async {

    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
