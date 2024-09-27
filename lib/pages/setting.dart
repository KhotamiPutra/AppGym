import 'package:appgym/Database/database_helper.dart';
import 'package:flutter/material.dart';

class PriceSettingPage extends StatefulWidget {
  @override
  _PriceSettingPageState createState() => _PriceSettingPageState();
}

class _PriceSettingPageState extends State<PriceSettingPage> {
  final DBHelper _dbHelper = DBHelper();
  final TextEditingController _memberPriceController = TextEditingController();
  final TextEditingController _preRegistrationPriceController = TextEditingController();
  final TextEditingController _tniDiscountController = TextEditingController();
  bool _isUpdating = false;
  int? _priceId;

  @override
  void initState() {
    super.initState();
    _dbHelper.initDB();
    _loadPrices();
  }

  // Fungsi untuk memuat data harga dari database
  Future<void> _loadPrices() async {
    final prices = await _dbHelper.getAllPrices();  // Mengambil semua data harga
    if (prices.isNotEmpty) {
      setState(() {
        _isUpdating = true;
        _priceId = prices[0]['id'];
        _memberPriceController.text = prices[0]['member_price'].toString();
        _preRegistrationPriceController.text = prices[0]['pre_registration_price'].toString();
        _tniDiscountController.text = prices[0]['tni_discount'].toString();
      });
    }
  }

  // Fungsi untuk menambahkan atau memperbarui harga
  Future<void> _savePrices() async {
    final memberPrice = double.tryParse(_memberPriceController.text);
    final preRegistrationPrice = double.tryParse(_preRegistrationPriceController.text);
    final tniDiscount = double.tryParse(_tniDiscountController.text);

    if (memberPrice == null || preRegistrationPrice == null || tniDiscount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Masukkan nilai yang valid')),
      );
      return;
    }

    if (_isUpdating && _priceId != null) {
      // Perbarui harga
      await _dbHelper.updatePrice(
        id: _priceId!,
        memberPrice: memberPrice,
        preRegistrationPrice: preRegistrationPrice,
        tniDiscount: tniDiscount,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harga berhasil diperbarui')),
      );
    } else {
      // Tambahkan harga baru
      await _dbHelper.insertPrice(
        memberPrice: memberPrice,
        preRegistrationPrice: preRegistrationPrice,
        tniDiscount: tniDiscount,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harga berhasil disimpan')),
      );
    }

    _loadPrices(); // Muat ulang data setelah menyimpan atau memperbarui
  }

  // Fungsi untuk menghapus harga
  Future<void> _deletePrices() async {
    if (_priceId != null) {
      await showConfirmationDialog(
        context,
        'Hapus Harga',
        'Apakah kamu yakin ingin menghapus harga ini?',
        () async {
          await _dbHelper.deletePrice(_priceId!);
          _memberPriceController.clear();
          _preRegistrationPriceController.clear();
          _tniDiscountController.clear();
          setState(() {
            _isUpdating = false;
            _priceId = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Harga berhasil dihapus')),
          );
        },
      );
    }
  }

  // Fungsi untuk menampilkan dialog konfirmasi
  Future<void> showConfirmationDialog(BuildContext context, String title,
      String message, VoidCallback onConfirm) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dialog tidak bisa ditutup dengan mengklik di luar
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog tanpa melakukan aksi
              },
            ),
            TextButton(
              child: Text('Konfirmasi'),
              onPressed: () {
                onConfirm(); // Panggil fungsi konfirmasi
                Navigator.of(context).pop(); // Tutup dialog setelah konfirmasi
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan Harga'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _memberPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Harga Member',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _preRegistrationPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Harga Pra-Pendaftar',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _tniDiscountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Diskon TNI',
              ),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _savePrices,
                  child: Text(_isUpdating ? 'Perbarui' : 'Simpan'),
                ),
                ElevatedButton(
                  onPressed: _deletePrices,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    'Hapus',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _memberPriceController.dispose();
    _preRegistrationPriceController.dispose();
    _tniDiscountController.dispose();
    super.dispose();
  }
}
