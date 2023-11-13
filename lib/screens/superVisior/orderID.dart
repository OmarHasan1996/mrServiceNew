import 'dart:convert';

import 'package:closer/constant/app_size.dart';
import 'package:closer/constant/font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/const.dart';
import 'package:closer/localizations.dart';
import 'package:closer/screens/superVisior/manage_task.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:closer/MyWidget.dart';
import '../loading_screen.dart';
import '../main_screen.dart';
// ignore: must_be_immutable
class OrderId extends StatefulWidget {
  String token;
  var orde;
  OrderId(this.token,this.orde);
  @override
  _OrderIdState createState() => _OrderIdState(token, orde);
}

class _OrderIdState extends State<OrderId> {
  String token;
  APIService? api;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  DropdownMenuItem<String> buildMenuItem(dynamic item) {
    return DropdownMenuItem(
      value: item['Id'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              //Icon(Icons.pin_drop_outlined),
              Flexible(
                child: Text(
                  item['name'],
                  style: TextStyle(
        fontFamily: 'comfortaa',
                    color: AppColors.black,
                  ),
                ),
              ),
              //Icon(Icons.arrow_drop_down_outlined),
            ],
          ),
        ],
      ),
    );
  }

  String _name = '',_location = '',_phone = '',_orderDetails = '', _orderDate = '', _orderTime = '';
  List orderServices = [{'name':'S 1', 'id':'1'},{'name':'S 2', 'id':'2'}];
  var ord;
  _OrderIdState(this.token ,this.ord);
  var id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print(subservicedec);
    id = ord['Serial'];
    var amount = ord['Amount'].toString();
    var date = ord['OrderDate'];
    date = DateTime.parse(ord['OrderDate'].replaceAll('T', ' ')).add(-timeDiff).toString();
    _orderDate= date.split(" ")[0];
    _orderTime  = date.split(" ")[1].toString().split('.')[0];
    //selectedTime = TimeOfDay.now();
    var addressArea = ord['Address']['Title']??'';
    //var addressCity = ord['Address']['Area']['City']['Name'];
    var addressNotes = ord['Address']['notes'];
    var addressBuilding = ord['Address']['building'];
    var addressFloor = ord['Address']['floor'];
    var addressAppartment = ord['Address']['appartment'];
    var statusCode = ord['Status'].toString();
    _name = ord['User']['Name']+' '+ord['User']['LastName'];
    _location = addressArea + " / " + /*addressCity + " / " + */  addressNotes +
        " / " + addressBuilding + " / " + addressFloor + " / " + addressAppartment;
    _phone = ord['User']['Mobile'];
    _orderDetails = ord['Notes'];
    _orderDetails = '';
    orderServices = ord['Servicess'];
    for(int i = 0; i<orderServices.length; i++){
      orderServices.removeWhere((element) => element['GroupId'] != groupId);
    }
    for(int i = 0; i<orderServices.length; i++){
      orderServices[i]['Notes']??= '.......';
      var t = '- ' + orderServices[i]['Service']['Name'] + ':\n' + orderServices[i]['Notes'].toString();
      //t = t + '\n' + '- ' + orderServices[i]['Service']['Name'] + ':\n' + orderServices[i]['Notes'].toString();
      //t = t + '\n' + '- ' + orderServices[i]['Service']['Name'] + ':\n' + orderServices[i]['Notes'].toString();
      if(i==0) _orderDetails = t;
      else _orderDetails = _orderDetails + '\n' + t;
    }
  }

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
          appBar: MyWidget.appBar(title: AppLocalizations.of(context)!.translate('Order Id: ') +'$id', withoutCart: true),
          endDrawer: MyWidget(context).drawer(barHight, MediaQuery.of(context).size.height / 80 * 3, ()=>_setState()),
          backgroundColor: Colors.grey[100],
          body: SingleChildScrollView(
            child: Column(children: [
              MyWidget.topYellowDriver(),
              SizedBox(
                height: MediaQuery.of(context).size.height / 180,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: leftPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: AppHeight.h1,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height *(0.75),
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
                            horizontal: MediaQuery.of(context).size.width / 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/200),
                              child: Text(
                                AppLocalizations.of(context)!.translate('Address Details'),
                                style: TextStyle(
        fontFamily: 'comfortaa',
                                  color: AppColors.black,
                                  fontSize: MediaQuery.of(context).size.width / 22,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            _iconText(Colors.grey, Icons.person, _name, MainAxisAlignment.start),
                            _iconText(Colors.grey, Icons.location_on_outlined, _location, MainAxisAlignment.start),
                            _iconText(Colors.grey, Icons.call, _phone, MainAxisAlignment.start),
                            SizedBox(height: MediaQuery.of(context).size.height/80,),
                            Divider(height: 1, thickness: 2, color: Colors.grey[400],),
                            SizedBox(height: MediaQuery.of(context).size.height/80,),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/200),
                              child: Text(
                                AppLocalizations.of(context)!.translate('Order Details'),
                                style: TextStyle(
        fontFamily: 'comfortaa',
                                  color: AppColors.black,
                                  fontSize: MediaQuery.of(context).size.width / 22,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height/13,
                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/200),
                              child: Scrollbar(
                                //isAlwaysShown: true,
                                child: SingleChildScrollView(
                                  //scrollDirection: Axis.vertical,
                                  child: Text(
                                    _orderDetails,
                                    maxLines: null,
                                    style: TextStyle(
        fontFamily: 'comfortaa',
                                      color: Colors.grey,
                                      fontSize: MediaQuery.of(context).size.width / 30,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height/200,),
                            Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: _iconText(Colors.grey, Icons.timer, _orderTime, MainAxisAlignment.start)
                                ),
                                Expanded(
                                    flex: 3,
                                    child: _iconText(Colors.grey, Icons.date_range_outlined, _orderDate, MainAxisAlignment.end)),
                              ],
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height/80,),
                            Divider(height: 1, thickness: 2, color: Colors.grey[400],),
                            SizedBox(height: MediaQuery.of(context).size.height/80,),
                            Expanded(
                              child: Container(
                                height: MediaQuery.of(context).size.height/7,
                                child: _manageServiceList(),
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height/80,),
                            MyWidget(context).raisedButton(AppLocalizations.of(context)!.translate('Finish the order'), () => _finishOrder(), AppWidth.w70, chCircle)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
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

  _manageServiceList(){
    return ListView.builder(
      key: UniqueKey(),
      itemCount: orderServices.length,
      itemBuilder: (context, index) {
        var _color = AppColors.black;
        for(int i = 0; i < task.length; i++){
          if(task[i][0]['Service']['Id'] == orderServices[index]['Id'])
            _color = AppColors.blue;
        }
        return Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width/2.8,
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/25*0),
              child: Text(
                orderServices[index]['Service']['Name'],
                maxLines: null,
                //textAlign: TextAlign.center,
                style: TextStyle(
        fontFamily: 'comfortaa',
                  color: _color,
                  fontSize: MediaQuery.of(context).size.width/22,
                ),
              ),
            ),
            Expanded(child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/80),
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width/2,
              //height: MediaQuery.of(context).size.height/20,
              child: _manageButton(index),
            )
            )
          ],
        );;
      },
      // addAutomaticKeepAlives: false,
    );
  }

  _manageButton(id){
    // ignore: deprecated_member_use
    return MyWidget(context).raisedButton(AppLocalizations.of(context)!.translate('Manage Tasks'), ()=>{
      Navigator.push(this.context, MaterialPageRoute(builder: (context) => ManageTask(token, _name, _location, _phone, _orderDetails, _orderTime, _orderDate, ord['Id'] ,orderServices[id]),),).then((_) {
        setState(() {});
      }),
    }, AppWidth.w30, false, textH: FontSize.s14);
  }

  _iconText(_color, _icon, text, _mainAxisAlignment){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0, vertical: MediaQuery.of(context).size.height/200),
      child: Row(
        mainAxisAlignment: _mainAxisAlignment,
        children: [
          Icon(_icon,color: _color),
          SizedBox(width: MediaQuery.of(context).size.width/30,),
          Expanded(child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(text, style: TextStyle(
        fontFamily: 'comfortaa',fontSize: MediaQuery.of(context).size.width/28, color: AppColors.buttonTextColor),),
          )),
        ],
      ),
    );
  }

  _setState(){
    setState(() {});
  }


  bool chCircle = false;
  _finishOrder() async{
    setState(() {
      chCircle = true;
    });
    List tasks = [];
    tasks.clear();
    var k = 0;
    if(myOrders.length > 0)
      k = myOrders['Data'].length;
    for(int i=0; i < k; i++){
      if(myOrders['Data'][i]['OrderService']['Order']['Id'] == ord['Id']){
        tasks.add(myOrders['Data'][i]);
      }
    }
    String endDate = DateFormat('yyyy-MM-dd hh:mm:ss.sss').format(DateTime.now().add(timeDiff)).replaceAll(" ", "T") + "Z";
    //var fcmToken = '';
    for(int i = 0; i<tasks.length; i++){
      if(tasks[i]['Status'] != 2){
        await api!.updateWorkerTask(tasks[i]['Id'], tasks[i]['WorkerId'], tasks[i]['OrderServicesId'], tasks[i]['Notes'], tasks[i]['StartDate'], endDate, 'workerNotes', token, tasks[i]['Name'], 'null', tasks[i]['User']['FBKey'], '_mainOrderId');
      }
    }
    await api!.updateOrder(token, ord, 8, null, null, null);
    //await getMyOrders();
    setState(() {
      chCircle = false;
    });
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(token: token, service: service, selectedIndex: 1, initialOrderTab: 2,)),
            (Route<dynamic> route) => false,
      );
  }

  Future getMyOrders() async {
    try{
      /*filter=UserId~eq~'$id'*/
      var url = Uri.parse("$apiDomain/Main/WorkerTask/WorkerTask_Read?filter=OrderService.Order.GroupId~eq~$groupId");
      http.Response response = await http.get(
        url, headers: {
        "Authorization": token,
      },);
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        print("getOrderders success");
        myOrders = await jsonDecode(response.body);
        editTransactionMyOrders(transactions![0], myOrders);
        //print(myOrders);
        //print("****************************");
        //print(jsonDecode(response.body));
      }
    }catch(e){
      //myOrders.clear();
      //myOrders = transactions![0].myOrders;
    }
  }

}
