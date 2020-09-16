import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:uberapp1/helpers/location_helper.dart';
import 'package:uberapp1/providers/uber_rides.dart';


class TravelDetails with ChangeNotifier {

  //types of uber rides 
  List<UberRides> uberOptions = [];
  //User's searched addresses
  List searchedAddresses = [];

  //Gets travel details such as time, distance
  void getTravelDetails(var initalLatitude, var intitalLongitude,
      var destinationLatitude, var destinationLongitude) async {
    final url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=$initalLatitude%2C$intitalLongitude&destination=$destinationLatitude%2C$destinationLongitude&mode=driving&avoidHighways=false&avoidFerries=true&avoidTolls=false&key=$googleAPI";
    Response response = await Dio().get(url);

    final predictions = response.data;
    final _detailedPredictions = predictions['routes'][0]['legs'][0];

    uberOptions = uberRide(_detailedPredictions);

    notifyListeners();
  }

  //Sets up the price for Uber rides
  List<UberRides> uberRide(predictions){

    List _durationList =
        predictions['duration']['text'].toString().split(' ');

    var today = DateTime.now();

    var dropoffTime = today.add(Duration(
        hours: int.parse(_durationList[0]),
        minutes: int.parse(_durationList[2])));

    var _dateFormatted = new DateFormat.jm();

    String finalTime = _dateFormatted.format(dropoffTime);

    double kilometers = 1.6 *
        double.parse(predictions['distance']['text']
            .split(' ')[0]
            .toString()
            .replaceFirst(',', ''));

    List uberTypes = ['UberX', 'UberXL', 'Comfort'];
    List uberRates = [1.0, 2.0, 3.0];

    List<UberRides> uberRides = [];

    for (int i = 0; i < 3; i++) {
      int rate = (10 + (uberRates[i] * kilometers)).round();
      uberRides.add(UberRides(uberTypes[i], finalTime, rate, false));
    }

    return uberRides;   

  }

  //Search Algorithm for the addresses that the user searches
  void getSearchedLocations(String text) async {
    if (text.isEmpty) {
      return;
    }
    String base_url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String url = '$base_url?input=$text&key=$googleAPI&types=address';

    Response response = await Dio().get(url);

    final predictions = response.data['predictions'];

    List _searchedAddresses = [];

    for (var i = 0; i < predictions.length; i++) {

      try {

        String _userAddress = predictions[i]['description'];

        var addresses =
            await Geocoder.local.findAddressesFromQuery(_userAddress);
        var first = addresses.first;

        _searchedAddresses.add({
          'address': _userAddress,
          'id': predictions[i]['place_id'],
          'latitude': first.coordinates.latitude,
          'longitude': first.coordinates.longitude
        });

        searchedAddresses = _searchedAddresses;

        notifyListeners();

      } catch (e) {

        continue;
      }
    }
  }



}
