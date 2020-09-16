import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uberapp1/assists/size_config.dart';
import 'package:uberapp1/providers/travel_details.dart';
import 'package:uberapp1/providers/user_management.dart';
import 'package:uberapp1/screens/authentication/auth.dart';
import 'package:uberapp1/screens/home/home_screen.dart';
import 'package:uberapp1/screens/map/map_screen.dart';
import 'package:uberapp1/screens/search/search_screen.dart';
import 'package:uberapp1/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserManagement()),
        ChangeNotifierProvider(create: (context) => TravelDetails())
      ],
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
          SizeConfig().init(constraints, orientation);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Uber App',
            theme: AppTheme.lightTheme,
            home: StreamBuilder<Object>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                  }
                  if (snapshot.data != null) {
                    return HomeScreen();
                  }
                  return AuthScreen();
                }),
            routes: {
              MapScreen.routeName: (ctx) => MapScreen(),
              HomeScreen.routeName: (ctx) => HomeScreen(),
              SearchScreen.routeName: (ctx) => SearchScreen()
            },
          );
        });
      }),
    );
  }
}
