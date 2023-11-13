import 'dart:convert';
import 'dart:math';

import 'package:closer/constant/app_size.dart';
import 'package:closer/constant/functions.dart';
import 'package:closer/constant/strings.dart';
import 'package:closer/map/location.dart';
import 'package:closer/screens/address/updateAddress.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:closer/api/api_service.dart';
import 'package:closer/localizations.dart';
import 'package:closer/screens/address/new_address_screen.dart';

import '../../MyWidget.dart';
import '../../const.dart';
import 'package:map_location_picker/map_location_picker.dart';

// ignore: must_be_immutable
class MagageAddressScreen extends StatefulWidget {
  String token;

  MagageAddressScreen({
    required this.token,
  });

  @override
  _MagageAddressScreenState createState() =>
      _MagageAddressScreenState(this.token);
}

class _MagageAddressScreenState extends State<MagageAddressScreen> {
  String? lng;
  String token;
  TextEditingController nameController = new TextEditingController();
  TextEditingController mailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

 _MagageAddressScreenState(
    this.token,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddress(userData!.content!.id);
    // print(subservice);
  }

  @override
  Widget build(BuildContext context) {
    var barHight = MediaQuery.of(context).size.height / 5.5;
    //getServiceData();

    return SafeArea(
        child: Scaffold(
          appBar: MyWidget.appBar(title: AppLocalizations.of(context)!.translate("Manager Address")),
          backgroundColor: Colors.grey[100],
          body: Column(
            children: [
              Center(
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 80,
                  decoration: BoxDecoration(
                    color: Color(0xffffca05),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(30)),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 80,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: AppHeight.h1,),
                    /*Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height / 40,
                        horizontal: MediaQuery.of(context).size.width / 20,
                      ),
                      child: MyWidget(context).textBlack20(AppLocalizations.of(context)!.translate("Manager Address"),scale: 1.3)
                    ),*/
                    Expanded(
                      child: ListView.builder(
                        itemCount: Address.length,
                        itemBuilder: (context, index) {
                          //totalPrice =0;
                          return addresslist(Address, index);
                        },
                        addAutomaticKeepAlives: false,
                      ),
                    ),
                    MyWidget(context).raisedButton(AppLocalizations.of(context)!.translate('Add Address'), (){
                      MyApplication.navigateToReplace(context, NewAddressScreen(token: token,));
                      /*MyApplication.navigateTo(context, NewAddressScreen(token: token));
                      setState(() {
                        getAddress(userData!.content!.id);
                      });*/
                    }, MediaQuery.of(context).size.width / 1.2, false, padV: 0.1),
                  ],
                ),
              ),
            ],
          ),
        ),

    );
  }

  addresslist(ord, ind) {
    // getAddress(userData["content"]["Id"]);

    return GestureDetector(
      onTap: (){
        MyApplication.navigateToReplace(context, UpdateAddress(address: ord[ind]));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: AppHeight.h2,
            horizontal: MediaQuery.of(context).size.width / 40),
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: MediaQuery.of(context).size.width / 22),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 8,
                    child: MyWidget(context).textBlack20(ord[ind]['Title']??'....',),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            deletAddress(ord, ind);
                          },
                        );
                        setState(
                          () {
                            getAddress(userData!.content!.id);
                          },
                        );
                      },
                      child: Icon(
                        Icons.delete,
                        size: min(MediaQuery.of(context).size.width / 20, MediaQuery.of(context).size.height / 45),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 80,
            ),
            Divider(
              color: Colors.grey[900],
              height: 1,
            ),
          ],
        ),
      ),
    );
  }

  void getAddress(var id) async {
/*
    print(id);
*/
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
      setState(
        () {
          Address = item;
          editTransactionUserAddress(transactions![0], item);
        },
      );
    } else {
/*
      print(response.statusCode);
*/
      setState(
        () {
          Address = [];
        },
      );
    }
    print("Address length");
    print(Address.length);
  }

  void deletAddress(ord, ind) async {
    var addid = ord[ind]['Id'];
    var apiUrl = Uri.parse(
        '$apiDomain/Main/ProfileAddress/ProfileAddress_Destroy?');

    Map mapDate = {
      "guidParam": "$addid",
    };

    http.Response response = await http.post(
      apiUrl,
      body: jsonEncode(mapDate),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Authorization": token,
      },
    );

    if (response.statusCode == 200) {
/*
      print(response.body);
*/
      print('success');
    } else {
/*
      print(response.statusCode);
*/
      print('fail');
    }
    setState(
      () {
        getAddress(userData!.content!.id);
      },
    );
  }

}
