import 'package:flutter/material.dart';

class Language extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Language> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: const Color(0xffbe3e57),
            title: Text('Language'),
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
              padding: EdgeInsets.only(left: 100, right: 100, top: 20),
              child: Image(
                  height: 200,
                  width: 200,
                  image: AssetImage('assets/images/myHelper.png'))),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              'Please select your language',
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: const Color(0xffbe3e57),
                child: Text('English', style: TextStyle(color: Colors.white)),
                onPressed: () {},
              ),
            ),
          )
        ]),
      ),
    );
  }
}
