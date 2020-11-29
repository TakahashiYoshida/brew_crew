import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth=FirebaseAuth.instance;

  CustomUser _userFromFirebaseUser(User user){
    return user!=null ? CustomUser(uid:user.uid) : null;
  }

  Stream<CustomUser> get user{
    return _auth.authStateChanges()
    // .map((User user) => _userFromFirebaseUser(user));
    .map(_userFromFirebaseUser);
  }

  Future signInAnon() async{
      try{
        UserCredential result= await _auth.signInAnonymously();
        User user=result.user;
        return _userFromFirebaseUser(user);
      }catch(e){
        print(e.toString());
        return null;
      }
  }

  Future signInWithEmailAndPassword(String email,String passward)async{
    try{
      UserCredential result=await _auth.signInWithEmailAndPassword(email: email, password: passward);
      User user=result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  Future registerWithEmailAndPassword(String email,String passward)async{
    try{
      UserCredential result=await _auth.createUserWithEmailAndPassword(email: email, password: passward);
      User user=result.user;

      await DatabaseService(uid:user.uid).updateUserData("0", "new crew member", 100);
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  Future signOut()async{
    try {
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}