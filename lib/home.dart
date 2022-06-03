import 'package:developer_test/users.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void gotoUsersPage(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (buildContext) => const UsersPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(70, 114, 70, 0),
          child: Image.asset(
            "assets/logo.png",
          ),
        ),
        const SizedBox(
          height: 81,
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.asset(
                "assets/bgbg.png",
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topCenter,
                fit: BoxFit.cover,
              ),
              Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 812 * 227),
                width: 145,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextButton(
                  onPressed: () {
                    gotoUsersPage(context);
                  },
                  child: const Text(
                    "View More！",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF414C48),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
