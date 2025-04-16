import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DbHelper {
  final String TABLE_NAME = "Todos";
  final String COLUMN_S_NO = "S_no";
  final String COLUMN_NAME = "title";
  final String COLUMN_ISCOMP = "iscomp";

  static final DbHelper instance = DbHelper._internal();
  static Database? myDB;
  DbHelper._internal();

  factory DbHelper() {
    return instance;
  }

  Future<Database> getDatabase() async {
    myDB ??= await openDb();
    return myDB!;
    // if (myDB != null) {
    //   return myDB!;
    // }
    // return await openDb();
  }

  Future<Database> openDb() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "todo.db");
    return await openDatabase(
      dbPath,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE $TABLE_NAME($COLUMN_S_NO integer Primary key autoincrement, $COLUMN_NAME Text,$COLUMN_ISCOMP INTEGER DEFAULT 0) ",
        );
      },
      version: 1,
    );
  }

  //add todo list
  Future<bool> addTodo({required String title,required bool iscompleted}) async{
    var db = await getDatabase();
    int iscomp = 0;
    if(iscompleted==true){
      iscomp = 1;
    }
     int rowAffected =  await db.insert(TABLE_NAME, {COLUMN_NAME : title ,COLUMN_ISCOMP : iscomp});
     log("Rowaffected $rowAffected");

    
    return rowAffected>0;
  }

  //show todo 
  Future<List<Map<String,dynamic>>> getTodo() async{
    var db = await getDatabase();
    List<Map<String,dynamic>> Data = await db.query(TABLE_NAME);
    //log("gettodo method called");
    log("getTodo : return Success !");
    return Data;
    
  }
  Future<bool> updateTodo({required int check,required int id}) async {
    var db = await getDatabase();
    
    int rowAffected = await db.update(TABLE_NAME,
    {COLUMN_ISCOMP:check},where: "$COLUMN_S_NO = $id");
    return rowAffected>0;
  }

  Future<bool> deleteTodo(int id) async {
  var db = await getDatabase(); 
  
  int rowsAffected = await db.delete(
    TABLE_NAME, 
    where: "$COLUMN_S_NO = ?", 
    whereArgs: [id],           
  );

  return rowsAffected > 0; 
}

}
