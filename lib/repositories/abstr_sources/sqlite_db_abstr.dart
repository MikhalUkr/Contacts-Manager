import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

typedef Json = Map<String, dynamic>;

abstract class SqliteDbService {
  Future<Database> database(String table);

  /// This method helps insert a map of [values]
  /// into the specified [table] and returns the
  /// id of the last inserted row.
  ///
  /// ```
  ///    var value = {
  ///      'age': 18,
  ///      'name': 'value'
  ///    };
  ///    int id = await db.insert(
  ///      'table',
  ///      value,
  ///      conflictAlgorithm: ConflictAlgorithm.replace,
  ///    );
  /// ```
  ///
  /// 0 could be returned for some specific conflict algorithms if not inserted.
  Future<int> insert(String table, Map<String, dynamic> data);

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
  });

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
  });

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
  Future<int> delete(String table, {String? where, List<dynamic>? whereArgs});
}
