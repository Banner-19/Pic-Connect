import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/firebase_service.dart';

class RegisterPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends  State<RegisterPage>{
  double? _dheight,_dwidth;
  FirebaseService? _firebaseService;
  final GlobalKey<FormState> _registerkey=GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _password;
  File? _img;

  @override
  void initState() {
    super.initState();
    _firebaseService=GetIt.instance.get<FirebaseService>();
  }


  @override
  Widget build(BuildContext context) {
    _dheight= MediaQuery.of(context).size.height;
    _dwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: _dwidth!*0.05),
          color:const Color.fromRGBO(245, 238, 230, 1.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _title(),
                _profileImage(),
                _registerForm(),
                _registerBtn(),
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

  Widget _profileImage(){
    var _imgProvider=_img!=null ? FileImage(_img!) 
    : const NetworkImage("https://t4.ftcdn.net/jpg/02/83/72/41/360_F_283724163_kIWm6DfeFN0zhm8Pc0xelROcxxbAiEFI.jpg");
    return GestureDetector(
      onTap: () {
        FilePicker.platform.pickFiles(
          type: FileType.image
        ).then((_value){
          setState(() {
            _img=File(_value!.files.first.path!);
          });
        });
      },
      child: Container(
        height: _dheight!*0.10,
        width: _dheight!*0.10,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: _imgProvider as ImageProvider,
          ),
          borderRadius: BorderRadius.circular(80),
        ),
      ),
    );
  }
//https://i.pravatar.cc/300
  Widget _registerForm(){
    return Container(
      height: _dheight!*0.30,
      child: Form(
        key: _registerkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _nameField(),
            _emailField(),
            _passwordField(),
          ],
        ),
      ),
    );
  }

  Widget _nameField(){
    return  TextFormField(
      decoration:const  InputDecoration(
        hintText: "Name"
      ),
      onSaved: (_value){
        setState(() {
          _name=_value;
        });
      },
      validator: (_value) =>  _value!.isEmpty ? "Please enter your name." : null,
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

  Widget _registerBtn(){
    return MaterialButton(
      onPressed: _registerUser,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color:const Color.fromRGBO(255, 104, 104 ,1.0),
      minWidth: _dwidth!*0.50,
      height: _dheight!*0.06,
      elevation: _dheight!*0.02,
      child: const Text("Register",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w200,
        ),
      ),
    );
  }
  
  void _registerUser() async{
    if(_registerkey.currentState!.validate() && _img!=null){
      _registerkey.currentState!.save();
      bool _result= await _firebaseService!.registerUser(name: _name!, email: _email!, password: _password!, image: _img!);
      if(_result) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }
  }
}