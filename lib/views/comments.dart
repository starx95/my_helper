import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Comments extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Comments> {
  int num = 0;
  var _ratingController = TextEditingController();
  double _rating;
  int _ratingBarMode = 1;
  bool _isRTLMode = false;
  bool _isVertical = false;
  IconData _selectedIcon;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffbe3e57),
          title: Center(child:Text('Rating')),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          automaticallyImplyLeading: true,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(children: [
            Container(
              child: Row(
                children: [
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 2 - 10,
                    child: Card(
                      elevation: 5,
                      child: Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: Column(children: [
                            Text('As Employee',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 10, left: 10, right: 10),
                              child: SmoothStarRating(
                                color: Colors.orange,
                                borderColor: Colors.orange,
                                rating: 3,
                                size: 20,
                                filledIconData: Icons.star,
                                halfFilledIconData: Icons.star_half,
                                defaultIconData: Icons.star_border,
                                starCount: 5,
                                allowHalfRating: false,
                                spacing: 2.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(num.toString() + ' comments'),
                            )
                          ])),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 2 - 10,
                    child: Card(
                        elevation: 5,
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: Column(children: [
                            Text('As Employer',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 10, left: 10, right: 10),
                              child: SmoothStarRating(
                                color: Colors.orange,
                                borderColor: Colors.orange,
                                rating: 3,
                                size: 20,
                                filledIconData: Icons.star,
                                halfFilledIconData: Icons.star_half,
                                defaultIconData: Icons.star_border,
                                starCount: 5,
                                allowHalfRating: false,
                                spacing: 2.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(num.toString() + ' comments'),
                            )
                          ]),
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10,left: 10),
              child:Row(children: [Text('Comments',style: TextStyle(fontWeight: FontWeight.bold)),],))
          ]),
        ),
      ),
    );
  }
}
