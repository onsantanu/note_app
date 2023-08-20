import 'package:sqflite/sqflite.dart';
import 'package:take_notes/models/daily_finance_model.dart';

class FinanceDatabase {
  static final _name = "NotesDatabase.db";
  static final _version = 1;

  late Database database;
  static final tableName = 'finance';

  initDatabase() async {
    database = await openDatabase(_name, version: _version,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE $tableName (
					id INTEGER PRIMARY KEY AUTOINCREMENT,
					title TEXT,
					content TEXT,
					amount DOUBLE,
          createdat DATETIME
					)''');
    });
  }

  Future<int> insertFinance(DailyFinance note) async {
    print('@@@@@@@@@@@');
    print(note.toMap());
    return await database.insert(tableName, note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateFinance(DailyFinance obj) async {
    return await database.update(tableName, obj.toMap(),
        where: 'id = ?',
        whereArgs: [obj.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllFinance() async {
    return await database.rawQuery(
        '''SELECT SUM(amount) as totalAmount, strftime('%m-%Y', createdat) as monthyear, strftime('%Y', createdat) as year, strftime('%m', createdat) as month FROM $tableName WHERE 1 GROUP BY month, year''');
  }

  Future<List<Map<String, dynamic>>> getAllFinanceByMonthYear(monthYear) async {
    return await database.rawQuery(
        '''SELECT * FROM $tableName WHERE strftime('%m-%Y', createdat) == ?''',
        [monthYear]);
  }

  Future<Map<String, dynamic>?> getFinanceDtl(int id) async {
    var result =
        await database.query(tableName, where: 'id = ?', whereArgs: [id]);

    if (result.length > 0) {
      return result.first;
    }

    return null;
  }

  Future<int> deleteAllFinance() async {
    return await database.delete(tableName);
  }

  Future<int> deleteFinance(int id) async {
    return await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  closeDatabase() async {
    await database.close();
  }
}
