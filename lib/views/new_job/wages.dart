import 'package:flutter/material.dart';
import 'package:my_helper/models/Trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../main.dart';

class NewJobWagesView extends StatefulWidget {
  final Trip job;

  NewJobWagesView({Key key, @required this.job}) : super(key: key);

  @override
  _NewJobWagesViewState createState() => _NewJobWagesViewState();
}

class _NewJobWagesViewState extends State<NewJobWagesView> {
  final db = FirebaseFirestore.instance;
  TextEditingController wagesController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
    _titleController.text = widget.job.title;
    String wages;
    return Scaffold(
        appBar: AppBar(
          title: Text('Post New Job - ${widget.job.title}'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Enter wages"),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextField(
                  controller: wagesController,
                  onChanged: (text) {
                    wages = text;

                    if (wages != '') {}
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Enter a wages in (RM)',
                    focusColor: Colors.red[500],
                    hoverColor: Colors.red[500],
                    fillColor: Colors.red[500],
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[500]),
                    ),
                  ),
                ),
              ),
              RaisedButton(
                child: Text("Finish"),
                onPressed: () async {
                  widget.job.wages =wages;
                  //save data to firebase
                  await db.collection("Jobs").add({
                    'title': widget.job.title,
                    'startDate': widget.job.startDate,
                    'endDate' : widget.job.endDate,
                    'wages' : widget.job.wages,
                    'address' : widget.job.address,
                    'employer' : LoginScreen.email,
                    'image' : LoginScreen.image,
                  });
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              )
            ],
          ),
        ));
  }
}
