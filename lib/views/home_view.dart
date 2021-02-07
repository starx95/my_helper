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
    this.color: Colors.redAccent,
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
          color: Colors.pink[800],
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
  final controller = PageController(viewportFraction: 0.8);

  var db;

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.8;
    return Container(
      child: Padding(
          padding: const EdgeInsets.all(0.5),
          child: Scaffold(
              backgroundColor: Colors.grey[200],
              body: Center(
                  child: Column(children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Card(
                    child: ListTile(
                  leading: CircleAvatar(
                    radius: 30.0,
                    backgroundImage:
                        MemoryImage(base64.decode(LoginScreen.image)),
                  ),
                  title: Row(
                    children: [
                      Icon(Icons.account_circle, color: Colors.pink[600]),
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
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.pink[600]),
                        Flexible(child: Text(
                          LoginScreen.address,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),)
                        
                      ],
                    ),
                  ),
                )),
                SizedBox(height: 20),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          child: Container(
                            child: PageView(
                              controller: controller,
                              children: List.generate(
                                3,
                                (_) => Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        GestureDetector(
                                            child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.auto_fix_high,
                                              color: Colors.pink[800],
                                              size: 60.0,
                                            ),
                                          ),
                                          Text("Beauty")
                                        ])),
                                        GestureDetector(
                                            child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.food_bank,
                                              color: Colors.pink[800],
                                              size: 60.0,
                                            ),
                                          ),
                                          Text("Catering")
                                        ])),
                                        GestureDetector(
                                            child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.local_laundry_service,
                                              color: Colors.pink[800],
                                              size: 60.0,
                                            ),
                                          ),
                                          Text("Dobi")
                                        ])),
                                        GestureDetector(
                                            child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.cleaning_services,
                                              color: Colors.pink[800],
                                              size: 60.0,
                                            ),
                                          ),
                                          Text("Cleaning")
                                        ])),
                                      ]),
                                ),
                              ),
                            ),
                          )),
                    ]),
                Center(
                    child: Container(
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: 3,
                    effect: WormEffect(
                        dotWidth: 9.0,
                        dotHeight: 9.0,
                        dotColor: Colors.grey,
                        activeDotColor: Colors.pink[800]),
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
                                child: _getRegisteredAddress() ==
                                        _getAddress(job["address"])
                                    ? null
                                    : GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    JobDetail(job: job))),
                                        child: Card(
                                          color: Colors.pink[800],
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )));
                          });
                    }),
              ])),
              floatingActionButton: new FloatingActionButton(
                  elevation: 0.0,
                  child: new Icon(Icons.search),
                  backgroundColor: Colors.pink[800],
                  onPressed: () {}))),
    );
  }

  _getAddress(address) async {
    // placemark = await Geolocator().placemarkFromAddress(address);
    // print(placemark[0].postalCode);
    // return placemark[0].postalCode;
  }

  _getRegisteredAddress() async {
    // List<Placemark> placemarkR =
    //     await Geolocator().placemarkFromAddress(LoginScreen.address);
    // print(placemarkR[0].postalCode);
    // return placemarkR[0].postalCode;
  }
}
