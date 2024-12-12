import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//import 'package:firebase_auth/firebase_auth.dart';
class myDatabaseClass {
  Database? mydb;
  int Version = 1;

  Future<Database?> mydbcheck() async {
    if (mydb == null) {
      mydb = await initiatedatabase();
      return mydb;
    }
    else
      return mydb;
  }

  initiatedatabase() async
  {
    String databasedestination = await getDatabasesPath();
    String databasepath = join(databasedestination, 'hedieatydatabase.db');
    Database db = await openDatabase(
      databasepath,
      version: Version,
      onCreate: _createDB,
    );
    return db;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        preferences TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE Events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        location TEXT NOT NULL,
        description TEXT,
        user_id INTEGER NOT NULL,
        FOREIGN KEY(user_id) REFERENCES Users(id)
      );
    ''');


    await db.execute('''
      CREATE TABLE Gifts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT,
        price REAL,
        status TEXT,
        event_id INTEGER,
         pledged_by INTEGER,
        FOREIGN KEY(event_id) REFERENCES Events(id),
        FOREIGN KEY(pledged_by) REFERENCES Users(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE Friends (
        user_id INTEGER NOT NULL,
        friend_id INTEGER NOT NULL,
        PRIMARY KEY(user_id, friend_id),
        FOREIGN KEY(user_id) REFERENCES Users(id),
        FOREIGN KEY(friend_id) REFERENCES Users(id)
      );
    ''');
    print("---------DATABASE CREATED---------------");

  }

  insertData(String sql) async{
    Database? mydb=await mydbcheck();
    var response = mydb!.rawInsert(sql);
    return response;
  }
 readData(String sql) async{
    Database? mydb=await mydbcheck();
    List <Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  updateData(String sql) async{
    Database? mydb=await mydbcheck();
    var response = mydb!.rawQuery(sql);
    return response;
  }
  deleteData(String sql) async{
    Database? mydb=await mydbcheck();
    var response = mydb!.rawDelete(sql);
    return response;
  }

  checking() async{
    String databasedestination = await getDatabasesPath();
    String databasepath = join(databasedestination, 'hedieatydatabase.db');
    await databaseExists(databasepath)? print("Database exists"): print("It does not exist");
  }

  reseting() async {
    String databasedestination = await getDatabasesPath();
    String databasepath = join(databasedestination, 'hedieatydatabase.db');
    await deleteDatabase(databasepath);

  }


}