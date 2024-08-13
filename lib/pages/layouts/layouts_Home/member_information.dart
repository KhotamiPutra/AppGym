import 'package:flutter/material.dart';

class active_member extends StatelessWidget {
  const active_member({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
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
                style: TextStyle(fontSize: 20),
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
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            child: Text("Detail"),
          )
        ],
      ),
    );
  }
}

class total_member extends StatelessWidget {
  const total_member({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
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
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "1000",
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
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            child: Text("Detail"),
          )
        ],
      ),
    );
  }
}
