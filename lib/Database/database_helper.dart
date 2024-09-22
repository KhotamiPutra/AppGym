import 'package:appgym/pages/datatrainer.dart';
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
          price REAL,
          is_active INTEGER DEFAULT 1,  -- Member diatur aktif secara default
          FOREIGN KEY(trainer_id) REFERENCES trainer(id)
        )''');

        // Buat tabel harga
        db.execute('''CREATE TABLE prices (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          member_price REAL,
          pre_registration_price REAL
        )''');

        // Buat tabel diskon TNI
        db.execute('''CREATE TABLE discounts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
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
      onOpen: (db) {
        db.execute('PRAGMA foreign_keys = ON;');
      },
      version: 2,
    );
  }

  // Pastikan database sudah diinisialisasi sebelum digunakan
  Future<Database> get database async {
    if (_database == null) {
      await initDB(); // Memanggil initDB jika _database masih null
    }
    return _database!; // Menggunakan '!' untuk memastikan bahwa _database bukan null
  }

  //CRUD tabel member
  // Menambahkan member baru dengan perhitungan harga
  Future<void> insertMember({
    required String name,
    required String phoneNumber,
    required int isPreRegistration,
    required int isTni,
    required String startDate,
    required String endDate,
    int? trainerId,
    Uint8List? photo,
  }) async {
    final db = await database; // Pastikan database sudah diinisialisasi

    final prices = await getPrices();
    double finalPrice;

    if (prices.isNotEmpty) {
      if (isPreRegistration == 1) {
        finalPrice = prices[0]['pre_registration_price'] as double;
      } else {
        finalPrice = prices[0]['member_price'] as double;
      }

      if (isTni == 1) {
        final double discount = prices[0]['tni_discount'] as double;
        finalPrice -= discount;
      }

      if (trainerId != null) {
        final List<Map<String, dynamic>> trainerData = await db.query(
          'trainer',
          where: 'id = ?',
          whereArgs: [trainerId],
        );
        if (trainerData.isNotEmpty) {
          final double trainerPrice = trainerData[0]['price'] as double;
          finalPrice += trainerPrice;
        } else {
          print('Error: Trainer not found');
        }
      }

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
        'is_active': 1, // Menandakan member baru aktif
      });
      print('Member inserted successfully with price: $finalPrice');
    } else {
      print('Error: Prices not found');
    }
  }

  // Mengambil semua member yang aktif
  Future<List<Map<String, dynamic>>> getActiveMembers() async {
    final db = await database; // Pastikan database sudah diinisialisasi
    final List<Map<String, dynamic>> members = await db.query(
      'members',
      where: 'is_active = ?', // Hanya mengambil member yang aktif
      whereArgs: [1],
    );

    // Mengambil data trainer untuk setiap member
    for (var member in members) {
      if (member['trainer_id'] != null) {
        final trainerData = await db.query(
          'trainer',
          where: 'id = ?',
          whereArgs: [member['trainer_id']],
        );
        member['trainer'] = trainerData.isNotEmpty ? trainerData[0] : null;
      }
    }
    return members;
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
    int? trainerId,
    int? isActive, // Jika ingin mengupdate status aktif/non-aktif
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
        'trainer_id': trainerId,
        if (isActive != null) 'is_active': isActive, // Hanya mengupdate jika isActive tidak null
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Menonaktifkan member (logika untuk soft delete)
  Future<void> deactivateMember(int id) async {
    final db = await database; // Pastikan database sudah diinisialisasi
    await db.update(
      'members',
      {
        'is_active': 0, // Menandakan member non-aktif
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
//============================================

  // Menambahkan harga dasar ke tabel prices dan discounts
  Future<void> insertPrices(double memberPrice, double preRegistrationPrice,
      double tniDiscount) async {
    final db = await database; // Pastikan database sudah diinisialisasi
    await db.transaction((txn) async {
      try {
        await txn.insert('prices', {
          'member_price': memberPrice,
          'pre_registration_price': preRegistrationPrice,
        });
        await txn.insert('discounts', {
          'tni_discount': tniDiscount,
        });
        print('Prices inserted successfully');
      } catch (e) {
        print('Error inserting prices: $e');
      }
    });
  }

  //CRUD Harga
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
  // ===========================================

  //CRUD tabel trainer
  // Menambahkan trainer
  Future<void> insertTrainer(Trainer newTrainer, {
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
//Mengambil Semua Trainer
Future<List<Map<String, dynamic>>> getAllTrainers() async {
  final db = await database;
  return await db.query('trainer');
}

//update
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
//Menghapus Trainer
Future<void> deleteTrainer(int id) async {
  final db = await database;
  await db.delete('trainer', where: 'id = ?', whereArgs: [id]);
}
// ===========================================


  // Menutup koneksi database
  Future<void> close() async {
    final db = await database; // Pastikan database sudah diinisialisasi
    await db.close();
  }
}
