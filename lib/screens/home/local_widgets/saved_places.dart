
import 'package:flutter/material.dart';
import 'package:uberapp1/theme/app_theme.dart';

class SavedPlaces extends StatelessWidget {

  //constructor for SavedPlaces
  const SavedPlaces(this.lastVisitedLocation);
  final lastVisitedLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      color: AppTheme.appBackgroundColor,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 65,
            width: double.infinity,
            margin: EdgeInsets.only(top: 10, left: 15, right: 15),
            padding: EdgeInsets.symmetric(horizontal: 30),
            color: Colors.grey[200],
            child: Row( 
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Text(
                    'Where To?',
                    style: TextStyle(
                        fontSize: 22, color: AppTheme.primaryColor),
                  ),
                ),
                Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppTheme.appBackgroundColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer,
                      ),
                      Text('Now'),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(height: 60,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200], width: 1),
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.watch_later,
                    color: AppTheme.primaryColor),
                radius: 20,
                backgroundColor: Colors.grey[200],
              ),
              title: Text(lastVisitedLocation), //Displays the last visted address by the user 
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.star, color: AppTheme.primaryColor),
              radius: 20,
              backgroundColor: Colors.grey[200],
            ),
            title: Text('Save Places'), // Feature that will display all the saved addresses by the user
          )
        ],
      ),
    );
  }
}