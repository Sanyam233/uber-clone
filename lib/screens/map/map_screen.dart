import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uberapp1/helpers/location_helper.dart';
import 'package:uberapp1/providers/travel_details.dart';
import 'package:uberapp1/providers/uber_rides.dart';
import 'package:uberapp1/screens/search/search_screen.dart';
import 'package:uberapp1/theme/app_theme.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/MapScreen';
  final initialPosition;
  final userDestination;
  final placeId;
  final placeSelected;
  final userLongitude;
  final userLatitude;

  const MapScreen(
      {this.initialPosition,
      this.userDestination,
      this.placeId,
      this.placeSelected,
      this.userLongitude,
      this.userLatitude});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _markers = [];
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String _dropOffTime = '';
  double _uberAmount = 0.0;
  List<UberRides> _uberRides = [];
  String _uberName = '';
  final PanelController _panelController = PanelController();

  @override
  void initState() {
    super.initState();
    if (widget.placeSelected == true) {
      _markers.add(
        Marker(
          markerId: MarkerId('marker'),
          draggable: true,
          position: (LatLng(widget.userLatitude, widget.userLongitude)),
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.userLatitude != null) {
      _moveToMarkerLocation();
      _travelDetails();
      _getPolyline();
    }
  }

  //controller for the map
  void _onMapComplete(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
    });
  }

  //moves the marker to the current user location 
  void _moveToMarkerLocation() async {
    GoogleMapController currentLocationController = await _controller.future;

    currentLocationController.animateCamera(
      CameraUpdate.newLatLngZoom(
          LatLng(widget.userLatitude, widget.userLongitude), 8),
    );
  }

  //add polylines from the current user location to user's destination
  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        width: 4,
        color: AppTheme.primaryColor,
        points: polylineCoordinates);

    polylines[id] = polyline;
    setState(() {});
  }
 
  ListTile _listTileBuilder(
      String uberType, String dropoffTime, bool uberSelected, String price) {
    return ListTile(
      tileColor: uberSelected == false ? Colors.white : Colors.grey[200],
      leading: Icon(
        Icons.local_taxi,
        size: 34,
        color: AppTheme.primaryColor,
      ),
      title: Text(uberType,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      subtitle: Row(
        children: [
          Text(dropoffTime, style: TextStyle(fontSize: 16)),
          SizedBox(width: 10),
          uberSelected == true
              ? Text('dropoff', style: TextStyle(fontSize: 16))
              : Text('')
        ],
      ),
      trailing: Text(price,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  //gets the polyline details for the user 
  _getPolyline() async {
    PointLatLng _initalPosition = PointLatLng(
        widget.initialPosition.latitude, widget.initialPosition.longitude);
    PointLatLng _destinationPosition =
        PointLatLng(widget.userLatitude, widget.userLongitude);

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPI,
        PointLatLng(_initalPosition.latitude, _initalPosition.longitude),
        PointLatLng(
            _destinationPosition.latitude, _destinationPosition.longitude),
        travelMode: TravelMode.driving);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  //get's the travel details for the user 
  void _travelDetails() {
    var travelDetailsProvider =
        Provider.of<TravelDetails>(context, listen: false);
    travelDetailsProvider.getTravelDetails(
        widget.initialPosition.latitude,
        widget.initialPosition.longitude,
        widget.userLatitude,
        widget.userLongitude);
  }

  @override
  Widget build(BuildContext context) {
    _uberRides = Provider.of<TravelDetails>(context, listen: false).uberOptions;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: GoogleMap(
              onTap: (LatLng points) {
                if (_panelController.isPanelOpen) {
                  _panelController.close();
                }
              },
              zoomGesturesEnabled: true,
              polylines: Set<Polyline>.of(polylines.values),
              markers: Set.from(_markers),
              mapType: MapType.normal,
              onMapCreated: _onMapComplete,
              compassEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: widget.initialPosition, zoom: 16),
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 35.0, left: 10),
                child: FloatingActionButton(
                  child: Icon(
                    Icons.arrow_back,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                  backgroundColor: AppTheme.appBackgroundColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  heroTag: null,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, right: 10),
                    child: FloatingActionButton(
                      heroTag: null,
                      backgroundColor: AppTheme.appBackgroundColor,
                      onPressed: () async {
                        GoogleMapController currentLocationController =
                            await _controller.future;
                        currentLocationController.animateCamera(
                          CameraUpdate.newLatLngZoom(widget.initialPosition,
                              widget.placeSelected == true ? 8 : 16),
                        );
                      },
                      child: Icon(
                        Icons.location_searching,
                        size: 28,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (widget.placeSelected != true)
                    Container(
                      height: 90,
                      color: AppTheme.appBackgroundColor,
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () async {
                          final selectionData =
                              await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => SearchScreen(
                                initialPosition: widget.initialPosition,
                              ),
                            ),
                          );

                          if (selectionData == null) {
                            return;
                          }
                        },
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.only(top : 8.0),
                            child: Text(
                              'Where To?',
                              style: TextStyle(
                                  fontSize: 22, color: AppTheme.primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (widget.placeSelected == true)
                    SlidingUpPanel(
                      defaultPanelState: PanelState.OPEN,
                      controller: _panelController,
                      maxHeight: 400,
                      color: AppTheme.appBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      panel: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Container(
                              height: 300,
                              width: double.infinity,
                              child: ListView.builder(
                                itemCount: _uberRides.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var _uberIndex = _uberRides[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: GestureDetector(
                                      onTap: () {

                                        setState(() {
                                          for (int i = 0;
                                              i < _uberRides.length;
                                              i++) {
                                            _uberRides[i].isSelected = false;
                                          }
                                          _uberIndex.isSelected = true;
                                          _uberName = _uberIndex.uberType;
                                        });
                                      },
                                      child: _listTileBuilder(
                                          _uberIndex.uberType,
                                          _uberIndex.dropoffTime,
                                          _uberIndex.isSelected,
                                          '\$${_uberIndex.price}'),
                                    ),
                                  );
                                },
                              ),
                            ),
                            FlatButton(
                              height: 50,
                              minWidth: 200,
                              color: AppTheme.primaryColor,
                              onPressed: () {},
                              child: Text(
                                'Confirm $_uberName',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.appBackgroundColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
