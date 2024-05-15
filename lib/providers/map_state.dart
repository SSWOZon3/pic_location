import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pic_location/models/review_data.dart';
import 'package:pic_location/providers/session_provider.dart';
import '../services/map_service.dart';
import '../ui/screens/review_screen.dart';
import '../models/map_data.dart';

typedef MarkerTapCallback = void Function(String markerId);

class MapState extends StateNotifier<MapData> {
  final Ref ref;
  final MapService _mapService;
  MarkerTapCallback? onMarkerTap;
  Map<String, ReviewData> markersInfo = {};

  MapState(this._mapService, this.ref)
      : super(MapData(
            markers: {}));

  void setOnMarkerTapCallback(MarkerTapCallback callback) {
    onMarkerTap = callback;
  }

  Future<void> searchThisArea(LatLngBounds bounds) async {
    String accessToken = ref.read(sessionStateProvider).accessToken;

    List<ReviewData> reviewDataList =
        await _mapService.fetchLocationsWithinArea(bounds, accessToken);

    Set<Marker> markers = reviewDataList.map((ReviewData reviewData) {
      markersInfo[reviewData.id] = reviewData;

      return Marker(
        markerId: MarkerId(reviewData.id),
        consumeTapEvents: true,
        position: LatLng(reviewData.latitude, reviewData.longitude),
        onTap: () => onMarkerTap?.call(reviewData.id),
      );
    }).toSet();
    state = MapData(
        markers: markers,
        mapController: state.mapController);
  }

  void updateMarker(LatLng location, String newMarkerId) {
    MarkerId markerId =
        MarkerId('marker_id_${location.latitude}_${location.longitude}');
    final newMarkers = Set<Marker>.from(state.markers);
    newMarkers.removeWhere((marker) => marker.markerId == markerId);

    final updatedMarker = Marker(
      markerId: MarkerId(newMarkerId),
      position: location,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    newMarkers.add(updatedMarker);
    state = state.copyWith(markers: newMarkers);
  }

  void configureMarkersForDetails(Set<Marker> markers, BuildContext context) {
    final configuredMarkers = markers.map((marker) {
      return marker.copyWith(
        onTapParam: () => _openReviewDetails(context, marker.markerId),
      );
    }).toSet();

    state = state.copyWith(markers: configuredMarkers);
  }

  void _openReviewDetails(BuildContext context, MarkerId markerId) {
    // Aquí, puedes obtener los detalles de la reseña usando markerId
    // y abrir la pantalla ReviewDetailsScreen

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ReviewScreen(markerId: markerId.value)),
    );
  }

  void setMarkers(Set<Marker> newMarkers) {
    state = MapData(
        markers: newMarkers,
        mapController: state.mapController);
  }

  void setMapController(GoogleMapController controller) {
    state = MapData(
        markers: state.markers,
        mapController: controller);
  }

  void moveCameraTo(LatLng position) {
    state.mapController?.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  void addMarker(Marker newMarker) {
    state = state.copyWith(
      markers: Set<Marker>.from(state.markers)..add(newMarker),
    );
  }
}

final mapStateProvider =
    StateNotifierProvider<MapState, MapData>((ref) => MapState(MapService(), ref));
