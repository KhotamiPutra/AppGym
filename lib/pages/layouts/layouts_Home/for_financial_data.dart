import 'package:flutter/material.dart';

class monthly_turnover extends StatelessWidget {
  const monthly_turnover({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.green[600],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 5,
          ),
          Icon(
            Icons.attach_money,
            color: Colors.white,
            size: 50,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Omset Bulanan",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "Rp. 1.000.000",
                style: TextStyle(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}


class monthly_expenses extends StatelessWidget {
  const monthly_expenses({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                    width: 250,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.monetization_on_outlined,
                          color: Colors.white,
                          size: 50,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Pendapatan Bulanan",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Rp. 1.000.000",
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // List untuk menyimpan inputan yang bisa bertambah
                                    List<Widget> inputFields = [
                                      _buildInputField(),
                                    ];

                                    return StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return AlertDialog(
                                          title: Text('Masukkan Pengeluaran'),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ...inputFields, // Menampilkan semua inputan
                                                SizedBox(height: 10),
                                                TextButton(
                                                  onPressed: () {
                                                    // Menambahkan input baru ke dalam daftar
                                                    setState(() {
                                                      inputFields.add(
                                                          _buildInputField());
                                                    });
                                                  },
                                                  child:
                                                      Text('Tambah Inputan +'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Menutup dialog
                                              },
                                              child: Text('Tutup'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Lakukan sesuatu dengan inputan yang diberikan
                                              },
                                              child: Text('Simpan'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              child: Text(
                                "Cek Detail",
                                style: TextStyle(
                                  color: Color.fromARGB(134, 255, 255, 255),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
  }
}
 Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Masukkan Pengeluaran',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }


class profit extends StatelessWidget {
  const profit({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                    width: 250,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.trending_up,
                          color: Colors.white,
                          size: 50,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Keuntungan Bulan Ini",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Rp. 1.000.000",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
  }
}