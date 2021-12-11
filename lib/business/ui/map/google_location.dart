import 'package:circle/modal/modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleLocation extends StatelessWidget {
  final BusinessLocationModal location;
  final GestureTapCallback? onTap;
  final double height;

  const GoogleLocation(
    this.location, {
    Key? key,
    this.onTap,
    this.height = 280,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(children: [
          GoogleMap(
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: location.latLng,
              zoom: 16,
            ),
          ),
          // Center Location Marker
          Container(
            height: height,
            color: Colors.black26,
            alignment: Alignment.center,
            child: Icon(
              Icons.location_on,
              color: Colors.blueGrey[900],
            ),
          ),
          // Location Text
          Container(
            height: height,
            padding: EdgeInsets.only(
              right: 9,
              left: 9,
            ),
            alignment: Alignment(-0.9, -0.9),
            child: InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: location.addressLine));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Copied to Clipboard Address'),
                ));
              },
              child: Text(
                location.addressLine ?? '...',
              ),
            ),
          ),
          onTap != null
              ? Container(
                  height: height,
                  alignment: Alignment(0.9, 0.9),
                  child: InkWell(
                    child: CircleAvatar(
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.orange,
                    ),
                    onTap: onTap,
                  ),
                ) // Location Edit Button
              : Container(
                  height: height,
                  alignment: Alignment(0.9, -0.9),
                  child: InkWell(
                    child: CircleAvatar(
                      child: Icon(
                        Icons.map,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => launch(location.navigation),
                  ),
                ) // Location Navigator
        ]),
      ),
      margin: EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
