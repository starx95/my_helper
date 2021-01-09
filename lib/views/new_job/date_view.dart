import 'package:flutter/material.dart';
import 'package:my_helper/models/Trip.dart';
import 'wages.dart';
 
class NewJobDateView extends StatelessWidget {
  final Trip job;
  NewJobDateView({Key key, @required this.job}) :super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Post New Job - Date'),
          
        ),
        body: Center(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Name ${job.title}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Enter a Start Date"),
              ]
            ),
            RaisedButton(
              child: Text("Continue"),
              onPressed: () {
                job.startDate = DateTime.now();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewJobWagesView(job: job)),
                  );
              },
            )
        ],
      )
        ,) 
       
    );
  }
}