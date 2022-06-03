import 'dart:math';

import 'package:developer_test/http/http.dart';
import 'package:developer_test/models/album.dart';
import 'package:developer_test/photos.dart';
import 'package:flutter/material.dart';

class AlbumsPage extends StatefulWidget {
  const AlbumsPage(this.name, this.email, {Key? key}) : super(key: key);
  final String name;
  final String email;
  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  bool showList = true;

  List<Album> data = [];

  @override
  void initState() {
    super.initState();

    getRequest<List<dynamic>>("albums").then((value) {
      List<Album> temp = value.map((e) => Album.fromJson(e)).toList();
      if (mounted) {
        setState(() {
          data = temp;
        });
      }
    });
  }

  void onTapCell(BuildContext context, int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
      return PhotosPage(data[index].title ?? "");
    })));
  }

  void changeShowList(bool show) {
    setState(() {
      showList = show;
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
            "assets/alnums_bg.png",
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.width / 375 * 123),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(
              children: [
                const SizedBox(
                  height: 53,
                ),
                AlbumsCountView(data.length),
                const SizedBox(
                  height: 26,
                ),
                AlbumsTitleView((show) {
                  changeShowList(show);
                }),
                Expanded(
                  child: AlbumsListView(
                    data,
                    showList,
                    onTap: (index) {
                      onTapCell(context, index);
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.width / 375 * 123 - 26),
            child: UserInfoView(widget.name, widget.email),
          ),
        ],
      ),
    );
  }
}

class AlbumsListView extends StatefulWidget {
  const AlbumsListView(this.data, this.show, {required this.onTap, Key? key})
      : super(key: key);
  final bool show;
  final List<Album> data;
  final Function(int) onTap;
  @override
  State<AlbumsListView> createState() => _AlbumsListViewState();
}

class _AlbumsListViewState extends State<AlbumsListView> {
  double get opacity {
    return widget.show ? 1.0 : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 1.0, end: opacity),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: ListView.builder(
            itemCount: widget.data.length,
            itemBuilder: (itemBuilder, index) {
              return AlbumsCell(
                widget.data[index].title ?? "",
                onTap: () {
                  if (widget.show) {
                    widget.onTap(index);
                  }
                },
              );
            },
          ),
        );
      },
      duration: const Duration(milliseconds: 500),
    );
  }
}

class AlbumsCell extends StatelessWidget {
  const AlbumsCell(this.title, {this.onTap, Key? key}) : super(key: key);
  final String title;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.fromLTRB(12, 5, 12, 5),
        child: Row(
          children: [
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Image.asset("assets/ponit.png"),
            const SizedBox(
              width: 11,
            )
          ],
        ),
      ),
    );
  }
}

class AlbumsTitleView extends StatefulWidget {
  const AlbumsTitleView(this.open, {Key? key}) : super(key: key);

  final Function(bool) open;

  @override
  State<AlbumsTitleView> createState() => _AlbumsTitleViewState();
}

class _AlbumsTitleViewState extends State<AlbumsTitleView> {
  double angle = 0;

  changeOpen() {
    double temp = 0.0;
    if (angle == 0) {
      temp = -pi / 2;
      widget.open(false);
    } else {
      temp = 0;
      widget.open(true);
    }
    setState(() {
      angle = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 12,
        ),
        const Expanded(
          child: Text(
            "Albums",
            style: TextStyle(
              color: Color(0xFF464646),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const Spacer(),
        TweenAnimationBuilder(
            tween: Tween(begin: 0.0, end: angle),
            duration: const Duration(milliseconds: 500),
            builder: (buildContext, double i, child) {
              return Transform.rotate(
                angle: i,
                child: IconButton(
                  onPressed: () {
                    changeOpen();
                  },
                  icon: Image.asset("assets/more.png"),
                ),
              );
            }),
        const SizedBox(
          width: 6,
        )
      ],
    );
  }
}

class AlbumsCountView extends StatelessWidget {
  const AlbumsCountView(this.count, {Key? key}) : super(key: key);
  final int count;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 60,
          child: Text(
            "$count",
            style: const TextStyle(
              color: Color(0xFF2D2C2C),
              fontSize: 48,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: 101,
          height: 27,
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFEF),
            borderRadius: BorderRadius.circular(13.5),
          ),
          child: const Text(
            "Total Albums",
            style: TextStyle(
              color: Color(0xFF8D8D8D),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }
}

class UserInfoView extends StatelessWidget {
  const UserInfoView(this.name, this.email, {Key? key}) : super(key: key);
  final String name;
  final String email;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Row(
        children: [
          const SizedBox(
            width: 28,
          ),
          Image.asset(
            "assets/user.png",
            fit: BoxFit.fill,
            width: 72,
            height: 72,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF2D2C2C),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  email,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFA4A4A4),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 3,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX;
  double offsetY;
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
