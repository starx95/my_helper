import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_helper/main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:math';
import 'package:my_helper/views/job_detail.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

/// An indicator showing the currently selected page of a PageController
class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: const Color(0xffbe3e57),
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: const Color(0xffbe3e57),
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}

class _HomeViewState extends State<HomeView> {
  dynamic data;
  String title = "";
  bool count = true;
  int no = 0;
  List<Placemark> placemark;
  List<Placemark> placemarkR;
  final controller = PageController(viewportFraction: 1);

  var db;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: CustomSliverDelegate(
                expandedHeight: 120,
              ),
            ),
            SliverFillRemaining(
              child: Column(children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: 100,
                    child: SizedBox(
                      child: PageView(
                        controller: controller,
                        children: <Widget>[
                          Center(
                            child: Row(children: <Widget>[
                              GestureDetector(
                                  child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 40.0,
                                    right: 20.0,
                                  ),
                                  child: ImageIcon(
                                    AssetImage('assets/icons/salon.png'),
                                    color: Colors.orange[900],
                                    size: 50.0,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      left: 40.0,
                                      right: 20.0,
                                    ),
                                    child: Text("Beauty"))
                              ])),
                              GestureDetector(
                                  child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                  ),
                                  child: ImageIcon(
                                    AssetImage('assets/icons/catering.png'),
                                    color: Colors.orange[900],
                                    size: 50.0,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                    ),
                                    child: Text("Catering"))
                              ])),
                              GestureDetector(
                                  child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                  ),
                                  child: ImageIcon(
                                    AssetImage(
                                        'assets/icons/washing-machine.png'),
                                    color: Colors.orange[900],
                                    size: 50.0,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                    ),
                                    child: Text("Dobi"))
                              ])),
                              GestureDetector(
                                  child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 40.0,
                                  ),
                                  child: ImageIcon(
                                    AssetImage('assets/icons/household.png'),
                                    color: Colors.orange[900],
                                    size: 50.0,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 40.0,
                                    ),
                                    child: Text("Cleaning"))
                              ])),
                            ]),
                          ),
                          Center(
                            child: Row(children: <Widget>[
                              GestureDetector(
                                  child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 40.0,
                                    right: 20.0,
                                  ),
                                  child: ImageIcon(
                                    AssetImage('assets/icons/sewing.png'),
                                    color: Colors.orange[900],
                                    size: 50.0,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      left: 40.0,
                                      right: 20.0,
                                    ),
                                    child: Text("Tailoring"))
                              ])),
                              GestureDetector(
                                  child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: ImageIcon(
                                    AssetImage('assets/icons/plumbing.png'),
                                    color: Colors.orange[900],
                                    size: 50.0,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                    ),
                                    child: Text("Plumbing"))
                              ])),
                              GestureDetector(
                                  child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 30.0,
                                  ),
                                  child: ImageIcon(
                                    AssetImage('assets/icons/nurse.png'),
                                    color: Colors.orange[900],
                                    size: 50.0,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 30.0,
                                    ),
                                    child: Text("Homecare"))
                              ])),
                              GestureDetector(
                                  child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 20.0,
                                  ),
                                  child: ImageIcon(
                                    AssetImage('assets/icons/moving-truck.png'),
                                    color: Colors.orange[900],
                                    size: 50.0,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 20.0,
                                    ),
                                    child: Text("Mover"))
                              ])),
                            ]),
                          ),
                          Center(
                            child: Row(children: <Widget>[
                              GestureDetector(
                                  child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 40.0,
                                    right: 20.0,
                                  ),
                                  child: ImageIcon(
                                    AssetImage('assets/icons/knitting.png'),
                                    color: Colors.orange[900],
                                    size: 50.0,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      left: 40.0,
                                      right: 20.0,
                                    ),
                                    child: Text("Crafts"))
                              ])),
                              GestureDetector(
                                  child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: ImageIcon(
                                    AssetImage('assets/icons/massage.png'),
                                    color: Colors.orange[900],
                                    size: 50.0,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 15.0,
                                    ),
                                    child: Text("Massage"))
                              ])),
                              GestureDetector(
                                  child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 20.0,
                                  ),
                                  child: ImageIcon(
                                    AssetImage('assets/icons/street-food.png'),
                                    color: Colors.orange[900],
                                    size: 50.0,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                    ),
                                    child: Text("Street food"))
                              ])),
                              GestureDetector(
                                  child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                  ),
                                  child: ImageIcon(
                                    AssetImage('assets/icons/group.png'),
                                    color: Colors.orange[900],
                                    size: 50.0,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                    ),
                                    child: Text("Runner"))
                              ])),
                            ]),
                          ),
                          Center(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  GestureDetector(
                                      child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 10.0,
                                      ),
                                      child: ImageIcon(
                                        AssetImage('assets/icons/planner.png'),
                                        color: Colors.orange[900],
                                        size: 50.0,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 10.0,
                                        ),
                                        child: Text("Event\n manager",
                                            textAlign: TextAlign.center))
                                  ])),
                                  GestureDetector(
                                      child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10.0,
                                      ),
                                      child: ImageIcon(
                                        AssetImage(
                                            'assets/icons/graphic-designer.png'),
                                        color: Colors.orange[900],
                                        size: 50.0,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10.0,
                                        ),
                                        child: Text("Graphic\nDesigner",
                                            textAlign: TextAlign.center))
                                  ])),
                                  GestureDetector(
                                      child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10.0,
                                      ),
                                      child: ImageIcon(
                                        AssetImage(
                                            'assets/icons/microscope.png'),
                                        color: Colors.orange[900],
                                        size: 50.0,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10.0,
                                        ),
                                        child: Text("Research\nAssitant"))
                                  ])),
                                  GestureDetector(
                                      child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 20.0,
                                      ),
                                      child: ImageIcon(
                                        AssetImage('assets/icons/list.png'),
                                        color: Colors.orange[900],
                                        size: 50.0,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 20.0,
                                        ),
                                        child: Text("Others"))
                                  ])),
                                ]),
                          ),
                        ],
                      ),
                    )),
                Center(
                    child: Container(
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: 4,
                    effect: WormEffect(
                        dotWidth: 9.0,
                        dotHeight: 9.0,
                        dotColor: Colors.grey,
                        activeDotColor: const Color(0xffbe3e57)),
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text('MyHelper Recommended', style: TextStyle(fontSize: 20)),
                ]),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Jobs")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(
                          child: Text("Loading Please wait..."),
                        );

                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot job = snapshot.data.docs[index];
                            return SingleChildScrollView(
                                child: GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                JobDetail(job: job))),
                                    child: Card(
                                      color: const Color(0xffbe3e57),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: MemoryImage(
                                              base64.decode(job['image'])),
                                        ),
                                        title: Row(
                                          children: [
                                            Text(
                                              job["title"],
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                job["address"],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )));
                          });
                    }),
              ]),
            ),
          ],
        ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.search),
            backgroundColor: const Color(0xffbe3e57),
            onPressed: () {}));
  }
}

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;

  CustomSliverDelegate({
    @required this.expandedHeight,
    this.hideTitleWhenExpanded = true,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = expandedHeight - shrinkOffset;
    final cardTopPosition = expandedHeight / 2 - shrinkOffset;
    final proportion = 2 - (expandedHeight / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
    return SizedBox(
      height: expandedHeight + expandedHeight / 2,
      child: Stack(
        children: [
          SizedBox(
            height: appBarSize < kToolbarHeight ? kToolbarHeight : appBarSize,
            child: AppBar(
              backgroundColor: const Color(0xffbe3e57),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              elevation: 0.0,
              title: Center(child: Text("MyHelper")),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: cardTopPosition > 0 ? cardTopPosition : 0,
            bottom: 0.0,
            child: Opacity(
              opacity: percent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20 * percent),
                child: Card(
                  elevation: 20.0,
                  child: Center(
                    child: ListTile(
                      title: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Icon(Icons.account_circle_outlined,
                                color: Colors.orange[900]),
                          ),
                          Flexible(
                            child: Text(
                              LoginScreen.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          right: 10.0,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(Icons.location_on_outlined,
                                  color: Colors.orange[900]),
                            ),
                            Container(
                              width: 250,
                              child: Text(
                                LoginScreen.address,
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight + expandedHeight / 2;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
