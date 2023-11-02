import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:libros/book.dart';

class DBManager {
  static Database? _db;
  static const String ID = 'controlNum';
  static const String TITLE = 'title';
  static const String AUTHOR = 'author';
  static const String PUBLISHER = 'publisher';
  static const String PAGES = 'pages';
  static const String EDITION = 'edition';
  static const String ISBN = 'isbn';
  static const String PHOTO_NAME = 'photo_name';
  static const String TABLE = 'Books';
  static const String DB_NAME = 'books.db';

  //InitDB
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDB();
      return _db;
    }
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, "
            "$TITLE TEXT, $AUTHOR TEXT, $PUBLISHER TEXT, $PAGES TEXT, "
            "$EDITION TEXT, $ISBN TEXT, $PHOTO_NAME TEXT)");
  }
  //Insert
  Future<Book> save(Book book) async{
    var dbClient = await _db;
    book.controlNum = await dbClient!.insert(TABLE, book.toMap());
    return book;
  }
  //Select
  Future<List<Book>> getBooks()async{
    var dbClient = await (db);
    List<Map> maps = await dbClient!.query(TABLE,
        columns: [ID, TITLE, AUTHOR, PUBLISHER, PAGES, EDITION, ISBN, PHOTO_NAME]);
    List<Book> books = [];
    print(books.length);
    if (maps.isNotEmpty){
      for(int i=0; i<maps.length;i++){
        print("Datos");
        print(Book.formMap(maps[i] as Map<String, dynamic>));
        books.add(Book.formMap(maps[i] as Map<String, dynamic>));
      }
    }
    return books;
  }
  //Delete
  Future<int> delete(int id) async {
    var dbClient = await (db);
    return await dbClient!.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }
  //Update
  Future<int> update(Book book) async {
    var dbClient = await (db);
    return await dbClient!.update(TABLE, book.toMap(),
        where: '$ID = ?', whereArgs: [book.controlNum]);
  }

  //Close DB
  Future close() async{
    var dbClient = await (db);
    dbClient!.close();
  }
}



