import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'Profile.dart';
import 'main.dart';



class Home extends StatefulWidget {
  @override
  _homescreen createState() => _homescreen();
}

class _homescreen extends State<Home> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[500],
        title: Text("Main Screen"),
      ),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          UserAccountsDrawerHeader(
            
            accountName: Text(LoginScreen.name == null ? LoginScreen()  :  LoginScreen.name),
            accountEmail: Text(LoginScreen.email == null ? LoginScreen() : LoginScreen.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.iOS
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
            Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Profile()));
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
        child: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [Text('Home Screen')],
              )),
        ),
      ),
    );
  }

  void _onLogout() async {
            LoginScreen.name = await FlutterSession().set('name','');
            LoginScreen.email = await FlutterSession().set('email','');
           
              Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
            
  }
}