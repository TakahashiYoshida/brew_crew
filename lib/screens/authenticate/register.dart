import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth=AuthService();
  final _formKey=GlobalKey<FormState>();
  bool loading=false;

  String email="";
  String passward="";
  String error="";

  @override
  Widget build(BuildContext context) {
    return loading?Loading():Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0,
        title: Text("sign up to brew crew"),
        actions: [
          FlatButton.icon(onPressed: (){
            widget.toggleView();
          }, icon: Icon(Icons.person), label: Text("Sign in"))
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Email"),
                  validator: (val){
                    return val.isEmpty?"Enter an email":null;
                  },
                  onChanged: (val){
                    setState(()=>email=val);
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Password"),
                  obscureText: true,
                  validator: (val){
                    return val.length<6?"Enter a password 6+ chars long":null;
                  },
                  onChanged: (val){
                    setState(()=>passward=val);
                  },
                ),
                SizedBox(height: 20,),
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: ()async{
                    if(_formKey.currentState.validate()){
                      setState(() {
                        loading=true;
                      });
                      dynamic result=await _auth.registerWithEmailAndPassword(email, passward);
                      if(result==null){
                        setState(() {
                          error="please supply a valid email";
                          loading=false;
                        });
                      }
                    }
                    },
                ),
                SizedBox(height: 12,),
                Text(
                  error,
                  style: TextStyle(color: Colors.red,fontSize: 14),
                ),
              ],
            ),
          )
      ),
    );
  }
}
