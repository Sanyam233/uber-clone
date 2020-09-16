import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uberapp1/theme/app_theme.dart';

class UserManagement with ChangeNotifier {

  final _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  Map<String, dynamic> signedinUserDetails;
  var lastVisitedLocation = '';

  //Snackbar to display any error messages while logining the user
  _snackBar(String _errorMessage, BuildContext context) {
    return Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        _errorMessage,
        style: TextStyle(
          color: AppTheme.primaryColor,
        ),
      ),
      backgroundColor: AppTheme.appBackgroundColor,
    ));
  }

  //Autheticates the user and then helps them login or signin 
  Future<void> authenticate(BuildContext context,
      {String username = '',
      String email,
      String password,
      bool isLogin}) async {
    UserCredential _authResult;

    try {
      if (isLogin == true) {
        _authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        _authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        FirebaseFirestore.instance
            .collection('users')
            .doc(_authResult.user.uid)
            .set({'username': "${username[0].toUpperCase()}${username.substring(1)}", 'email': email});
      }
    } on PlatformException catch (err) {
      var _errorMessage = 'Invalid credentials! Please re-enter';
      if (err.message != null) {
        _errorMessage = err.message;
      }
      _snackBar(_errorMessage, context);
    } catch (err) {
      print(err.message);
      _snackBar(err.message, context);
    }
  }

  //function to logout the user
  Future<void> logoutUser() async{

    if(FirebaseAuth.instance.currentUser != null){
      return FirebaseAuth.instance.signOut();
    }
  }

  //gets user data such as their email and username once user log's in
  Future<void> getUserData() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        var userDetails = await firestoreInstance
            .collection('users')
            .doc(_auth.currentUser.uid)
            .get();

        signedinUserDetails = userDetails.data();

        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  //Stores all the addresses that the user has visited 
  Future<void> storeUserTravelDestinations(String destination) {
    try {
      String id = DateTime.now().millisecondsSinceEpoch.toString();

      print(id);

      if (FirebaseAuth.instance.currentUser != null) {
        FirebaseFirestore.instance
            .collection('destinations')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .set({id: destination}, SetOptions(merge: true));
      }
    } catch (e) {
      print(e);
    }
  }

  //function to grab the last visited address by the user
  Future<void> getLastVistedLocation() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {

        var locationDetails = await firestoreInstance
            .collection('destinations')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .get();

        var locationDetailsList = locationDetails.data().values;

        lastVisitedLocation = locationDetailsList.elementAt(locationDetailsList.length - 1);

        print(lastVisitedLocation);

        notifyListeners();

      }
    } catch (e) {
      print(e);
    }
  }


}
