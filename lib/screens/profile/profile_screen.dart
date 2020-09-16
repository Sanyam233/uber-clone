import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uberapp1/providers/user_management.dart';
import 'package:uberapp1/screens/profile/local_widgets/profile_data_container.dart';
import 'package:uberapp1/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  final signedInUserData;

  const ProfileScreen(this.signedInUserData);

  @override
  Widget build(BuildContext context) {
    var userManagementProvider = Provider.of<UserManagement>(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: AppTheme.appBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: AppTheme.primaryColor,
                    ),
                    onPressed: () => Navigator.of(context).pop()),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Edit Account',
                    style: TextStyle(
                        fontSize: 30,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                ),
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  child: Icon(Icons.edit),
                  radius: 20,
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: AppTheme.appBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileContainerBuilder(
                    'Username', signedInUserData['username']),
                ProfileContainerBuilder('Phone Number', '123-456-7890'),
                ProfileContainerBuilder('Email', signedInUserData['email']),
                ProfileContainerBuilder('Password', '************'),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          FlatButton(
            onPressed: () {
              return userManagementProvider.logoutUser().then((value) => Navigator.of(context).pop());
            },
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            minWidth: double.infinity,
          )
        ],
      ),
    );
  }
}
