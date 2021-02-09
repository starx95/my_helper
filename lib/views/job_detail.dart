import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_helper/models/Trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_helper/main.dart';

class JobDetail extends StatefulWidget {
  DocumentSnapshot job;

  JobDetail({Key key, @required this.job}) : super(key: key);

  @override
  _JobDetailViewState createState() => _JobDetailViewState();
}

class _JobDetailViewState extends State<JobDetail> {
  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final String title = widget.job.get('title');
    final String employer = widget.job.get('employer email');
    final String address = widget.job.get('address');
    final image = base64Decode(widget.job.get('image'));
    final String wages = widget.job.get('wages');
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xffbe3e57),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            elevation: 0.0,
            title: Text(title),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Center(
            child: Container(
              child: Column(children: [
                Container(
                  height: 480,
                  child: Card(
                      elevation: 10,
                      child: Column(children: [
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 10,
                          height: MediaQuery.of(context).size.height / 3 - 10,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              image: DecorationImage(
                                fit: BoxFit.scaleDown,
                                image: MemoryImage(image),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                Icon(Icons.account_circle,
                                    color: Colors.pink[600]),
                                Padding(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: Text(
                                      employer,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    )),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            child: Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.pink[600]),
                                Flexible(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: Text(
                                          address,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ))),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                Icon(Icons.attach_money,
                                    color: Colors.pink[600]),
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10,),
                                  child: 
                                Text(
                                  "Payment: RM " + wages,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                )),
                              ],
                            )),
                        Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: Row(
                              children: [
                                Icon(Icons.call, color: Colors.pink[600]),
                                Padding(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: Text(
                                      "Phone: " + LoginScreen.phone,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    )),
                              ],
                            )),
                        FlatButton.icon(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            color: Colors.pink[500],
                            textColor: Colors.white,
                            label: Text("Accept"),
                            icon: Icon(Icons.arrow_forward),
                            onPressed: () async {
                              //save data to firebase
                              await db.collection("Jobs").doc(employer).update({
                                'bookedBy': LoginScreen.name,
                              });
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            })
                      ])),
                )
              ]),
            ),
          ),
        ));
  }
}
