import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';

import 'package:closer/MyWidget.dart';
import 'package:closer/const.dart';
import 'package:closer/localizations.dart';
import 'checkout.dart';
import 'package:http/http.dart' as http;

class NewOrder extends StatefulWidget {
  String token;
  List service = [];
  NewOrder(this.token, this.service);
  @override
  _NewOrderState createState() => _NewOrderState(token, service);
}

class _NewOrderState extends State<NewOrder> {
  String token;
  List service = [];
  _NewOrderState(this.token,this.service);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  APIService? api;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  @override
  Widget build(BuildContext context) {
    var barHight = MediaQuery.of(context).size.height / 5.7;
    //getServiceData();
    api = APIService(context: context);
    var leftPadding = MediaQuery.of(context).size.width/12;

    return SafeArea(
        child: Scaffold(
          key: _key,
          resizeToAvoidBottomInset: true,
          appBar: MyWidget.appBar(title: AppLocalizations.of(context)!.translate('Order Cart'), isMain: false, withoutCart: true),
          endDrawer: MyWidget(context).drawer(barHight, MediaQuery.of(context).size.height / 80 * 3, ()=>_setState()),
          backgroundColor: Colors.grey[100],
          body: Column(children: [
            MyWidget.topYellowDriver(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 80,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: leftPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 80,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height *(0.7),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      boxShadow: [BoxShadow(
                        color: AppColors.white,//Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 1), // changes position of shadow
                      ),],
                      borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height / 80)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height / 50,
                          horizontal: MediaQuery.of(context).size.width / 30),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: order.length == 0
                                  ? 0 : order.length,
                              itemBuilder: (context, index) {
                                //totalPrice =0;s
                                return GestureDetector(
                                  onTap: () {
                                    //getMyOrders(userInfo["Id"]);
                                    /*print(
                                                          "------------------");
                                                      print(myOrders.length);
                                                      print(
                                                          "------------------");
                                                      print(
                                                          myOrders['Data'][0]);
                                                      print(
                                                          "------------------");*/
                                    // order details
                                    //**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**
                                    //**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**
                                    //**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**
                                  },
                                  child:
                                  MyWidget(context).orderlist(order[index],0.82,()=>_setState()),
                                );
                              },
                              addAutomaticKeepAlives: false,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                MediaQuery.of(context)
                                    .size
                                    .width /
                                    22),
                            child: Column(
                              children: [
                                MyWidget(context).textBlack20(AppLocalizations.of(context)!.translate('TOTAL')),
                                MyWidget(context).textTitle15('\.${AppLocalizations.of(context)!.translate('TRY')} ${sumPrice().toStringAsFixed(3)}', color: Colors.blue),
                                Padding(
                                  padding:
                                  EdgeInsets.symmetric(
                                    vertical:
                                    MediaQuery.of(context)
                                        .size
                                        .height /
                                        160,
                                  ),
                                  child: MyWidget(context).raisedButton(AppLocalizations.of(
                                      context)!.translate('Finished Order'), ()async=> {
                                    setState(() {
                                      adr.clear();
                                    }),
                                    setState(() {
                                      getAddress(userData!.content!.id);
                                    }),
                                    await Future.delayed(Duration(seconds: 1)),
                                    if (order.isNotEmpty) {
                                      Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) =>
                                            new CheckOutScreen(
                                              token: token,
                                              service: service,
                                            ),
                                          )),
                                    }
                                  }, MediaQuery.of(context).size.width / 1.7, false),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
    );

  }

  _containerName(desc, padding, height, width, controller, fontSize){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
          child: Text(
            desc,
            style: TextStyle(
        fontFamily: 'comfortaa',
              color: Colors.black38,
              fontSize: MediaQuery.of(context).size.width/25,
            ),
          ),
        ),
        SizedBox(height: padding,),
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),],
            borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height / 160)),
          ),
          child: TextField(
            maxLines: null,
            textInputAction: TextInputAction.done,
            //enabled: false,
            readOnly: true,
            textAlign: TextAlign.left,
            controller: controller,
            style: TextStyle(
        fontFamily: 'comfortaa',fontSize: fontSize),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }
/*
  _raisedButton(text , press, width){
    return  Container(
      width: width,
      // ignore: deprecated_member_use
      child: RaisedButton(
        onPressed: () => press(),
        padding: EdgeInsets.symmetric(vertical: 0,horizontal: MediaQuery.of(context).size.width/10),
        color: MyColors.yellow,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.height / 12))),
        child: Text(
          text,
          style: TextStyle(
        fontFamily: 'comfortaa',
              fontSize: MediaQuery.of(context).size.width / 22,
              color: MyColors.buttonTextColor,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
*/
  _iconText(_color, _icon, text, _mainAxisAlignment){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0, vertical: MediaQuery.of(context).size.height/200),
      child: Row(
        mainAxisAlignment: _mainAxisAlignment,
        children: [
          Icon(_icon,color: _color),
          SizedBox(width: MediaQuery.of(context).size.width/30,),
          Text(text, style: TextStyle(
        fontFamily: 'comfortaa',fontSize: MediaQuery.of(context).size.width/25, color: AppColors.buttonTextColor),
            maxLines:2,
          )
        ],
      ),
    );
  }

  _setState(){
    setState(() {});
  }

  double sumPrice() {
    double price = 0.0;
    for (int i = 0; i < order.length; i++) {
      price = price + order[i][0][0]["Price"] * int.parse(order[i][1]);
      print(price);
    }
    return price;
  }

  void getAddress(var id) async {
    try{
      var url = Uri.parse("$apiDomain/Main/ProfileAddress/ProfileAddress_Read?filter=UserId~eq~'$id'");
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
          },
        );
      } else {
        print(response.statusCode);
        setState(
              () {
            Address = [];
          },
        );
      }
    }catch(e){
      Address = transactions![0].Address;
    }
  }

}
