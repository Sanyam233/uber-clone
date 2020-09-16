
import 'package:flutter/material.dart';
import 'package:uberapp1/theme/app_theme.dart';

class UberAppBar extends StatelessWidget {
  const UberAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: EdgeInsets.only(bottom: 20, left: 20),
          color: Colors.blue,
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Try Local Favourites',
                style: TextStyle(
                    color: AppTheme.appBackgroundColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Local restaurants are open and delivering Uber Eats',
                style: TextStyle(
                  color: AppTheme.appBackgroundColor,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 30,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppTheme.primaryColor),
                child: Text(
                  'Order Now',
                  style: TextStyle(
                    color: AppTheme.appBackgroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}