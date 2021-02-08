import 'package:flutter/material.dart';

class Safety extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xffbe3e57),
            title: Text('Safety'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            )),
        body: Column(children: [
          Padding(
            padding: EdgeInsets.only(top: 20,left:20),
            child: 
              Text(
                'Shake your mobile phone to quickly send an alert to your emergency contact',
                textAlign: TextAlign.left,
              )
          ),
          Padding(
            padding: EdgeInsets.only(top: 30,right:250),
            child: 
              Text(
                'Emergency Contact',
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold),
              )
          ),
          Padding(
            padding: EdgeInsets.only(left:20,right:20),
            child: 
              TextFormField(
                decoration: InputDecoration(labelText: 'Name',),
              )
          ),
          Padding(
            padding: EdgeInsets.only(top: 20,left:20,right:20),
            child: 
              TextFormField(
                 decoration: InputDecoration(labelText: 'Contact Number',),
              )
          ),
        ]),
      ),
    );
  }
}
