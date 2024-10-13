import 'package:flutter/material.dart';

class VisitorPage extends StatefulWidget {
  const VisitorPage({super.key});

  @override
  State<VisitorPage> createState() => _VisitorPageState();
}

class _VisitorPageState extends State<VisitorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(labelText: 'Nama'),
                ),
                const SizedBox(height: 10),
                const TextField(
                  readOnly: true,
                  decoration: InputDecoration(hintText: 'Harga'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Handle the save action here
                  },
                  child: const Text('Simpan'),
                ),
                const Row(
                  children: [
                    Icon(Icons.history),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Riwayat Visitor"),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
