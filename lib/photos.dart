import 'package:developer_test/albums.dart';
import 'package:developer_test/http/http.dart';
import 'package:developer_test/models/photo.dart';
import 'package:flutter/material.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage(this.title, {Key? key}) : super(key: key);
  final String title;
  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  List<Photo> data = [];

  @override
  void initState() {
    super.initState();

    getRequest<List<dynamic>>("photos").then((value) {
      List<Photo> temp =
          value.sublist(0, 20).map((e) => Photo.fromJson(e)).toList();
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
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
          FloatingActionButtonLocation.startTop, -8, 42),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Image.asset(
          "assets/back.png",
          width: 30,
          height: 30,
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            "assets/photo_bg.png",
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.width / 375 * 225 - 30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 14,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    Flexible(
                        child: Text(
                      "Total photos count (${data.length})",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ))
                  ],
                ),
                Expanded(child: PhotoGrid(data)),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.width / 375 * 225 - 60),
            child: PhotosTitleView(widget.title),
          ),
        ],
      ),
    );
  }
}

class PhotoGrid extends StatelessWidget {
  const PhotoGrid(this.data, {Key? key}) : super(key: key);
  final List<Photo> data;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: GridView.builder(
        itemCount: data.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 13,
          crossAxisSpacing: 13,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(data[index].thumbnailUrl ?? ""),
          );
        },
      ),
    );
  }
}

class PhotosTitleView extends StatelessWidget {
  const PhotosTitleView(this.title, {Key? key}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 16,
        ),
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Container(
          alignment: Alignment.center,
          width: 61,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF484C5B),
          ),
          child: const Text(
            "Albums",
            style: TextStyle(
                color: Color(0xFFB4B8C7),
                fontSize: 12,
                fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
      ],
    );
  }
}
