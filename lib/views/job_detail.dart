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
    final String employer = widget.job.get('employer');
    final String address = widget.job.get('address');
    final String image = widget.job.get('image');
    final String wages = widget.job.get('wages');
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.pink[700],
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
                  height: 250,
                  child: Card(
                      child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                    ),
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage: MemoryImage(base64.decode(image)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_circle, color: Colors.pink[600]),
                        Text(
                          employer,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: Colors.pink[600]),
                        Flexible(
                            child: Text(
                          address,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.attach_money, color: Colors.pink[600]),
                        Text(
                          "Payment: RM " + wages,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    FlatButton.icon(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: Colors.pink[500],
                        textColor: Colors.white,
                        label: Text("Accept"),
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () async {
                          //save data to firebase
                          await db
                              .collection("Jobs")
                              .doc(employer)
                              .update({
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
