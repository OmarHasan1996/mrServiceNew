import 'dart:async';
import 'dart:typed_data';
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/constant/app_size.dart';
import 'package:closer/constant/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;
class OrderTrackingPage extends StatefulWidget {
  final String orderServiceId;
  final LatLng distination;
  OrderTrackingPage({Key? key, required this.orderServiceId, required this.distination}) : super(key: key);
  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}
class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();
 // static const LatLng sourceLocation = LatLng(25.297593, 55.378071);
  late final LatLng destination;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  //LocationData? currentLocation;
  LatLng? currentWorkerLocation;
  String _text = "loading";

  @override
  void initState() {
    destination = widget.distination;
    getCurrentLocation();
    setCustomMarkerIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getPolyPoints();
    setCustomMarkerIcon();
    return Scaffold(
      body: currentWorkerLocation == null
          ? Center(child: Text(_text))
          :
          Stack(
            children: [
              googleMaps(),
              Padding(
                padding: EdgeInsets.all(AppPadding.p20),
                child: CloseButton(onPressed: (){
                  if(_timer!=null) _timer!.cancel();
                  Navigator.of(context).pop();
                }, color: AppColors.mainColor,
                ),
              ),
            ],
          )
    );
  }
  Widget googleMaps(){
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(currentWorkerLocation!.latitude??25.2867729,currentWorkerLocation!.longitude??55.3742941),
        zoom: 13.5,
      ),
      markers: {
        markerCar==null?Marker(
          markerId: const MarkerId("currentLocation"),
          icon: currentLocationIcon,
          position: LatLng(currentWorkerLocation!.latitude!, currentWorkerLocation!.longitude!),
        ):markerCar!,

        /*Marker(
          markerId: const MarkerId("source"),
          icon: sourceIcon,
          position: sourceLocation,
        ),*/
        Marker(
          markerId: const MarkerId("destination"),
          icon: destinationIcon,
          position: destination,
        ),
      },
      polylines: {
        Polyline(
          polylineId: const PolylineId("route"),
          points: polylineCoordinates,
          color: const Color(0xFF7B61FF),
          width: 6,
        ),
      },
      onMapCreated: (mapController) {
        _controller.complete(mapController);
      },
    );
  }

  List<LatLng> polylineCoordinates = [];

  void getPolyPoints() async {
   try{
     PolylinePoints polylinePoints = PolylinePoints();
     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
       Strings.mapKey, // Your Google Map Key
       PointLatLng(currentWorkerLocation!.latitude, currentWorkerLocation!.longitude),
       PointLatLng(destination.latitude, destination.longitude),
       travelMode: TravelMode.driving,
     );
     if (result.points.isNotEmpty) {
       result.points.removeAt(result.points.length-1);
       result.points.forEach(
             (PointLatLng point) => polylineCoordinates.add(LatLng(point.latitude, point.longitude),
         ),
       );
       setState(() {});
     }

   }catch(e){

   }
  }
  Marker? markerCar;
  void setCustomMarkerIcon() async{
    if(markerCar==null){
      final Uint8List? markerIcon = await getBytesFromAsset('assets/images/car_map.png', 100);
      markerCar = Marker(
        icon: BitmapDescriptor.fromBytes(markerIcon!),
        position: LatLng(currentWorkerLocation!.latitude, currentWorkerLocation!.longitude),
        markerId: const MarkerId("currentLocation"),
      );
    }
  }
  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
  }
  Timer? _timer;
  void getCurrentLocation() async {
    await APIService.checkLocation(widget.orderServiceId).then(
          (location) {
        //currentLocation = location;
        if(location!=null) currentWorkerLocation = LatLng(location!.latitude, location!.longitude);
        else _text = "Can't reach order location";
      },
    );
   _timer = Timer.periodic(Duration(seconds: 25), (timer) async{
      await APIService.checkLocation(widget.orderServiceId).then(
            (location) {
          //currentLocation = location;
              if(location!=null) currentWorkerLocation = LatLng(location!.latitude, location!.longitude);
              else _text = "Can't reach order location";
        },
      );
      setState(() {});
    });
  }


}