import 'dart:convert';
import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:closer/constant/app_size.dart';
import 'package:closer/constant/functions.dart';
import 'package:closer/constant/strings.dart';
import 'package:closer/helper/adHelper.dart';
import 'package:closer/map/location.dart';
import 'package:closer/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/const.dart';
import 'package:closer/localizations.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../../MyWidget.dart';
import 'manege_address.dart';
import 'package:geocoding/geocoding.dart';
class UpdateAddress extends StatefulWidget {
  var address;
  UpdateAddress({Key? key, required this.address}) : super(key: key);

  @override
  State<UpdateAddress> createState() => _UpdateAddressState();
}

class _UpdateAddressState extends State<UpdateAddress> {
  late double lat, lng;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _nearController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _aprController = TextEditingController();
  bool _saving = false;
  String autocompletePlace = "null";
  Prediction? initialValue;

  _setAddress() async{
    lng = widget.address['lng'];
    lat = widget.address['lat'];
    var newPlace = await placemarkFromCoordinates(lat, lng);
    _titleController.text = widget.address['Title']??'';
      _countryController.text =  newPlace.first.country??'';
      _cityController.text =  newPlace.first.locality??'';
      _areaController.text =  newPlace.first.subLocality??'';
      _nearController.text =  widget.address['notes']??'';
      _buildingController.text =  widget.address['building']??'';
      _floorController.text =  widget.address['floor']??'';
      _aprController.text =  widget.address['appartment']??'';
  }

  void _showPlacePicker() async {
    getCurrentLocation();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MapLocationPicker(
            apiKey: Strings.mapKey,
            canPopOnNextButtonTaped: true,
            currentLatLng: currentLocation == null
                ? LatLng(29.146727, 76.464895)
                : LatLng(
                currentLocation!.latitude!, currentLocation!.longitude!),
            onNext: (GeocodingResult? result) async{
              if(result != null)
              {
                lng = result.geometry.location.lng;
                lat = result.geometry.location.lat;
                var newPlace = await placemarkFromCoordinates(lat, lng);
                 widget.address['Title'] = newPlace.first.name??'';
                 widget.address['notes'] = newPlace.first.street??'';
                _setAddress();
              }},
            onSuggestionSelected: (PlacesDetailsResponse? result) {
              if (result != null) {
                setState(() {
                  autocompletePlace = result.result.formattedAddress ?? "";
                });
              }
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setAddress();
   AdHelper.loadInterstitialAd(() => null);
  }

  _save() async {
    print('begin');
    if (_titleController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        _areaController.text.isNotEmpty) {
      setState(() {
        _saving = true;
      });
      print('t');
      await updateAddress();
      setState(() {
        getAddress(userData!.content!.id);
      });
      showInterstitialAdd();
      print('finish');
      country.clear();
      city.clear();
      area.clear();
      await Future.delayed(Duration(seconds: 1));
      setState(() {});
      // ignore: use_build_context_synchronously
      if(AdHelper.interstitialAd != null)AdHelper.interstitialAd?.show();
      MyApplication.navigateToReplace(context, MagageAddressScreen(token: token,));
    } else {
      await Flushbar(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 20),
        icon: Icon(
          Icons.error_outline,
          size: MediaQuery.of(context).size.width / 18,
          color: Colors.white,
        ),
        duration: Duration(seconds: 3),
        shouldIconPulse: false,
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.all(
          Radius.circular(MediaQuery.of(context).size.height / 37),
        ),
        backgroundColor: Colors.grey.withOpacity(0.5),
        barBlur: 20,
        message: AppLocalizations.of(context)!.translate('Area is required'),
        messageSize: MediaQuery.of(context).size.width / 22,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var barHight = MediaQuery.of(context).size.height / 5.5;

    return SafeArea(
      child: Scaffold(
        appBar: MyWidget.appBar(title: AppLocalizations.of(context)!.translate('Address')),
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            Center(
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height / 80,
                decoration: const BoxDecoration(
                  color: Color(0xffffca05),
                  borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
              ),
            ),
            /*Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      //vertical: MediaQuery.of(context).size.height / 160,
                      horizontal: MediaQuery.of(context).size.width / 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  homeColor = Color(0xffffca05);
                                  workColor = Colors.blueGrey;
                                  home = "home";
                                  work = '';
                                },
                              );
                            },
                            child: MyWidget(context).textBlack20(AppLocalizations.of(context)!.translate("home"), color: homeColor, scale: 1.3),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  workColor = Color(0xffffca05);
                                  homeColor = Colors.blueGrey;
                                  home = "";
                                  work = 'work';
                                },
                              );
                            },
                            child: MyWidget(context).textBlack20(AppLocalizations.of(context)!.translate("Work"), color: workColor, scale: 1.3),
                          )
                        ],
                      ),
                      Divider(
                        thickness: 2,
                        color: Color(0xffffca05),
                      )
                    ],
                  ),
                ),
              ),*/
            SizedBox(height: AppHeight.h2,),
            MyWidget(context).raisedButton(
                AppLocalizations.of(context)!.translate('Pick from map'),
                    () => _showPlacePicker(),
                AppWidth.w90,
                false),
            Expanded(
              flex: 10,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 100,
                  ),
                  child: Column(
                    children: [
                      MyWidget(context).textFiledAddress(_titleController,
                          AppLocalizations.of(context)!.translate('Title')),
                      MyWidget(context).textFiledAddress(_countryController,
                          AppLocalizations.of(context)!.translate('Country')),
                      MyWidget(context).textFiledAddress(_cityController,
                          AppLocalizations.of(context)!.translate('City')),
                      MyWidget(context).textFiledAddress(_areaController,
                          AppLocalizations.of(context)!.translate('Area')),
                      MyWidget(context).textFiledAddress(_nearController,
                          AppLocalizations.of(context)!.translate('Near by')),
                      MyWidget(context).textFiledAddress(
                          _buildingController,
                          AppLocalizations.of(context)!
                              .translate('Building number/name')),
                      MyWidget(context).textFiledAddress(_floorController,
                          AppLocalizations.of(context)!.translate('Floor')),
                      MyWidget(context).textFiledAddress(
                          _aprController,
                          AppLocalizations.of(context)!
                              .translate('Apartment number')),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 160,
                            horizontal: MediaQuery.of(context).size.width / 20),
                        child: Container(
                          alignment: Alignment.bottomRight,
                          // ignore: deprecated_member_use
                          child: MyWidget(context).raisedButton(
                              AppLocalizations.of(context)!.translate('Save'),
                                  () => _save(),
                              MediaQuery.of(context).size.width / 1.2,
                              _saving,
                              buttonText: Color(0xffffca05),
                              colorText: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Expanded(
            //   flex: 2,
            //   child:
            // ),
          ],
        ),
      ),
    );
  }


  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Row(
      children: [
        Text(
          item,
          style: TextStyle(
        fontFamily: 'comfortaa',
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
  DropdownMenuItem<String> buildMenuItem1(String item) => DropdownMenuItem(
    value: item,
    child: Row(
      children: [
        Text(
          item,
          style: TextStyle(
        fontFamily: 'comfortaa',
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
  DropdownMenuItem<String> buildMenuItem2(String item) => DropdownMenuItem(
    value: item,
    child: Row(
      children: [
        Text(
          item,
          style: TextStyle(
        fontFamily: 'comfortaa',
            color: Colors.black,
          ),
        ),
      ],
    ),
  );

  Future updateAddress() async {
    print('AddAddress function is called');
    print('AddAddress function is called');
    var apiUrl =
    Uri.parse('$apiDomain/Main/ProfileAddress/ProfileAddress_Update?');
    Map mapDate = {
      "id": widget.address['Id'],
      "UserId": userData!.content!.id,
      "notes": _nearController.text,
      "building": _buildingController.text,
      "floor": _floorController.text,
      "appartment": _aprController.text,
      "lat": lat,
      "lng": lng,
      "Title": _titleController.text
    };
    http.Response response =
    await http.post(apiUrl, body: jsonEncode(mapDate), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": token,
    });
    if (response.statusCode == 200) {
      print(response.body);
      print('success');
    } else {
      print('fail');
    }
    print('AddAddress function is finished');
    setState(() {
      getAddress(userData!.content!.id);
    });
  }

  void getAddress(var id) async {
    var url = Uri.parse(
        "$apiDomain/Main/ProfileAddress/ProfileAddress_Read?filter=UserId~eq~'$id'");
    http.Response response = await http.get(
      url,
      headers: {
        "Authorization": token,
      },
    );
    if (response.statusCode == 200) {
      var item = json.decode(response.body)["result"]['Data'];
      Address = item;
    } else {
      Address = [];
    }
    _saving = false;
  }

}
