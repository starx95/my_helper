import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
 

  Future<String> createUserWithEmailAndPassword(
    String email, String password, String name) async {
    final currentUser = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: password,
      );

  }

}
