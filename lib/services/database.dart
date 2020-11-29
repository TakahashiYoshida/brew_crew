import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference brewCollection=FirebaseFirestore.instance.collection("brews");

  Future updateUserData(String sugars,String name,int strength)async{
    return await brewCollection.doc(uid).set({
      "sugars":sugars,
      "name":name,
      "strength":strength,
    });
  }

  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((e) => Brew(
      name: e.data()["name"] ?? "",
      sugars: e.data()["sugars"] ?? "0",
      strength: e.data()["strength"] ?? 0,

    )).toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name: snapshot.data()["name"],
      sugars: snapshot.data()["sugars"],
      strength: snapshot.data()["strength"],
    );
  }

  Stream<List<Brew>> get brews{
    return brewCollection.snapshots()
    .map(_brewListFromSnapshot);
  }

  Stream<UserData> get userData{
    return brewCollection.doc(uid).snapshots()
    .map(_userDataFromSnapshot);
  }

}