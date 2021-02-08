import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: const Color(0xffbe3e57),
            title: Text('About Us'),
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
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 100, right: 100,top:20),
              child: Image(
              height: 200,
              width: 200,
              image: AssetImage('assets/images/myHelper.png'))),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'MyHelper is a community-based project that intended to help bottom 40% income classification, particularly on women income issues. This app allows B40 community to participate in supply and demand for short term jobs. Anyone can become worker and employer. Employer can post quick job that they need. Worker can pick up jobs based on their current location radius and earn some money.',
                textAlign: TextAlign.center,
              ),)
          ]
        )
      ),
    );
  }
}