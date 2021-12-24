import 'package:circle/business/profile.dart';
import 'package:circle/modal/modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatefulWidget {
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  var businessLocation = BusinessLocationModal();
  GoogleMapController? controller;
  LatLng? _latLng;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      var args = ModalRoute.of(context)?.settings.arguments;
      businessLocation = args as BusinessLocationModal;

      if (businessLocation.isEmpty) {
        _latLng = await _currentLocation(moveCamera: false);
      } else {
        _latLng = businessLocation.latLng;
      }

      setState(() => print('Load Location.... $_latLng'));
    });
  }

  _onCameraIdle() async {
    try {
      var local = Geocoder.local;
      var latitude = _latLng?.latitude;
      var longitude = _latLng?.longitude;
      if (latitude == null || longitude == null) {
        print('latitude, longitude ==> error ');
        return;
      }
      var coordinates = Coordinates(latitude, longitude);
      var addresses = await local.findAddressesFromCoordinates(coordinates);

      if (addresses.length > 0) {
        var json = addresses.first.toJson();
        businessLocation = BusinessLocationModal.fromJson(json);
      }
      businessLocation.latitude = latitude;
      businessLocation.longitude = longitude;
      setState(() => print('addresses length ==> ${addresses.length}'));
    } catch (e) {
      print('apiKey ==> error --- $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Location'.toUpperCase())),
      body: _latLng == null
          ? Center(child: CupertinoActivityIndicator())
          : Stack(children: [
              SizedBox.fromSize(
                size: size,
                child: GoogleMap(
                  onCameraIdle: _onCameraIdle,
                  initialCameraPosition: CameraPosition(
                    target: _latLng!,
                    zoom: 16,
                  ),
                  onCameraMove: (position) => this._latLng = position.target,
                  onMapCreated: (controller) => this.controller = controller,
                ),
              ),
              Center(
                child: Icon(
                  Icons.location_on,
                  color: Colors.blue[300],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, businessLocation),
                  child: Text('Save'),
                ),
              ),
              Container(
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: TextFormField(
                  onChanged: (address) =>
                      businessLocation.addressLine = address,
                  minLines: 1,
                  maxLines: 6,
                  autofocus: false,
                  controller:
                      TextEditingController(text: businessLocation.addressLine),
                  decoration: InputDecoration(labelText: 'Address'),
                ),
              ),
              Align(
                alignment: Alignment(0.98, -0.98),
                child: IconButton(
                  onPressed: _currentLocation,
                  icon: Icon(Icons.my_location),
                ),
              ),
            ]),
    );
  }

  Future<LatLng?> _currentLocation({bool moveCamera = true}) async {
    LatLng? _target;
    try {
      var _position = await determinePosition();
      _target = LatLng(_position.latitude, _position.longitude);
      if (controller != null && moveCamera)
        controller?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _target, zoom: 17.0),
          ),
        );
    } catch (e) {
      print('$e');
    }
    print('Current Location => $_target');
    return _target;
  }
}
