import 'dart:convert';
import 'dart:math';

//import 'package:admob_flutter/admob_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:closer/constant/apiUrl.dart';
import 'package:closer/constant/app_size.dart';
import 'package:closer/constant/font_size.dart';
import 'package:closer/helper/adHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/localizations.dart';
import 'package:closer/screens/service/sub_service_dec.dart';
import 'package:progress_indicators/progress_indicators.dart';

import 'package:closer/MyWidget.dart';
import 'package:closer/const.dart';

// ignore: must_be_immutable
class SubServiceScreen extends StatefulWidget {
  String token;
  List subservice = [];
  List subservicedec = [];
  SubServiceScreen({
    required this.token,
    required this.subservice,
  });

  @override
  _SubServiceScreenState createState() =>
      _SubServiceScreenState(this.token, this.subservice);
}

class _SubServiceScreenState extends State<SubServiceScreen> {
  String? lng;
  String token;
  List _subservice = [];
  List subservice = [];
  List subservicedec = [];
  getSubServiceDecData(var id) async {
    try {
      // print(id);
      var url = Uri.parse('${ApiUrl.mainServiceRead}cityid=$cityId&filter=Service.Id~eq~$id');
      //var url = Uri.parse('${ApiUrl.mainServiceRead}filter=Service.IsMain~eq~false~and~Service.Id~eq~$id');
      http.Response response = await http.get(url, headers: {
        "Authorization": token,
      });
      if (response.statusCode == 200) {
        var item = json.decode(response.body)["result"]['Data'];
        setState(() {
          subservicedec.clear(); // = item;
          for (var e in item) {
            subservicedec.add(e['Service']);
          }
          editTransactionUserUserInfo(transactions![0], userInfo);
          editTransactionServiceDec(transactions![0], subservicedec, id);
          //print(subservicedec);
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubServiceDec(
                    token: token, subservicedec: subservicedec))).then((_) {
          setState(() {});
        });
      } else {
        setState(() {
          subservicedec = [];
        });
      }
    } catch (e) {
      subservicedec = transactions![0].subServiceDec;
      if (subservicedec.isEmpty) {
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
          message: 'This service will coming soon'.tr,
          messageSize: MediaQuery.of(context).size.width / 22,
        ).show(context);
      } else if (subservicedec[0]["Id"] == id) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubServiceDec(
                    token: token, subservicedec: subservicedec))).then((_) {
          setState(() {});
        });
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
          message: 'This service will coming soon'.tr,
          messageSize: MediaQuery.of(context).size.width / 22,
        ).show(context);
      }
    }
  }

  _SubServiceScreenState(this.token, this.subservice);
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  APIService? api;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subservice.clear();
    for (int i = 0; i < subservice.length; i++) {
      _subservice.add(subservice[i]);
    }
    allSubServices.add(subservice);
    // print(subservice);
  }

  bool _loading = false, _transScreen = false;

  @override
  Widget build(BuildContext context) {
    var barHight = MediaQuery.of(context).size.height / 5.7;
    //getServiceData();
    AdHelper.loadBanner();
    api = APIService(context: context);
    var id =
        _subservice[_subservice.indexWhere((element) => element.length < 2)]
            ['id'];
    _subservice.sort((a, b) {
      return a['Name']
          .toString()
          .toLowerCase()
          .compareTo(b['Name'].toString().toLowerCase());
    });
    _subservice.removeWhere((element) => element.length < 2);
    _subservice.add({'id': id});
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: MyWidget.appBar(
            title: _subservice.length > 1
                ? _subservice[0]['Service']['Name']
                : 'Empty',
            isMain: false),
        endDrawer: MyWidget(context).drawer(barHight,
            MediaQuery.of(context).size.height / 80 * 3, () => _setState()),
        backgroundColor: Colors.grey[100],
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          MyWidget.topYellowDriver(),
          SizedBox(
            height: MediaQuery.of(context).size.height / 160,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                //vertical: MediaQuery.of(context).size.height / 37,
                horizontal: MediaQuery.of(context).size.width / 10),
            child: Container(
              //alignment: Alignment.topLeft,
              child: MyWidget(context).textBlack20(
                  (_subservice.length - 1).toString() +
                      ' ' +
                      AppLocalizations.of(context)!
                          .translate('Services in ...'),
                  bold: false),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: _subservice.length - 1,
                  itemBuilder: (context, index) {
                    return serviceRow(_subservice[index]);
                  },
                  addAutomaticKeepAlives: false,
                ),
                Align(
                  alignment: Alignment.center,
                  child: MyWidget.jumbingDotes(_loading),
                ),
                _transScreen ? MyWidget(context).transScreen() : SizedBox()
              ],
            ),
          ),
          MyWidget.loadBannerAdd(),
        ]),
      ),
    );
  }

  Padding serviceRow(ser) {
    var desc = ser['Desc'];
    var name = ser['Name'];
    var imagepath = ser['ImagePath'];
    var price = ser['Price'];
    var discountService =
        ser['DiscountsServices'] ?? ser['Service']['DiscountsServices'];
    var disAmount = 0.0;
    if (discountService != null && discountService.length > 0) {
      disAmount = discountService[0]['DiscountAmount'];
    }
    var priceAfterDiscount = price - disAmount;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.03,
          horizontal: MediaQuery.of(context).size.width / 22),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => APIService(context: context).showImage(imagepath),
            child: Container(
                alignment: Alignment.center,
                width: min(MediaQuery.of(context).size.width * 0.20,
                    MediaQuery.of(context).size.height * 0.092),
                height: FontSize.s16*6,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(imagepath),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.all(
                      Radius.circular(MediaQuery.of(context).size.height / 51)),
                )),
          ),
          SizedBox(
            width: AppWidth.w4,
          ),
          GestureDetector(
            onTap: () async {
              setState(() {
                _loading = true;
                _transScreen = true;
              });
              var id = ser['Id'];
              if (ser['IsMain']) {
                await getSubServiceData(id);
              } else {
                await getSubServiceDecData(id);
              }
              setState(() {
                _loading = false;
                _transScreen = false;
              });
            },
            child: Container(
              alignment: Alignment.center,
              width: AppWidth.w65,
              height: FontSize.s16*6,
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height / 51)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 80,
                    horizontal: MediaQuery.of(context).size.width / 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SingleChildScrollView(
                            scrollDirection:Axis.horizontal,
                            child: MyWidget(context).textTitle15(name, scale: 1.2),
                          ),
                          SizedBox(height: AppHeight.h1,),
                          Flexible(
                            flex: 2,
                            child: Row(children: [
                              priceAfterDiscount == price
                                  ? const SizedBox()
                                  : MyWidget(context).textTap25(prettify(price),
                                      lineTrought: true),
                              SizedBox(width: AppWidth.w2,),
                              (ser['IsMain'])
                                  ? SizedBox(
                                      width: AppWidth.w45,
                                      height: FontSize.s16*3,
                                      child: MyWidget.htmlScreen(desc, dirction: Axis.horizontal),
                                    )
                                  : MyWidget(context).textTap25(
                                      '${prettify(priceAfterDiscount)} ${AppLocalizations.of(context)!.translate('TRY')}',
                                      color: AppColors.mainColor,
                                      scale: 1.1),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: min(MediaQuery.of(context).size.height / 45,
                          MediaQuery.of(context).size.width / 20),
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _setState() {
    setState(() {});
  }

  getSubServiceData(var id) async {
    try {
      var url = Uri.parse(
          '${ApiUrl.mainServiceRead}cityid=$cityId&filter=Service.ServiceParentId~eq~$id');
      http.Response response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        var item = json.decode(response.body)["result"]['Data'];
        //editTransactionService(transactions![0], service);
        //editTransactionUserUserInfo(transactions![0], userInfo);
        if (item.length == 0) {
          // ignore: use_build_context_synchronously
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
            message: AppLocalizations.of(context)!
                .translate('This service will coming soon'),
            messageSize: MediaQuery.of(context).size.width / 22,
          ).show(context);
        } else {
          _subservice.clear(); // = item;
          for (var e in item) {
            _subservice.add(e['Service']);
          }
          editTransactionSubService(transactions![0], _subservice, id);
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) =>
                  new SubServiceScreen(token: token, subservice: _subservice),
            ),
          ).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              allSubServices.removeAt(allSubServices.length - 1);
              _subservice = allSubServices[allSubServices.length - 1];
              // Call setState to refresh the page.
            });
          });
        }
      } else {
        setState(
          () {
            _subservice = [];
          },
        );
      }
    } catch (e) {
      _subservice = transactions![0].subService;
      if (_subservice.length == 1) {
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
          message: 'This service will coming soon'.tr,
          messageSize: MediaQuery.of(context).size.width / 22,
        ).show(context);
      } else if (_subservice[_subservice.length - 1]["id"] == id) {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) =>
                new SubServiceScreen(token: token, subservice: _subservice),
          ),
        );
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
          message: 'This service will coming soon'.tr,
          messageSize: MediaQuery.of(context).size.width / 22,
        ).show(context);
      }
    }
  }
}
