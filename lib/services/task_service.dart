import 'package:examen_flutter/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class TaskService {

  static const _table = 'tasks';
  late DatabaseService databaseService;

  TaskService(){
    databaseService = DatabaseService();
  }

  Future<List<Task>> getAllAttraction() async{
    Database db = await databaseService.initDatabase();

    final List<Map<String, dynamic>> tasksMaps = await db.query(_table);

    return [
      for (
        final {
          'id': id as int,
          'title': title as String,
          'description': description as String,
          'isFinish': isFinish as int
        } in tasksMaps
      )
        Task(id: id,title: title, description: description, isFinish: isFinish),
    ];
  }

  Future<int> createOrUpdate(Map<String, dynamic> data) async{
    Database db = await databaseService.initDatabase();

    return
      await db.insert(
          _table,
          data,
          conflictAlgorithm: ConflictAlgorithm.replace
      );
  }

  Future<int> delete(int id) async{
    Database db = await databaseService.initDatabase();
    return await db.delete(
        _table,
        where: "id = ?",
        whereArgs: [id]
    );
  }
}