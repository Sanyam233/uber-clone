import 'package:flutter/material.dart';
import 'package:uberapp1/theme/app_theme.dart';

class ProfileContainerBuilder extends StatelessWidget{

  final String title; final String dataInput;

  const ProfileContainerBuilder(this.title, this.dataInput); 

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            dataInput,
            style: TextStyle(
              fontSize: 20,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}