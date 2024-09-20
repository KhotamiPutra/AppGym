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
        //tabel member
        db.execute('''
          CREATE TABLE members (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            photo BLOB,
            name TEXT,
            phone_number TEXT,
            is_pre_registration INTEGER,
            is_tni INTEGER,
            start_date TEXT,
            end_date TEXT,
            price REAL
            trainer_id INTEGER,
            FOREIGN KEY (trainer_id) REFERENCES trainer (id) ON DELETE SET NULL
          )
        ''');
        //tabel harga
        db.execute('''
          CREATE TABLE prices (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            member_price REAL,
            pre_registration_price REAL
          )
        ''');
        //tabel diskon tni
        db.execute('''
          CREATE TABLE discounts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tni_discount REAL
          )
        ''');
        db.execute('''
          CREATE TABLE trainer (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            photo BLOB,
            name TEXT,
            phone_number TEXT,
            price REAL
          )
        ''');
      },
      version: 1,
    );
  }

  // Pastikan database sudah diinisialisasi sebelum digunakan
  Future<Database> get database async {
    if (_database == null) {
      await initDB(); // Memanggil initDB jika _database masih null
    }
    return _database!; // Menggunakan '!' untuk memastikan bahwa _database bukan null
  }

  // Menambahkan harga dasar ke tabel prices
  Future<void> insertPrices(double memberPrice, double preRegistrationPrice,
      double tniDiscount) async {
    final db = await database; // Pastikan database sudah diinisialisasi
    await db.insert('prices', {
      'member_price': memberPrice,
      'pre_registration_price': preRegistrationPrice,
    });
    await db.insert('discounts', {
      'tni_discount': tniDiscount,
    });
  }

  // Mengambil harga dari tabel prices dan discounts
  Future<List<Map<String, dynamic>>> getPrices() async {
    final db = await database; // Pastikan database sudah diinisialisasi
    final prices = await db.query('prices');
    final discounts = await db.query('discounts');
    if (prices.isNotEmpty && discounts.isNotEmpty) {
      return [
        {
          'id': prices[0]['id'],
          'member_price': prices[0]['member_price'],
          'pre_registration_price': prices[0]['pre_registration_price'],
          'tni_discount': discounts[0]['tni_discount'],
        }
      ];
    }
    return [];
  }

  // Memperbarui harga
  Future<void> updatePrices({
    required int id,
    required double memberPrice,
    required double preRegistrationPrice,
    required double tniDiscount,
  }) async {
    final db = await database; // Pastikan database sudah diinisialisasi
    await db.update(
      'prices',
      {
        'member_price': memberPrice,
        'pre_registration_price': preRegistrationPrice,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    await db.update(
      'discounts',
      {
        'tni_discount': tniDiscount,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Hapus harga
  Future<void> deletePrices(int id) async {
    final db = await database; // Pastikan database sudah diinisialisasi
    await db.delete('prices', where: 'id = ?', whereArgs: [id]);
    await db.delete('discounts', where: 'id = ?', whereArgs: [id]);
  }

  // Menambahkan member baru dengan perhitungan harga
  Future<void> insertMember({
    required String name,
    required String phoneNumber,
    required int isPreRegistration,
    required int isTni,
    required String startDate,
    required String endDate,
    Uint8List? photo,
    int? trainerId
  }) async {
    final db = await database; // Pastikan database sudah diinisialisasi

    // Ambil harga dari tabel
    final prices = await db.query('prices');
    final discounts = await db.query('discounts');

    double finalPrice;

    // Tentukan harga berdasarkan status pra-pendaftar dan TNI
    if (isPreRegistration == 1) {
      finalPrice = prices[0]['pre_registration_price'] as double;
    } else {
      finalPrice = prices[0]['member_price'] as double;
    }

    // Jika anggota TNI, berikan diskon
    if (isTni == 1) {
      final discount = discounts[0]['tni_discount'] as double;
      finalPrice -= discount;
    }

    // Masukkan data member baru
    await db.insert('members', {
      'name': name,
      'phone_number': phoneNumber,
      'is_pre_registration': isPreRegistration,
      'is_tni': isTni,
      'start_date': startDate,
      'end_date': endDate,
      'price': finalPrice,
      'photo': photo,
      'trainer_id': trainerId,
    });
  }

  // Mengambil semua member
  Future<List<Map<String, dynamic>>> getMembers() async {
    final db = await database; // Pastikan database sudah diinisialisasi
    return await db.query('members');
  }

  // Update data member
  Future<void> updateMember({
    required int id,
    required String name,
    required String phoneNumber,
    required int isPreRegistration,
    required int isTni,
    required String startDate,
    required String endDate,
    Uint8List? photo,
  }) async {
    final db = await database; // Pastikan database sudah diinisialisasi
    await db.update(
      'members',
      {
        'name': name,
        'phone_number': phoneNumber,
        'is_pre_registration': isPreRegistration,
        'is_tni': isTni,
        'start_date': startDate,
        'end_date': endDate,
        'photo': photo,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Hapus member
  Future<void> deleteMember(int id) async {
    final db = await database; // Pastikan database sudah diinisialisasi
    await db.delete('members', where: 'id = ?', whereArgs: [id]);
  }

  // Menutup koneksi database
  Future<void> close() async {
    final db = await database; // Pastikan database sudah diinisialisasi
    await db.close();
  }
  
  // Update data trainer
  Future<void> updateTrainer({
    required int id,
    required String name,
    required String phoneNumber,
    required double price,
    Uint8List? photo,
  }) async {
    final db = await database; // Pastikan database sudah diinisialisasi
    await db.update(
      'trainer',
      {
        'name': name,
        'phone_number': phoneNumber,
        'price': price,
        'photo': photo,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Hapus trainer
  Future<void> deleteTrainer(int id) async {
    final db = await database; // Pastikan database sudah diinisialisasi
    await db.delete('trainer', where: 'id = ?', whereArgs: [id]);
  }

  // Mengambil semua trainer
  Future<List<Map<String, dynamic>>> getTrainers() async {
    final db = await database; // Pastikan database sudah diinisialisasi
    return await db.query('trainer');
  }

}
