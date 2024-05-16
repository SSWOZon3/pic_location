import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pic_location/providers/map_state.dart';
import 'package:pic_location/ui/screens/review_screen.dart';
import 'create_review_screen.dart';

class MapScreen extends ConsumerWidget {
  final LatLng? initialPosition;
  final Completer<GoogleMapController> _controller = Completer();

  MapScreen({super.key, this.initialPosition});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapData = ref.watch(mapStateProvider);
    ref.read(mapStateProvider.notifier).setOnMarkerTapCallback((String markerId) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ReviewScreen(markerId: markerId),
      ));
    });


    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: mapData.markers,
            initialCameraPosition: const CameraPosition(
              target: LatLng(39.54759884126908, 0.33143889158964157),
              zoom: 10,
            ),
            onMapCreated: (GoogleMapController controller) async {
              String googleMapsJson =
                  await rootBundle.loadString('assets/google_maps_config.json');
              controller.setMapStyle(googleMapsJson);
              _controller.complete(controller);
              ref.read(mapStateProvider.notifier).setMapController(controller);
            },
            onLongPress: (LatLng position) {
              _onAddMarkerButtonPressed(position, ref, context);
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    LatLngBounds bounds = await _getVisibleRegion(ref);
                    ref.read(mapStateProvider.notifier).searchThisArea(bounds);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Bordes redondeados
                    ),
                  ),
                  child: const Text('Search this area'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onAddMarkerButtonPressed(
      LatLng location, WidgetRef ref, BuildContext context) {
    final String markerIdVal =
        'marker_id_${location.latitude}_${location.longitude}';
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
        markerId: markerId,
        position: location,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        draggable: true,
        onTap: () {
          _onMarkerTapped(context, location, markerIdVal);
        });

    ref.read(mapStateProvider.notifier).addMarker(marker);
  }

  void _onMarkerTapped(BuildContext context, LatLng location, String markerId) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          minChildSize: 0.2,
          expand: false,
          shouldCloseOnMinExtent: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return CreateReviewScreen(markerId: markerId, scrollController: scrollController, location: location);
          },
        );
      },
    );
  }

  Future<LatLngBounds> _getVisibleRegion(WidgetRef ref) async {
    final GoogleMapController controller = await _controller.future;
    return controller.getVisibleRegion();
  }
}
