import 'dart:io';
import 'dart:math';

import 'package:bcrypt/bcrypt.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SQLite {
  const SQLite();

  static Database? _database;

  Future<Database> get database async {
    final Directory app = await getApplicationDocumentsDirectory();
    return _database ??= await databaseFactoryFfi.openDatabase(
      join(app.path, 'SimpleAccounting', 'Data', 'simpleaccounting.db'),
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _onCreate,
        onConfigure: _onConfigure,
      ),
    );
  }

  // On create database insert and create default tables.
  Future<void> _onCreate(Database database, int version) async {
    final Batch batch = database.batch();
    // _createSQLV1.split(';').forEach((element) {
    //   batch.execute(element);
    // });
    batch.execute(_createSQLV1);
    // Insert roles.
    batch.insert(
      'roles',
      <String, Object?>{
        'id': 1,
        'code': 'ADM',
        'name': 'ADMINISTRADOR',
        'active': true,
        'creation_date': DateTime.now().toIso8601String(),
        'update_date': DateTime.now().toIso8601String(),
      },
    );
    batch.insert(
      'roles',
      <String, Object?>{
        'id': 2,
        'code': 'REP',
        'name': 'REPORT',
        'active': true,
        'creation_date': DateTime.now().toIso8601String(),
        'update_date': DateTime.now().toIso8601String(),
      },
    );
    batch.insert(
      'roles',
      <String, Object?>{
        'id': 3,
        'code': 'TYP',
        'name': 'TYPER',
        'active': true,
        'creation_date': DateTime.now().toIso8601String(),
        'update_date': DateTime.now().toIso8601String(),
      },
    );
    // Insert users.
    batch.insert(
      'users',
      <String, Object?>{
        'role_id': 1,
        'code': generateSQLiteCode(),
        'username': 'admin',
        'password': BCrypt.hashpw('admin1234', BCrypt.gensalt()),
        'active': true,
        'creation_date': DateTime.now().toIso8601String(),
        'update_date': DateTime.now().toIso8601String(),
      },
    );
    // Insert account types.
    batch.insert(
      'account_types',
      <String, Object?>{
        'id': 1,
        'code': generateSQLiteCode(),
        'name': 'AGRUPADORA',
        'active': true,
        'creation_date': DateTime.now().toIso8601String(),
        'update_date': DateTime.now().toIso8601String(),
      },
    );
    batch.insert(
      'account_types',
      <String, Object?>{
        'id': 2,
        'code': generateSQLiteCode(),
        'name': 'MOVIMIENTO',
        'active': true,
        'creation_date': DateTime.now().toIso8601String(),
        'update_date': DateTime.now().toIso8601String(),
      },
    );
    // Insert categories
    batch.insert(
      'account_categories',
      <String, Object?>{
        'id': 1,
        'code': generateSQLiteCode(),
        'name': 'ACTIVOS',
        'active': true,
        'creation_date': DateTime.now().toIso8601String(),
        'update_date': DateTime.now().toIso8601String(),
      },
    );
    batch.insert(
      'account_categories',
      <String, Object?>{
        'id': 2,
        'code': generateSQLiteCode(),
        'name': 'PASIVOS',
        'active': true,
        'creation_date': DateTime.now().toIso8601String(),
        'update_date': DateTime.now().toIso8601String(),
      },
    );
    batch.insert(
      'account_categories',
      <String, Object?>{
        'id': 3,
        'code': generateSQLiteCode(),
        'name': 'PATRIMONIO',
        'active': true,
        'creation_date': DateTime.now().toIso8601String(),
        'update_date': DateTime.now().toIso8601String(),
      },
    );
    batch.insert(
      'account_categories',
      <String, Object?>{
        'id': 4,
        'code': generateSQLiteCode(),
        'name': 'INGRESOS',
        'active': true,
        'creation_date': DateTime.now().toIso8601String(),
        'update_date': DateTime.now().toIso8601String(),
      },
    );
    batch.insert(
      'account_categories',
      <String, Object?>{
        'id': 5,
        'code': generateSQLiteCode(),
        'name': 'GASTOS',
        'active': true,
        'creation_date': DateTime.now().toIso8601String(),
        'update_date': DateTime.now().toIso8601String(),
      },
    );
    batch.insert(
      'account_categories',
      <String, Object?>{
        'id': 6,
        'code': generateSQLiteCode(),
        'name': 'OTRO RESULTADO INTEGRAL',
        'active': true,
        'creation_date': DateTime.now().toIso8601String(),
        'update_date': DateTime.now().toIso8601String(),
      },
    );
    await batch.commit();
  }

  Future<void> _onConfigure(Database database) async {
    await database.execute("PRAGMA foreign_keys = ON");
  }
}

const String _createSQLV1 = '''
CREATE TABLE roles(
  id INTEGER PRIMARY KEY,
  code VARCHAR(20) NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL UNIQUE,
  active BOOLEAN NOT NULL,
  creation_date DATETIME NOT NULL,
  update_date DATETIME NOT NULL
);

CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  role_id INTEGER NOT NULL,
  code VARCHAR(20) NOT NULL UNIQUE,
  username VARCHAR(20) NOT NULL UNIQUE,
  password VARCHAR(128) NOT NULL,
  active BOOLEAN NOT NULL,
  creation_date DATETIME NOT NULL,
  update_date DATETIME NOT NULL,
  FOREIGN KEY (role_id) REFERENCES roles(id)
);

CREATE TABLE account_types(
  id INTEGER PRIMARY KEY,
  code VARCHAR(20) NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL UNIQUE,
  active BOOLEAN NOT NULL,
  creation_date DATETIME NOT NULL,
  update_date DATETIME NOT NULL
);

CREATE TABLE account_categories(
  id INTEGER PRIMARY KEY,
  code VARCHAR(20) NOT NULL UNIQUE,
  name VARCHAR(150) NOT NULL,
  description VARCHAR(300),
  active BOOLEAN NOT NULL,
  creation_date DATETIME NOT NULL,
  update_date DATETIME NOT NULL
);

CREATE TABLE accounts(
  id INTEGER PRIMARY KEY,
  parent_id INTEGER,
  account_type_id INTEGER NOT NULL,
  account_category_id INTEGER NOT NULL,
  code VARCHAR(20) NOT NULL UNIQUE,
  name VARCHAR(150) NOT NULL,
  description VARCHAR(300),
  active BOOLEAN NOT NULL,
  creation_date DATETIME NOT NULL,
  update_date DATETIME NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (parent_id) REFERENCES accounts(id),
  FOREIGN KEY (account_type_id) REFERENCES account_types(id),
  FOREIGN KEY (account_category_id) REFERENCES account_categories(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE periods(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  code VARCHAR(20) NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL UNIQUE,
  start_date DATETIME NOT NULL UNIQUE,
  end_date DATETIME NOT NULL UNIQUE,
  active BOOLEAN NOT NULL,
  creation_date DATETIME NOT NULL,
  update_date DATETIME NOT NULL,  
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE seats(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  period_id INTEGER NOT NULL,
  code VARCHAR(20) NOT NULL UNIQUE,
  date DATETIME NOT NULL,
  description VARCHAR(500),
  canceled BOOLEAN NOT NULL,
  FOREIGN KEY (period_id) REFERENCES periods(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE seat_details(
  id INTEGER PRIMARY KEY,  
  seat_id INTEGER NOT NULL,
  account_id INTEGER NOT NULL,
  code VARCHAR(20) NOT NULL UNIQUE,
  debit NUMERIC(19,5) NOT NULL,
  credit NUMERIC(19,5) NOT NULL,
  description VARCHAR(255),
  document_number VARCHAR(255),
  document_type VARCHAR(255),
  FOREIGN KEY (seat_id) REFERENCES seats(id),
  FOREIGN KEY (account_id) REFERENCES accounts(id)
);
''';

String generateSQLiteCode([int length = 20]) {
  const List<String> chars = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'k',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9'
  ];
  final StringBuffer buffer = StringBuffer();
  final Random random = Random();
  for (int i = 0; i < length; i++) {
    buffer.write(chars[random.nextInt(chars.length)]);
  }
  return buffer.toString();
}
