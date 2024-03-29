import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService{
  static DatabaseService? _instance;
  static const databaseName = "database";

  factory DatabaseService() {
    if(_instance == null)  {
      _instance = DatabaseService._();
      _instance!._onCreateDatabase();
    }

    return _instance!;
  }

  DatabaseService._();

  Future<Database> _onCreateDatabase() async{
      return await openDatabase(
        join(await getDatabasesPath(), "${DatabaseService.databaseName}.db"),
        onCreate: (Database db, int version) async => _createTable(db),
        version: 1
      );
  }

  Future<Database> initDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), '$databaseName.db'));
  }

  Future<void> _createTable(db) async{
    await db.execute(
        'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT NOT NULL, description TEXT, isFinish INTEGER)'
    );
  }
}