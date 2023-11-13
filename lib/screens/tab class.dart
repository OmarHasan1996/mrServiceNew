

import 'package:closer/constant/apiUrl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:closer/screens/loading_screen.dart';
import 'package:closer/screens/service/sub_service_dec.dart';

import '../const.dart';
import '../localization_service.dart';

// ignore: must_be_immutable
class SubServiceScreen extends StatefulWidget {
  String token;
  List subservice = [];
  List subservicedec = [];

  SubServiceScreen({required this.token, required this.subservice,});

  @override
  _SubServiceScreenState createState() => _SubServiceScreenState(this.token, this.subservice);
}

class _SubServiceScreenState extends State<SubServiceScreen> {
  String? lng;
  String token;
  List subservice = [];
  List subservicedec = [];
  void getSubServiceDecData(var id) async {
   // print(id);
    var url =
    Uri.parse('${ApiUrl.mainServiceRead}cityid=$cityId&filter=Service.IsMain~eq~false~and~Service.Id~eq~$id');

    http.Response response = await http.get(url, headers: {
      "Authorization": token,
    });
    if (response.statusCode == 200) {

      var item = json.decode(response.body)["result"]['Data'];
      setState(() {
        subservicedec.clear();// = item;
        for(var e in item){
          subservicedec.add(e['Service']);
        }
        //print(subservicedec);
      });

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SubServiceDec(token: token,subservicedec:subservicedec)));

    } else {
      setState(() {
        subservicedec = [];
      });
    }


  }
  _SubServiceScreenState(this.token, this.subservice);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // print(subservice);
  }

  @override
  Widget build(BuildContext context) {
    var barHight = MediaQuery.of(context).size.height / 5.5;
    //getServiceData();

    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: new AppBar(
            toolbarHeight: barHight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24)),
            ),
            backgroundColor: Color(0xff2e3191),
            // bottom: PreferredSize(
            //   preferredSize: Size.fromHeight(MediaQuery.of(context).size.height/5.5),
            //   child: SizedBox(),
            // ),
            //leading: Image.asset('assets/images/Logo1.png'),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/Logo1.png',
                width: MediaQuery.of(context).size.width / 6,
                height: barHight / 2,
              ),
            ),
            actions: [
              new IconButton(
                icon: new Icon(Icons.arrow_back_outlined),
                onPressed: () => Navigator.of(context).pop(),)
            ],
          ),
          backgroundColor: Colors.grey[100],
          body: Column(children: [
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
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 37,
                  horizontal: MediaQuery.of(context).size.width / 22),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  //"Our Services".tr,
                  subservice[0]['Service']['Name'],
                  style: TextStyle(
        fontFamily: 'comfortaa',
                    color: Color(0xff000000),
                    fontSize: MediaQuery.of(context).size.width / 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  //vertical: MediaQuery.of(context).size.height / 37,
                  horizontal: MediaQuery.of(context).size.width / 10),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  //"Our Services".tr,
                  subservice.length.toString()+' Services in ...',
                  style: TextStyle(
        fontFamily: 'comfortaa',
                    color: Color(0xff000000),
                    fontSize: MediaQuery.of(context).size.width / 20,
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: subservice.length,
                itemBuilder: (context, index) {
                  return serviceRow(subservice[index]);
                },
                addAutomaticKeepAlives: false,
              ),
            ),
            Container(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 90,
                      decoration: BoxDecoration(
                        color: Color(0xffffca05),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 10,
                      decoration: BoxDecoration(
                        color: Color(0xff2e3191),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: MediaQuery.of(context).size.width / 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.home_outlined,
                                  color: Color(0xffffca05),
                                  size: MediaQuery.of(context).size.width / 9,
                                ),
                                Text(
                                  'Home'.tr,
                                  style: TextStyle(
        fontFamily: 'comfortaa',
                                    color: Color(0xffffca05),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                  size: MediaQuery.of(context).size.width / 9,
                                ),
                                Text(
                                  'My Order'.tr,
                                  style: TextStyle(
        fontFamily: 'comfortaa',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.face,
                                  color: Colors.white,
                                  size: MediaQuery.of(context).size.width / 9,
                                ),
                                Text(
                                  'My profile'.tr,
                                  style: TextStyle(
        fontFamily: 'comfortaa',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            //icons(Icons.home_outlined, "Home",),
                          ],
                        ),
                      ),
                    ),
                  ],
                ))
          ]),
        ),
      ),
    );
  }

  Column icons(IconData c, String t) {
    return Column(
      children: [
        Icon(
          c,
          size: MediaQuery.of(context).size.width / 9,
          color: Colors.white,
        ),
        Text(
          t,
          style: TextStyle(
        fontFamily: 'comfortaa',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width / 30,
          ),
        )
      ],
    );
  }

  Padding serviceRow(ser) {
    var name = ser['Name'];
    var imagepath = ser['ImagePath'];
    var price = ser['Price'];

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 37,
          horizontal: MediaQuery.of(context).size.width / 22),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.20,
            height: MediaQuery.of(context).size.height / 10,
            decoration: BoxDecoration(

              image: DecorationImage(
                fit: BoxFit.cover,
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
              borderRadius: BorderRadius.all( Radius.circular(20)),

              )
            ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
          GestureDetector(
            onTap: (){
              var id= ser['Id'];
              getSubServiceDecData(id);



            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.65,
              height: MediaQuery.of(context).size.height / 10,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],

                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                     vertical: MediaQuery.of(context).size.height / 80,
                    horizontal: MediaQuery.of(context).size.width / 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(


                          child: FittedBox(
                            child: Text(
                              name,
                              style: TextStyle(
        fontFamily: 'comfortaa',
                                color: Colors.black,
                                fontSize: MediaQuery.of(context).size.width / 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Flexible(

                          child: FittedBox(
                            child: Text(
                              'From '.tr+price.toString()+' \$',
                              style: TextStyle(
        fontFamily: 'comfortaa',
                                color: Colors.grey,
                                fontSize: MediaQuery.of(context).size.width / 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: MediaQuery.of(context).size.width / 20,
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
}
