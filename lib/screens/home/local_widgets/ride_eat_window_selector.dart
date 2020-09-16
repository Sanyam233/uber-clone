
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uberapp1/screens/search/search_screen.dart';

class RideEatWindowSelector extends StatelessWidget {
  final LatLng initialPosition;
  final IconData icon;
  final int windowIndexNumber;
  final double iconSize;
  final lastVisitedLocation;

  const RideEatWindowSelector(
      {this.initialPosition, this.icon, this.windowIndexNumber, this.iconSize, this.lastVisitedLocation});

  //Naviagtes the user to either uber rides or uber eats
  void _screenSelector(int windowIndexNumber, BuildContext context) async {
    final selectionData = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => SearchScreen(
          initialPosition: initialPosition,
          lastVisitedLocation: lastVisitedLocation,
        ),
      ),
    );
    if (selectionData == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _screenSelector(windowIndexNumber, context),
      child: Container(
        height: double.infinity,
        child: Icon(icon, size: iconSize),
      ),
    );
  }
}
