import 'package:flutter/material.dart';
import 'package:my_helper/models/Trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


 
class NewJobWagesView extends StatelessWidget {
  final db = Firestore.instance;
  final Trip job;
  NewJobWagesView({Key key, @required this.job}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
    _titleController.text = job.title;
    return Scaffold(
        appBar: AppBar(
          title: Text('Post New Job - Wages'),
          
        ),
        body: Center(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Finish"),
            Text("Job Name: ${job.title}"),
            Text("Job Date: ${job.startDate}"),
            

            RaisedButton(
              child: Text("Finish"),
              onPressed: () async {
                //save data to firebase
                await db.collection("Jobs").add(
                  {
                  'title': job.title,
                  'startDate': job.startDate,
                  }
                );
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            )
        ],
      )
        ,) 
       
    );
  }
}