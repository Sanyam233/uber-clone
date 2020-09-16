import 'package:flutter/material.dart';
import 'package:uberapp1/screens/profile/profile_screen.dart';
import 'package:uberapp1/theme/app_theme.dart';

class AppDrawer extends StatelessWidget {

  final signedInUserData;

  const AppDrawer(this.signedInUserData);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 240,
            color: AppTheme.primaryColor,
            child: Column(
              children: [
                SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                      return ProfileScreen(signedInUserData);
                    }));

                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.red,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          signedInUserData['username'],
                          style: TextStyle(
                              color: AppTheme.appBackgroundColor, fontSize: 28),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 1),
                      bottom: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Messages',
                        style: TextStyle(
                            fontSize: 20, color: AppTheme.appBackgroundColor),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          color: AppTheme.appBackgroundColor, size: 20),
                    ],
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: Text(
              'Your Trips',
              style: TextStyle(fontSize: 22, color: AppTheme.primaryColor),
            ),
          ),
          ListTile(
            leading: Text(
              'Wallet',
              style: TextStyle(fontSize: 22, color: AppTheme.primaryColor),
            ),
          ),
          ListTile(
            leading: Text(
              'Help',
              style: TextStyle(fontSize: 22, color: AppTheme.primaryColor),
            ),
          ),
          ListTile(
            leading: Text(
              'Settings',
              style: TextStyle(fontSize: 22, color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
