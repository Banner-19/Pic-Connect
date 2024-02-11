import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/firebase_service.dart';

class FeedPage extends StatefulWidget{
  FeedPage();

  @override
  State<StatefulWidget> createState() {
    return _FeedPageState();
  }
}

class  _FeedPageState extends State<FeedPage>{
  FirebaseService? _firebaseServices;

  double? _dheight,_dwidth;
  _FeedPageState();

  @override
  void initState() {
    super.initState();
    _firebaseServices=GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _dheight=MediaQuery.of(context).size.height;
    _dwidth=MediaQuery.of(context).size.width;
    return Container(
      height: _dheight!,
      width: _dwidth!,
      color:const Color.fromRGBO(255, 248, 227, 1.0),
      child: _postList(),
    );
  }

  Widget _postList(){
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseServices!.getPosts(), 
      builder: (BuildContext _context,AsyncSnapshot _snapshot){
        if(_snapshot.hasData){
          List _posts=_snapshot.data!.docs.map((e)=>e.data()).toList();
          print(_posts);
          return ListView.builder(
            itemCount: _posts.length,
            itemBuilder: (BuildContext context,int index) {
              Map _post=_posts[index];
              return Container(
                height: _dheight!*0.25,
                margin: EdgeInsets.symmetric(horizontal: _dwidth!*0.04,vertical: _dheight!*0.01),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(_post["image"],
                    ),
                  )
                ),
              );
            },
          );
        }
        else{
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}