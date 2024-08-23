import 'package:flutter/material.dart';

class Active_member extends StatelessWidget {
  const Active_member({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.group,
                color: const Color.fromARGB(255, 129, 129, 129),
              ),
              Text(
                "Member Aktif",
                style: TextStyle(fontSize: 15),
              ),
              Text(
                "Agustus:100",
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            child: Text("Detail"),
          )
        ],
      ),
    );
  }
}

class Total_member extends StatelessWidget {
  const Total_member({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.groups_2,
                color: const Color.fromARGB(255, 129, 129, 129),
              ),
              Text(
                "Total Member",
                style: TextStyle(fontSize: 15),
              ),
              Text(
                "1000",
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: CustomPaint(
                  size: Size(50, 50),
                  painter: CircleChartPainter(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CircleChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = Colors.blue;

    canvas.drawCircle(Offset(radius, radius), radius, paint);

    // Menambahkan bagian grafik (misalnya, 25%)
    Paint progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = Colors.green
      ..strokeCap = StrokeCap.round;

    double sweepAngle = 0.25 * 3.14159 * 2; // 25% dari 360 derajat
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      -3.14159 / 2, // Mulai dari atas
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class Newmember extends StatelessWidget {
  const Newmember({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 315,
      height: 150,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.group_add,
                  color: const Color.fromARGB(255, 129, 129, 129)),
              SizedBox(
                width: 10,
              ),
              Text("Member Baru")
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Table(
            border: TableBorder.all(),
            columnWidths: {
              0: FlexColumnWidth(),
              1: FixedColumnWidth(120),
              2: FixedColumnWidth(80),
            },
            children: [
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Nama"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Periode'),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Putra'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('1 Januari - 1 Februari'),
                ),
              ])
            ],
          )
        ],
      ),
    );
  }
}
