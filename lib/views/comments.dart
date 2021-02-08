import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffbe3e57),
          title: Text('Rating'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          automaticallyImplyLeading: true,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Row(children: [
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
                                style: TextStyle(fontWeight: FontWeight.bold))
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
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                        )),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
