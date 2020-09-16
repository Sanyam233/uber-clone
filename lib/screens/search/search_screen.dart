import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uberapp1/providers/travel_details.dart';
import 'package:uberapp1/providers/user_management.dart';
import 'package:uberapp1/screens/map/map_screen.dart';
import 'package:uberapp1/theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  final initialPosition;
  final lastVisitedLocation;

  const SearchScreen({this.initialPosition, this.lastVisitedLocation});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  List searchedAddresses = [];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TravelDetails>(context, listen: true);
    var userManagementProvider =
        Provider.of<UserManagement>(context, listen: true);
    searchedAddresses = provider.searchedAddresses;

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.appBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[100],
                  blurRadius: 2.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 3.0),
                ),
              ],
            ),
            height: 250,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60),
                IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppTheme.primaryColor,
                      size: 28,
                    ),
                    onPressed: () => Navigator.of(context).pop()),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, bottom: 5, left: 20, right: 20),
                        color: Colors.grey[200],
                        height: 45,
                        width: double.infinity,
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 18, left: 10),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelText: 'Current Location',
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 5, bottom: 5, left: 20, right: 20),
                        color: Colors.grey[200],
                        height: 45,
                        width: double.infinity,
                        child: TextFormField(
                          onChanged: (text) {
                            provider.getSearchedLocations(text);
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 18, left: 10),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelText: 'Where To?',
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          searchedAddresses.length == 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.location_on,
                        color: AppTheme.primaryColor,
                      ),
                      backgroundColor: Colors.grey[200],
                      radius: 20,
                    ),
                    title: Text(widget.lastVisitedLocation),
                    onTap: () async {},
                  ),
                )
              : Container(
                  height: 400,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: searchedAddresses.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(color: Colors.grey[200], width: 1),
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(
                              Icons.location_on,
                              color: AppTheme.primaryColor,
                            ),
                            backgroundColor: Colors.grey[200],
                            radius: 20,
                          ),
                          title: Text(searchedAddresses[index]['address']),
                          onTap: () async {
                            userManagementProvider.storeUserTravelDestinations(
                                searchedAddresses[index]['address']);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => MapScreen(
                                    initialPosition: widget.initialPosition,
                                    userDestination: searchedAddresses[index]
                                        ['address'],
                                    placeId: searchedAddresses[index]
                                        ['place_id'],
                                    userLongitude: searchedAddresses[index]
                                        ['longitude'],
                                    userLatitude: searchedAddresses[index]
                                        ['latitude'],
                                    placeSelected: true),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
