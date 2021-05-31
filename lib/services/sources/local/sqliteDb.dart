import 'dart:developer';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

typedef Json = Map<String, dynamic>;

class SqliteDbService {
  static const String mainTag = '## SqliteDbService';
  final String nameContactsDbTable = 'contacts';

  Future<Database> database(String table) async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(
      path.join(dbPath, 'contacts_db.db'),
      onCreate: (dbase, version) {
        return dbase.execute(
            'CREATE TABLE $table(id TEXT PRIMARY KEY, name TEXT, surname TEXT, email TEXT, image TEXT)');
      },
      version: 1,
    );
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    // int count = await (await database(table)).insert(
    //  or:
    try {
      final db = await database(table);
      int count = 0;
      if (db.isOpen) {
        count = await db.insert(
          table,
          data,
          conflictAlgorithm: sql.ConflictAlgorithm.replace,
        );
      } else {
        log('## [E] $mainTag.insert() Database is not Open');
      }
      return count;
    } catch (e) {
      rethrow;
    }
  }

  /// Method for getting data from database. Return the loaded data as
  /// a [List<Map<String, dynamic>>].
  ///
  /// `where` is the optional WHERE clause to apply when loading the data.
  /// Passing null will loading all rows.
  ///
  /// You may include '?'s in the where clause, which will be replaced by the
  /// values from `whereArgs`
  /// e.g. `where: "id = ?, name = ?"`(here 'id' and 'name' is names of the colunms),
  /// and then `whereArgs: [place.id, place.name]`
  /// or directly `where: "id = \"$place.id\"", "id = \"$place.name\""`
  ///
  /// `conflictAlgorithm` (optional) specifies algorithm to use in case of a
  /// conflict. See [ConflictAlgorithm] docs for more details
  Future<List<Map<String, dynamic>>> getData(
    String table, {
    String? orderBy,
    String? where,
    List<String>? whereArgs,
  }) async {
    List<Map<String, dynamic>> _loadedData = [];
    try {
      final db = await database(table);
      if (db.isOpen) {
        _loadedData = await db.query(
          table,
          orderBy: orderBy,
          where: where,
          whereArgs: whereArgs,
        );
      } else {
        log('## [E] $mainTag.getData() Database is not Open');
      }
      return _loadedData;
    } catch (e) {
      rethrow;
    }
  }

  /// Method for updating rows in the database. Returns
  /// the number of changes made
  ///
  /// Update `table` with `values`, a map from column names to new column
  /// values. null is a valid value that will be translated to NULL.
  ///
  /// `where` is the optional WHERE clause to apply when updating.
  /// Passing null will update all rows.
  ///
  /// You may include '?'s in the where clause, which will be replaced by the
  /// values from `whereArgs`
  /// e.g. `where: "id = ?, name = ?"`(here 'id' and 'name' is names of the colunms),
  /// and then `whereArgs: [place.id, place.name]`
  /// or directly `where: "id = \"$place.id\"", "id = \"$place.name\""`
  ///
  /// `conflictAlgorithm` (optional) specifies algorithm to use in case of a
  /// conflict. See [ConflictAlgorithm] docs for more details
  ///
  /// ```
  /// int count = await db.update(tableTodo, todo.toMap(),
  ///    where: '$columnId = ?', whereArgs: [todo.id]);
  /// ```
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    required String where,
    List<dynamic>? whereArgs,
    ConflictAlgorithm conflictAlgorithm = sql.ConflictAlgorithm.replace,
  }) async {
    int count = 0;
    final db = await database(table);
    if (db.isOpen) {
      count = await db.update(
        table,
        data,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: conflictAlgorithm,
      );
    }
    log('$mainTag.update() count: $count');
    return count;
  }

  /// Method for deleting rows in the database.
  ///
  /// Delete from `table`
  ///
  /// `where` is the optional WHERE clause to apply when updating. Passing null
  /// will update all rows.
  ///
  /// You may include '?'s in the where clause, which will be replaced by the
  /// values from `whereArgs`
  /// e.g. `where: "id = ?, name = ?"`(here 'id' and 'name' is names of the colunms),
  /// and then `whereArgs: [place.id, place.name]`
  /// or directly `where: "id = \"$place.id\"", "id = \"$place.name\""`
  ///
  /// Returns the number of rows affected if a whereClause is passed in, 0
  /// otherwise. To remove all rows and get a count, pass '1' as the
  /// whereClause.
  /// ```
  ///  int count = await db.delete(tableTodo, where: 'columnId = ?', whereArgs: [id]);
  /// ```
  Future<int> delete(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    int count = 0;
    try {
      final db = await database(table);
      if (db.isOpen) {
        count = await db.delete(
          table,
          where: where,
          whereArgs: whereArgs,
        );
      } else {
        log('## [E] $mainTag.getData() Database is not Open');
      }
      log('$mainTag.delete() count: $count');
      return count;
    } catch (e) {
      rethrow;
    }
  }
}
