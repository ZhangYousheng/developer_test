import 'package:developer_test/albums.dart';
import 'package:developer_test/http/http.dart';
import 'package:developer_test/models/user.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UserPageState();
}

class _UserPageState extends State<UsersPage> {
  List<User> data = [];

  void gotoAlbums(BuildContext context, int index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (builder) =>
            AlbumsPage(data[index].name ?? "", data[index].email ?? "")));
  }

  @override
  void initState() {
    super.initState();
    getRequest<List<dynamic>>("users").then((value) {
      List<User> temp = value.map((e) => User.fromJson(e)).toList();
      if (mounted) {
        setState(() {
          data = temp;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Our Team",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w200,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (buildContext, index) {
          User model = data[index];
          return UserCell(
            model.name ?? "",
            model.email ?? "",
            model.website ?? "",
            onTap: () => {gotoAlbums(context, index)},
          );
        },
      ),
    );
  }
}

class UserCell extends StatelessWidget {
  const UserCell(this.name, this.email, this.website, {this.onTap, Key? key})
      : super(key: key);

  final String name;
  final String email;
  final String website;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        height: 82,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 13,
            ),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(25.0)),
              child: Image.asset(
                "assets/user.png",
                width: 50,
                height: 50,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    email,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Color(0xFF0500FF),
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          website,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Color(0xFFA4A4A4),
                              fontSize: 10,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Image.asset("assets/link.png"),
                    ],
                  ),
                ],
              ),
            ),
            Image.asset("assets/right.png"),
            const SizedBox(
              width: 17.5,
            )
          ],
        ),
      ),
    );
  }
}
