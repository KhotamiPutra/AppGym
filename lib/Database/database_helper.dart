import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:typed_data'; // Untuk Uint8List

class DBHelper {
  Database? _database; // Buat _database nullable agar bisa dicek null

  // Inisialisasi database
  Future<void> initDB() async {
    String path = join(await getDatabasesPath(), 'gym.db');
    _database = await openDatabase(
      path,
      onCreate: (db, version) {
        // Buat tabel member
        db.execute('''CREATE TABLE members (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        photo BLOB,
        name TEXT,
        phone_number TEXT,
        is_pre_registration INTEGER, 
        is_tni INTEGER, 
        start_date TEXT,
        end_date TEXT,
        trainer_id INTEGER,
        is_active TEXT NOT NULL,
        price REAL,
        FOREIGN KEY(trainer_id) REFERENCES trainer(id)
      )''');

        // Buat tabel harga
        db.execute('''CREATE TABLE prices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        member_price REAL,
        pre_registration_price REAL,
        tni_discount REAL
      )''');

        // Buat tabel trainer
        db.execute('''CREATE TABLE trainer (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        photo BLOB,
        name TEXT,
        phone_number TEXT,
        price REAL
      )''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          // Tambahkan kolom tni_discount jika belum ada
          await db.execute('ALTER TABLE prices ADD COLUMN tni_discount REAL');
        }
        if (oldVersion < 4) {
          // Buat tabel trainer jika belum ada
          await db.execute('''CREATE TABLE IF NOT EXISTS trainer (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          photo BLOB,
          name TEXT,
          phone_number TEXT,
          price REAL
        )''');
        }
      },
      onOpen: (db) {
        db.execute('PRAGMA foreign_keys = ON;');
      },
      version: 4, // Naikkan versi database
    );
  }

  // Pastikan database sudah diinisialisasi sebelum digunakan
  Future<Database> get database async {
    if (_database == null) {
      await initDB(); // Memanggil initDB jika _database masih null
    }
    return _database!; // Menggunakan '!' untuk memastikan bahwa _database bukan null
  }

  // CRUD tabel member
  Future<void> insertMember({
    Uint8List? photo,
    required String name,
    required String phoneNumber,
    required int isPreRegistration,
    required int isTni,
    required String startDate,
    required String endDate,
    int? trainerId,
    required String isActive,
    required double price,
  }) async {
    final db = await database;
    await db.insert('members', {
      'photo': photo,
      'name': name,
      'phone_number': phoneNumber,
      'is_pre_registration': isPreRegistration,
      'is_tni': isTni,
      'start_date': startDate,
      'end_date': endDate,
      'trainer_id': trainerId,
      'is_active': isActive,
      'price': price,
    });
    print('Member inserted successfully');
  }

  // Mengambil Semua Member
  Future<List<Map<String, dynamic>>> getAllMembers() async {
    final db = await database;
    return await db.query('members');
  }

  // Update member
  Future<void> updateMember({
    required int id,
    Uint8List? photo,
    required String name,
    required String phoneNumber,
    required int isPreRegistration,
    required int isTni,
    required String startDate,
    required String endDate,
    int? trainerId,
    required String isActive,
    required double price,
  }) async {
    final db = await database;
    await db.update(
      'members',
      {
        'photo': photo,
        'name': name,
        'phone_number': phoneNumber,
        'is_pre_registration': isPreRegistration,
        'is_tni': isTni,
        'start_date': startDate,
        'end_date': endDate,
        'trainer_id': trainerId,
        'is_active': isActive,
        'price': price,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Menghapus Member
  Future<void> deleteMember(int id) async {
    final db = await database;
    await db.delete('members', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateExpiredMemberships() async {
    final db = await database;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day).toIso8601String();

    await db.update(
      'members',
      {'is_active': 'Tidak Aktif'},
      where: 'end_date < ? AND is_active = ?',
      whereArgs: [today, 'Aktif'],
    );
  }

   Future<List<Map<String, dynamic>>> getActiveMembersNearingExpiry() async {
    final db = await database;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day).toIso8601String();

    return await db.query(
      'members',
      where: 'end_date <= ? AND is_active = ?',
      whereArgs: [today, 'Aktif'],
    );
  }

  // ===========================================

  // CRUD tabel price
  Future<void> insertPrice({
    required double memberPrice,
    required double preRegistrationPrice,
    required double tniDiscount,
  }) async {
    final db = await database;
    await db.insert('prices', {
      'member_price': memberPrice,
      'pre_registration_price': preRegistrationPrice,
      'tni_discount': tniDiscount,
    });
    print('Price inserted successfully');
  }

  // Mengambil Semua Prices
  Future<List<Map<String, dynamic>>> getAllPrices() async {
    final db = await database;
    return await db.query('prices');
  }

  // Update Prices
  Future<void> updatePrice({
    required int id,
    required double memberPrice,
    required double preRegistrationPrice,
    required double tniDiscount,
  }) async {
    final db = await database;
    await db.update(
      'prices',
      {
        'member_price': memberPrice,
        'pre_registration_price': preRegistrationPrice,
        'tni_discount': tniDiscount,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Menghapus Prices
  Future<void> deletePrice(int id) async {
    final db = await database;
    await db.delete('prices', where: 'id = ?', whereArgs: [id]);
  }

  // ===========================================

  // CRUD tabel trainer
  Future<void> insertTrainer({
    required String name,
    required String phoneNumber,
    Uint8List? photo,
    required double price,
  }) async {
    final db = await database;
    await db.insert('trainer', {
      'name': name,
      'phone_number': phoneNumber,
      'photo': photo,
      'price': price,
    });
    print('Trainer inserted successfully');
  }

  // Mengambil Semua Trainer
  Future<List<Map<String, dynamic>>> getAllTrainers() async {
    final db = await database;
    return await db.query('trainer');
  }

  Future<bool> trainerHasMember(int trainerId) async {
    final db = await database;
    final result = await db.query(
      'members',
      where: 'trainer_id = ?',
      whereArgs: [trainerId],
    );
    return result.isNotEmpty;
  }

  Future<void> removeTrainerFromMembers(int trainerId) async {
    final db = await database;
    await db.update(
      'members',
      {'trainer_id': null},
      where: 'trainer_id = ?',
      whereArgs: [trainerId],
    );
  }

  // Update Trainer
  Future<void> updateTrainer({
    required int id,
    required String name,
    required String phoneNumber,
    Uint8List? photo,
    required double price,
  }) async {
    final db = await database;
    await db.update(
      'trainer',
      {
        'name': name,
        'phone_number': phoneNumber,
        'photo': photo,
        'price': price,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Menghapus Trainer
  Future<void> deleteTrainer(int trainerId) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.update(
        'members',
        {'trainer_id': null},
        where: 'trainer_id = ?',
        whereArgs: [trainerId],
      );
      await txn.delete(
        'trainer',
        where: 'id = ?',
        whereArgs: [trainerId],
      );
    });
  }

  // Menutup koneksi database
  Future<void> close() async {
    final db = await database; // Pastikan database sudah diinisialisasi
    await db.close();
  }
}
