import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:xkcd_mobx/mobx/xkcd.dart';
import 'package:xkcd_mobx/ui/nav_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final XkcdService store = XkcdService();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  DateFormat formatter = DateFormat('yMMMd');

  @override
  void initState() {
    getMainComic();
    super.initState();
  }

  getMainComic() async {
    await store.getTodayComic();
  }

  @override
  Widget build(BuildContext context) {
    // print(" main build func called");
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black87,
      endDrawer: DrawerWidget(),
      body: Container(
        child: Observer(
          builder: (context) {
            if (store.isMainComicLoading) {
              return Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: Lottie.asset('assets/loading.json',
                    height: 120, width: 120),
              );
            } else {
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          onPressed: () async {
                            // print(" button Pressed");
                            await store.getNumberedComic(
                                store.comic.getComicNumber, "up");
                          },
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              // print(_scaffoldKey.currentState.hasAppBar);
                              _scaffoldKey.currentState.openEndDrawer();
                            },
                            child: Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.black87,
                    child: Column(
                      children: [
                        Text(
                          "#${store.comic.getComicNumber}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          "${formatter.format(DateTime.parse(store.comic.getComicDate))}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        Container(
                          // color: Colors.white,
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "${store.comic.getComicTitle}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 28.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.40,
                          child: InteractiveViewer(
                            child: Image.network(
                              "${store.comic.getComicUrl}",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.18,
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                          child: Center(
                            child: Text(
                              "${store.comic.getComicAlt}",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            onPressed: () async {
                              // print(" button Pressed");
                              await store.getNumberedComic(
                                  store.comic.getComicNumber - 1, "down");
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}