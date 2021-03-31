class Todo {
  int _id;
  String _title;
  String _date;
  String _priority;
  String _description;
  int _status;

  Todo(this._title, this._date, this._priority, this._status,
      [this._description]);

  Todo.withId(this._id, this._title, this._date, this._priority, this._status,
      [this._description]);

  String get priority => _priority;

  set priority(String value) {
    _priority = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  int get status => _status;

  set status(int value) {
    _status = value;
  }

  @override
  String toString() {
    return 'Todo{_id: $_id, _title: $_title, _date: $_date, _priority: $_priority, _description: $_description, _status: $_status}';
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["title"] = _title;
    map["date"] = _date;
    map["priority"] = _priority;
    map["status"] = _status;
    map["description"] = _description;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  Todo.fromObject(dynamic o) {
    this._id = o["id"];
    this._title = o["title"];
    this._date = o["date"];
    this._priority = o["priority"];
    this._status = o["status"];
    this._description = o["description"];
  }
}
