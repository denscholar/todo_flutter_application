import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_application/model/todo_item.dart';

//This database class will be responsible for creating and doing the whole operations - CRUD
/*
We will create an instance inside of this class so that whenever we want to invock database helper
we dont have to create a new objects everytime - idea of singleton
 */

class DatabaseHelper {
  //singleton databaseHelper: this means that this instance will be initialize only once throughout the application
  static DatabaseHelper _databaseHelper;

  //  INITIALIZE ALL THE VARIABLES IN THE TABLE
  final String tableName = 'TableName';
  final String colId = 'id';
  final String colTitle = 'title';
  final String colDescription = 'description';
  final String colPriority = 'priority';
  final String coldate = 'date';

  /*
  create a factory constructor that will allow us to cashe all of the state of the database helper
  just to make sure that everytime the databasehelper is invoked, we are not
  creating lots of object and bug down our system

   */
  DatabaseHelper._createInstance(); //named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); //this is executed only once, singleton object
    }
    return _databaseHelper;
  }

//  create the getter for the database

  //create a static database
  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  //initialize the database;
  Future<Database> initializeDatabase() async {
    //get the application directory
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes.db');

    //open/create the database
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

//create a function that will execute a statement to CREATE our database

  void _createDb(Database db, int newVersion) async {
    await db.execute(
      'CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $coldate TEXT)',
    );
  }

  // CRUD => CREATE, READ, UPDATE, DELETE

  //fetch/get all the objects from the database

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database; //reference to the database

//    var result = await db.rawQuery('SELECT * FROM $tableName ORDER BY $colPriority ASC');this and the below is the same method
    var result = await db.query(tableName, orderBy: '$colPriority');
    return result.toList();
  }

  //INSERT OPERATION
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(tableName, note.toMap());
    return result;
  }

  //UPDATE
  Future<int> updateNote(Note note) async {
    var db = await this.database;
    var result = await db.update(tableName, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

//  Future<List> getItems() async {
//    var dbClient = await db;
//    var result = await dbClient
//        .rawQuery('SELECT * FROM $tableName ORDER BY $colItemName ASC');
//    return result.toList();
//  }

//to get one item
//  Future<TodoItem> getItem(int id) async {
//    var dbClient = await db;
//    var result =
//        await dbClient.rawQuery('SELECT * FROM $tableName( WHERE $colId = $id');
//    if (result.length == 0) {
//      return null;
//    } else {
//      return new TodoItem.fromMap(result.first);
//    }
//  }

//Delete an item

  Future<int>deleteNote(int id) async {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $tableName WHERE $colId = $id');
    return result;
 }

 //GEt number of records in the TABLE

  Future<int>getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (x) FROM $tableName');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

//  Future close() async {
//    var db = await this.database;
//    return db.close();
//  }



//  get the 'Map List' (List<Map>) and convert it to 'NoteList' List<Note>
  Future<List<Note>> getNoteList() async{
    var noteMapList = await getNoteMapList(); // get 'Map list' from the Database
    int count = noteMapList.length;

    List<Note> noteList = List<Note>(); //create an empty list of Note

//    write a For loop to create a NoteList from the MapList
  for (int i = 0; i < count; i++){
    noteList.add(Note.fromMapObject(noteMapList[i]));
  }
  return noteList;

  }

}
