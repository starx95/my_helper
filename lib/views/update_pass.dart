import 'package:flutter/material.dart';

class UpdatePass extends StatefulWidget {
  @override
  _UpdatePassState createState() => _UpdatePassState();
}

class _UpdatePassState extends State<UpdatePass> {
  bool _isnotVisible = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: const Color(0xffbe3e57),
            title: Text('Update Password'),
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
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 12,left: 12, right: 12),
                  child: Text(
                    'Your password should be obscure and must be at least 8 characters long. In addition, you must put at least one number and one character and one uppercase letter within the first 8 characters of your password.',
                    style: TextStyle(fontFamily: 'Roboto',fontSize: 15,),
                    textAlign: TextAlign.center,
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 8,left: 12, right: 12),
                child: TextFormField(
                  decoration: InputDecoration(
                          labelText: 'Old Password',
                          icon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isnotVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isnotVisible = !_isnotVisible;
                              });
                            },
                          ))
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8,left: 12, right: 12),
                child: TextFormField(
                  decoration: InputDecoration(labelText: "New password",
                  icon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isnotVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isnotVisible = !_isnotVisible;
                              });
                            },
                          )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8,left: 12, right: 12),
                child: TextFormField(
                  decoration: InputDecoration(labelText: "Confirm password",
                  icon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isnotVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isnotVisible = !_isnotVisible;
                              });
                            },
                          )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8,left: 12, right: 12),
                child: ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                      color: const Color(0xffbe3e57),
                      onPressed: () => {},
                      child: Text(
                        "UPDATE",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
