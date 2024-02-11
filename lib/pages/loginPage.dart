import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:picconnect/services/firebase_service.dart';

class LoginPage extends StatefulWidget{
  LoginPage();

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends  State<LoginPage>{
  double? _dheight,_dwidth;
  FirebaseService? _firebaseService;
  final GlobalKey<FormState> _loginkey=GlobalKey<FormState>();
  String? _email;
  String? _password;
  
  @override
  void initState(){
    super.initState();
    _firebaseService=GetIt.instance.get<FirebaseService>();
  }

  _LoginPageState();

  @override
  Widget build(BuildContext context) {
    _dheight= MediaQuery.of(context).size.height;
    _dwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: _dwidth!*0.05),
          color: const Color.fromRGBO(253, 247, 228,1.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _title(),
                _loginForm(),
                _loginBtn(),
                _registerPageBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(){
    return const Text("Pic Connect",
      style: TextStyle(
        color: Colors.black,
        fontSize: 50,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _loginForm(){
    return Container(
      height: _dheight!*0.20,
      child: Form(
        key: _loginkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _emailField(),
            _passwordField(),
          ],
        ),
      ),
    );
  }

  Widget _emailField(){
    return TextFormField(
      decoration:const InputDecoration(
        hintText: "Email",
      ),
      onSaved: (_value) {
        setState(() {
          _email=_value;
        });
      },
      validator: (_value) {
        bool _res=_value!.contains(RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$"));
        return _res ? null : "Please enter a valid email";
      },
    );
  }

  Widget _passwordField(){
    return TextFormField(
      obscureText: true,
      decoration:const InputDecoration(
        hintText: "Password",
      ),
      onSaved: (_value) {
        setState(() {
          _password=_value;
        });
      },
      validator: (_value) =>
        _value!.length>8 ? null : "Please enter a password having 8 or more characters",
    );
  }

  Widget _loginBtn(){
    return MaterialButton(
      onPressed: _loginUser,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color:const Color.fromRGBO(255, 104, 104 ,1.0),
      minWidth: _dwidth!*0.70,
      height: _dheight!*0.06,
      elevation: _dheight!*0.02,
      child: const Text("Login",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w200,
        ),
      ),
    );
  }

  Widget _registerPageBtn(){
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'register'),
      child: const Text("Don't have an account?",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 20,
        ),
      ),
    );
  }

  void _loginUser() async{
    if(_loginkey.currentState!.validate()){
      _loginkey.currentState!.save();
      bool _result=await _firebaseService!.loginuser(email: _email!, password: _password!);
      if(_result){
        if(context.mounted)Navigator.popAndPushNamed(context, 'home');
      }
    }
  }
}