import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/transaction_entry.dart';

class DatabaseService {
  DatabaseService._();
  static final instance=DatabaseService._();
  Database? _db;
  Future<Database> get db async {
    if(_db!=null) return _db!;
    _db=await openDatabase(join(await getDatabasesPath(),'sijili.db'),version:1,onCreate:(d,v) async {
      await d.execute('CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT,income INTEGER NOT NULL,name TEXT NOT NULL,amount REAL NOT NULL,date TEXT NOT NULL,received_by TEXT,source TEXT,note TEXT)');
    });
    return _db!;
  }
  Future<List<TransactionEntry>> all() async {
    final d=await db; final rows=await d.query('transactions',orderBy:'date DESC,id DESC');
    return rows.map(TransactionEntry.fromMap).toList();
  }
  Future<int> insert(TransactionEntry e) async => (await db).insert('transactions',e.toMap()..remove('id'));
  Future<int> update(TransactionEntry e) async => (await db).update('transactions',e.toMap()..remove('id'),where:'id=?',whereArgs:[e.id]);
  Future<int> delete(int id) async => (await db).delete('transactions',where:'id=?',whereArgs:[id]);
}