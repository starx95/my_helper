import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_helper/main.dart';
import 'package:toast/toast.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:image_picker/image_picker.dart';
 
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var name = TextEditingController();
  var phone = TextEditingController();
  var address = TextEditingController();
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  File _fimage;
  final _pick = ImagePicker();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = LoginScreen.name;
    phone.text = LoginScreen.email;
    address.text = LoginScreen.address;
  }

  Future _getImage() async {
    final pickedfile = await _pick.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedfile != null) {
        _fimage = File(pickedfile.path);
      } else {
        print('No image selected.');
      }
    });
    
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
  tmpFile = _fimage;
  base64Image = base64Encode(_fimage.readAsBytesSync());
  print(_fimage);
  setStatus('Uploading Image...');
  if (null == tmpFile) {
    setStatus(errMessage);
    return;
  }
  String fileName = tmpFile.path.split('/').last;
  upload(fileName);
}
 
upload(String fileName) {
  print("test "+base64Image);
  http.post('http://stiw2044.atwebpages.com/ProfileImage/uploadimage.php', body: {
    "image": base64Image,
    "name": fileName,
    "phone": LoginScreen.email,
  }).then((result) {
    print(result);
    setStatus(result.statusCode == 200 ? result.body : errMessage);
  }).catchError((error) {
    setStatus(error);
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[500],
          
          title: Text('Profile'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: _getImage,
                  child: CircleAvatar(
                radius: 70,
                backgroundImage: _fimage == null ? null:FileImage(_fimage),
                
            ),),
                TextFormField(controller: name, 
                  decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: new TextStyle(
                    color: Colors.red[500],
                  ),
                    ),
                    enabled: true,
                  ),
                  TextFormField(controller: phone, 
                  decoration: InputDecoration(
                  labelText: 'Phone',
                  labelStyle: new TextStyle(
                    color: Colors.red[500],
                  ),
                    ),
                    enabled: true,
                  ),
                  TextFormField(controller: address, 
                  decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: new TextStyle(
                    color: Colors.red[500],
                  ),
                    ),
                    enabled: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  MaterialButton(
                    child: Text("SAVE"), 
                    onPressed: () => startUpload(),
                    color: Colors.red[500],)

              ]), )
              ,
            ),
          );
  }

void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

}