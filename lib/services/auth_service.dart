import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Login Method
Future<User?> login({required String email, required String password}) async {
  try{
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }
  catch (e) {
    print('Login error: $e');
    rethrow;
  }
}


//Register method
Future<User?> register({required String email, required String password}) async {
  try{
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }catch(e) {
    print('Registration Failed : $e');
    rethrow;
  }
}


//Logout Method
Future<void> logout() async {
  await
   _auth.signOut();
  print('DEBUG: USER LOGGED OUT SUCCESSFULLY!');
}


//Getter for current user
User? get currentUser => _auth.currentUser;

}