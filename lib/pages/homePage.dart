import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:picconnect/pages/feedPage.dart';
import 'package:picconnect/pages/profilePage.dart';
import 'package:picconnect/services/firebase_service.dart';

class HomePage extends StatefulWidget{
  HomePage();

  @override
  State<StatefulWidget> createState() {
   return _HomePageState();
  }
}

class _HomePageState extends  State<HomePage>{
  FirebaseService? _firebaseService;

  int _curidx=0;
  final List<Widget> _pages=[
    FeedPage(),
    ProfilePage(),
  ];

  _HomePageState();

  @override
  void initState() {
    super.initState();
    _firebaseService=GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: _pages[_curidx],
      ),
      appBar: AppBar(
        title: const Text("Pic Connect",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _postImage,
            child:  const Icon(
              Icons.add_a_photo,
              color: Colors.white,
            ),
          ),
          Padding(
            padding:const EdgeInsets.only(left:8.0,right: 8.0),
            child: GestureDetector(
              onTap: ()async{
                await _firebaseService!.logout();
                // ignore: use_build_context_synchronously
                Navigator.popAndPushNamed(context, "login");
              },
              child: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          )
        ],
        backgroundColor:const Color.fromRGBO(255, 104, 104, 1.0),
      ),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  void _postImage() async{
    FilePickerResult? _result= await FilePicker.platform.pickFiles(type: FileType.image);
    File _image=File(_result!.files.first.path!);
    await _firebaseService!.postImage(_image);
  }

  Widget _bottomNavBar(){
    return BottomNavigationBar(
      fixedColor: const Color.fromRGBO(255, 104, 104, 1.0),
      backgroundColor:const Color.fromRGBO(245, 238, 230,1.0),
      currentIndex: _curidx,
      onTap: (_idx) {
        setState(() {
          _curidx = _idx;
        });
      },
      items:const [
        BottomNavigationBarItem(
          label: 'Feed',
          icon: Icon(
            Icons.feed,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(
            Icons.account_box,
          )
        )
      ],
    );
  }
}
// Container(
//           color:const Color.fromRGBO(255, 248, 227, 1.0),
//         ),