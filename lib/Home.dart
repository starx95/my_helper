import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' show get;
import 'package:my_helper/views/home_view.dart';
import 'package:my_helper/views/new_job/location_view.dart';
import 'dart:convert';
import 'Job.dart';
import 'Profile.dart';
import 'main.dart';
import 'package:my_helper/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model.dart';
import 'models/Trip.dart';
import 'views/home_view.dart';

class Home extends StatefulWidget {
  @override
  _homescreen createState() => _homescreen();
}

class _homescreen extends State<Home> {
  int _selectedIndex = 0;
  final newJob = new Trip(null, null, null, null, null);

  @override
  initState() {}
  List<Widget> _options = <Widget>[
    HomeView(),
    NewJobLocationView(job: null),
    Profile(),
    Text('Settings Screen',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        UserAccountsDrawerHeader(
          accountName:
              Text(LoginScreen.name == null ? LoginScreen() : LoginScreen.name),
          accountEmail: Text(
              LoginScreen.email == null ? LoginScreen() : LoginScreen.email),
          currentAccountPicture: CircleAvatar(
            backgroundImage: MemoryImage(base64.decode(LoginScreen.image)),
            backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                ? Colors.blue
                : Colors.white,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/drawer-image.jpg'),
            ),
          ),
        ),
        ListTile(
          title: Text('Log out'),
          onTap: () {
            _onLogout();
            Navigator.pop(context);
          },
        ),
      ])),
      backgroundColor: Color(0xffFFFFFF),
      body: Container(
        height: (MediaQuery.of(context).size.height),
        width: (MediaQuery.of(context).size.width),
        child: _options.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.pink[700],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Create Job',
              backgroundColor: Colors.pink[700],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.pink[700],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.pink[700],
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          iconSize: 25,
          onTap: _onItemTap,
          elevation: 5),
    );
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onLogout() async {
    LoginScreen.name = await FlutterSession().set('name', '');
    LoginScreen.email = await FlutterSession().set('email', '');

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }
}
