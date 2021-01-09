import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' show get;
import 'package:my_helper/views/home_view.dart';
import 'dart:convert';
import 'Job.dart';
import 'Profile.dart';
import 'main.dart';
import 'model.dart';
import 'views/home_view.dart';
import 'package:my_helper/views/new_job/location_view.dart';
import 'package:my_helper/models/Trip.dart';


class Home extends StatefulWidget {
  @override
  _homescreen createState() => _homescreen();
}

class _homescreen extends State<Home> {
    int _selectedIndex = 0;
  List<Job> job = [
     Job(title: 'Bill Will', address: 'img/pic-1.png', desc: "Software Developer"),
     Job(title: 'Andy Smith', address: 'img/pic-2.png', desc: "UI Designer"),
     Job(title: 'Creepy Story', address: 'img/pic-3.png', desc: "Software Tester")
  ];
    List<Widget> _options = <Widget>[
        HomeView(),
        Text('Profile Screen', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
        Text('Settings Screen', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];
  @override
  Widget build(BuildContext context) {
    final newJob = new Trip(null, null, null, null, null);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[500],
        title: Text("Main Screen"),
        actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => NewJobLocationView(job: newJob ))
                );
              },
            )
          ],
      ),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        UserAccountsDrawerHeader(
          accountName:
              Text(LoginScreen.name == '' ? LoginScreen() : LoginScreen.name),
          accountEmail:
              Text(LoginScreen.email == '' ? LoginScreen() : LoginScreen.email),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                ? Colors.blue
                : Colors.white,
            child: Text(
              "N",
              style: TextStyle(fontSize: 40.0),
            ),
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/drawer-image.jpg'),
            ),
          ),
        ),
        ListTile(
          title: Text('Search jobs'),
          onTap: () {
            print(LoginScreen.token);
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Profile'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Profile()));
          },
        ),
        ListTile(
          title: Text('Settings'),
          onTap: () {
            Navigator.pop(context);
          },
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
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: _options.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.teal
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Colors.cyan
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.lightBlue,
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          iconSize: 25,
          onTap: _onItemTap,
          elevation: 5
      ),
      

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
