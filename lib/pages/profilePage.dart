import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:picconnect/services/firebase_service.dart';

class ProfilePage extends StatefulWidget{
  ProfilePage();

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class  _ProfilePageState extends State<ProfilePage>{
  double? _dheight,_dwidth;
  FirebaseService? _firebaseService;

  _ProfilePageState();

  @override
  void initState() {
    super.initState();
    _firebaseService=GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _dheight=MediaQuery.of(context).size.height;
    _dwidth=MediaQuery.of(context).size.width;
    return Container(
      height: _dheight!,
      width: _dwidth!,
      padding: EdgeInsets.symmetric(vertical: _dheight!*0.02,horizontal: _dwidth!*0.05),
      color:const Color.fromRGBO(255, 248, 227, 1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profileImage(),
            _profileUserName(),
            SizedBox(height: _dheight! * 0.01),
            _postGridView(),
          ],
        ),
    );
  }

  Widget _profileImage(){
    return Container(
      margin: EdgeInsets.only(bottom: _dheight!*0.02),
      height: _dheight!*0.15,
      width: _dheight!*0.15,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            _firebaseService!.curUser!["image"],
          ),
        ),
        borderRadius: BorderRadius.circular(100)
      ),
    );
  }

  Widget _profileUserName(){
    return Text(_firebaseService!.curUser!["name"],
      style:const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400
      ),
    );
  }

  Widget _postGridView(){
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firebaseService!.getPostforUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List _posts = snapshot.data!.docs.map((e) => e.data()).toList();
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                ),
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  Map _post = _posts[index];
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          _post["image"],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }
}