import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:uberapp1/helpers/location_helper.dart';
import 'package:uberapp1/providers/user_management.dart';
import 'package:uberapp1/screens/home/local_widgets/ride_eat_window_selector.dart';
import 'package:uberapp1/screens/home/local_widgets/saved_places.dart';
import 'package:uberapp1/screens/map/map_screen.dart';
import 'package:uberapp1/theme/app_theme.dart';
import 'package:uberapp1/widgets/app_drawer.dart';
import 'package:uberapp1/widgets/uber_app_bar.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomePage';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //Variables declared and intialized for the home page 
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  static LatLng _initialPosition;
  String previewImage;
  Map<String, dynamic> signedInUserData;
  bool _foundLocations = false;
  String _lastVisitedLocation = '';


  //calling the function that will grab the current user location 
  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //grabs the user signedin details
    if (signedInUserData == null) {
      Provider.of<UserManagement>(context).getUserData();
      signedInUserData =
          Provider.of<UserManagement>(context).signedinUserDetails;
    }

    //grabs the last visited location by the user 
    if (_foundLocations == false){

      var userManagementProvider = Provider.of<UserManagement>(context, listen: false);
      userManagementProvider.getLastVistedLocation();
      _foundLocations = true;

    }

  }

  //function to get the current user location 
  void _getUserLocation() async {
    LocationData location = await Location().getLocation();
    setState(() {
      _initialPosition = LatLng(location.latitude, location.longitude);
      previewImage = LocationHelper.generateImage(
          _initialPosition.latitude, _initialPosition.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    //updates the last visited location by the user 
    var userManagementProvider = Provider.of<UserManagement>(context, listen: true);
    _lastVisitedLocation = userManagementProvider.lastVisitedLocation;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      key: _scaffoldKey,
      drawer: AppDrawer(signedInUserData),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            UberAppBar(),
          ];
        },
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
              height: 100,
              color: AppTheme.appBackgroundColor,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RideEatWindowSelector(
                    initialPosition: _initialPosition,
                    icon: Icons.local_taxi,
                    windowIndexNumber: 0,
                    iconSize: 60,
                    lastVisitedLocation : _lastVisitedLocation,
                  ),
                  RideEatWindowSelector(
                    initialPosition: _initialPosition,
                    icon: Icons.fastfood,
                    windowIndexNumber: 1,
                    iconSize: 60,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SavedPlaces(_lastVisitedLocation),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              height: 276,
              color: AppTheme.appBackgroundColor,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Around You',
                      style: TextStyle(
                          fontSize: 20, color: AppTheme.primaryColor)),
                  SizedBox(height: 15),
                  _initialPosition == null
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async { 

                            //when pressed this button it will take the user to MapsScreen
                            final selectionData =
                                await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => MapScreen(
                                  initialPosition: _initialPosition,
                                ),
                              ),
                            );

                            if (selectionData == null) {
                              return;
                            }
                          },
                          child: Container(
                            child: Image.network(previewImage,
                                fit: BoxFit.cover, width: double.infinity),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

