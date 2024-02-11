import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final String USER_COLLECTION='user';
final String POSTS='posts';

class FirebaseService{
  FirebaseAuth _auth=FirebaseAuth.instance;
  FirebaseStorage _store=FirebaseStorage.instance;
  FirebaseFirestore _db=FirebaseFirestore.instance;
  Map? curUser;

  FirebaseService();

  Future<bool> registerUser({required String name, required String email, required String password,required File image}) async{
    try{
      UserCredential _userCredential=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      String _userId=_userCredential.user!.uid;
      String _fileName=Timestamp.now().microsecondsSinceEpoch.toString() + p.extension(image.path);
      UploadTask _task= _store.ref("images/$_userId/$_fileName").putFile(image);
      return _task.then((_snapshot) async{
        String _downloadURL=await _snapshot.ref.getDownloadURL();
        await _db.collection(USER_COLLECTION).doc(_userId).set({
          "name":name,
          "email":email,
          "image":_downloadURL
        });
        return true;
      });
    }catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> loginuser({required String email, required String password}) async{
    try {
      UserCredential _userCredential=await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(_userCredential.user!=null){
        curUser=await getUserData(uid: _userCredential.user!.uid);
        return true;
      }else{
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map> getUserData({required String uid}) async{
    DocumentSnapshot _doc=await _db.collection(USER_COLLECTION).doc(uid).get();
    return _doc.data() as Map;
  }

  Future<bool> postImage(File _image) async{
    try{
      String _userId=_auth.currentUser!.uid;
      String _fileName=Timestamp.now().microsecondsSinceEpoch.toString()+p.extension(_image.path);
      UploadTask _task=_store.ref("images/$_userId/$_fileName").putFile(_image);
      return await _task.then((_snapshot) async{
        String _downloadURL=await _snapshot.ref.getDownloadURL();
        await _db.collection(POSTS).add({
          "userId":_userId,
          "timestamp":Timestamp.now(),
          "image":_downloadURL
        });
        return true;
      });
    }catch(e){
      print(e);
      return false;
    }
  }

  Stream<QuerySnapshot> getPostforUser(){
    String _userID=_auth.currentUser!.uid;
    return _db.collection(POSTS).where("userId",isEqualTo: _userID).snapshots();
  }

  Stream<QuerySnapshot> getPosts(){
    return _db.collection(POSTS).orderBy("timestamp",descending: true).snapshots();
  }

  Future<void> logout() async{
    await _auth.signOut();
  }
}