import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapData {
  final Set<Marker> markers;
  GoogleMapController? mapController;

  MapData({required this.markers, this.mapController});

  MapData copyWith({
    Set<Marker>? markers,
    GoogleMapController? mapController,
  }) {
    return MapData(
      markers: markers ?? this.markers,
      mapController: mapController ?? this.mapController,
    );
  }
}
