//create the model class
/*

DATABASE TABLE FOR THE TODO APPLICATION

id | title | description | priority | date |
--------------------------------------------
1  |       |             |          |      |
2  |       |             |          |      |
3  |       |             |          |      |
*/

class Note{

  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

//  define the constructor that will help create the Todo_object
Note(this._title, this._date, this._priority, [this._description]);


//define another constructor that will accept id as a parameter
Note.withId(this._id, this._title, this._date, this._priority, [this._description]);


//create the getter

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get priority => _priority;

  //create the setter
//ignore the setter for id because it will generate automatically

set title(String newTitle){
  if (newTitle.length <= 255){ //set the condition.
    this._title = newTitle;
  }
}
set description(String newDescription){
  if (newDescription.length <= 255){ //set the condition.
    this._description = newDescription;
  }
}
set priority(int newPriority){
  if (newPriority <= 1 && newPriority <=2){
    this._priority = newPriority;
  }
}
set date(String newDate){
  this._date = newDate;
}

//convert the todo object into a Map object

Map<String, dynamic>toMap(){

  var map = Map<String, dynamic>(); //instantiate an empty map object

  if (id != null){
    map['id'] = _id; //check ic the id is null or not
  }

  map['title'] = _title; //insert title into the map object with the key of _title
  map['description'] = _description;
  map['priority'] = _priority;
  map['date'] = _date;

  return map;
}
//extract a todo object from a Map object
Note.fromMapObject(Map<String, dynamic>map){
  this._id = map['id'];
  this._title = map['title'];
  this._description = map['description'];
  this._priority = map['priority'];
  this._date = map['date'];

}




}