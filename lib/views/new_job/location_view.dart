import 'package:flutter/material.dart';
import 'package:my_helper/models/Trip.dart';
import 'date_view.dart';
 
class NewJobLocationView extends StatelessWidget {
  final Trip job;
  NewJobLocationView({Key key, @required this.job}) :super(key: key);
  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
    _titleController.text = job.title;
    return Scaffold(
        appBar: AppBar(
          title: Text('Post New Job - name'),
          
        ),
        body: Center(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Enter A new job "),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
              controller: _titleController,
              autofocus: true,
            ),
            ),
            RaisedButton(
              child: Text("Continue"),
              onPressed: () {
                job.title =_titleController.text;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewJobDateView(job: job)),
                  );
              },
            )
        ],
      )
        ,) 
       
    );
  }
}