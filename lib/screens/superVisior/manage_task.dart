import 'dart:convert';

import 'package:closer/constant/app_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/const.dart';
import 'package:closer/localizations.dart';
import 'package:closer/screens/superVisior/addTask.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:closer/screens/main_screen.dart';

import '../../MyWidget.dart';
import '../loading_screen.dart';

class ManageTask extends StatefulWidget {
  String token;

  String _name = '', _location = '',_phone = '',_orderDetails = '', _orderDate = '', _orderTime = '', _orderId = '';
  var service;
  ManageTask(this.token,this._name, this._location, this._phone, this._orderDetails, this._orderTime, this._orderDate, this._orderId, this.service, );
  @override
  _ManageTaskState createState() => _ManageTaskState(token,_name, _location, _phone, _orderDetails, _orderTime, _orderDate, _orderId, service);
}

class _ManageTaskState extends State<ManageTask> {
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
              Flexible(
                child: Text(
                  item['name'],
                  style: TextStyle(
        fontFamily: 'comfortaa',
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _name = '', _location = '',_phone = '',_orderDetails = '', _orderDate = '', _orderTime = '', _orderId, attach = '';
  var _service;
  String token;

  _ManageTaskState(this.token,this._name, this._location, this._phone, this._orderDetails, this._orderTime, this._orderDate, this._orderId, this._service);
  List tasks =[];

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
    try{
      attach = _service['OrderServiceAttatchs'][0]['FilePath'];
    }catch(e){
      attach = '';
    }
  }

  void _afterLayout(Duration timeStamp) {
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    var barHight = MediaQuery.of(context).size.height / 5.7;
    api = APIService(context: context);
    var leftPadding = MediaQuery.of(context).size.width/12;

    return Scaffold(
          key: _key,
          resizeToAvoidBottomInset: true,
          appBar: MyWidget.appBar(title: '', withoutCart: true),
          endDrawer: MyWidget(context).drawer(barHight, MediaQuery.of(context).size.height / 80 * 3, ()=>_setState()),
          backgroundColor: Colors.grey[100],
          body: SingleChildScrollView(
            child: Column(children: [
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/25),
                      child: Text(
                        AppLocalizations.of(context)!.translate('Manage Tasks') + ' (' + _service['Service']['Name'] + ')',
                        maxLines: 1,
                        style: TextStyle(
        fontFamily: 'comfortaa',
                          color: AppColors.black,
                          fontSize: MediaQuery.of(context).size.width / 19,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 180,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      //height: MediaQuery.of(context).size.height *(0.4),
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
                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/200*0),
                              child: Text(
                                AppLocalizations.of(context)!.translate('Address Details'),
                                style: TextStyle(
        fontFamily: 'comfortaa',
                                  color: AppColors.black,
                                  fontSize: MediaQuery.of(context).size.width / 25,
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
                                AppLocalizations.of(context)!.translate('Service Attachment:'),
                                //AppLocalizations.of(context)!.translate('Order Details'),
                                style: TextStyle(
        fontFamily: 'comfortaa',
                                  color: AppColors.black,
                                  fontSize: MediaQuery.of(context).size.width / 22,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                _netWorkImage(attach),
                                //_netWorkImage(_service['OrderServiceAttatchs']['FilePath']),
                              ],
                            ),
                            /*Container(
                            height: MediaQuery.of(context).size.height/15,
                            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/200),
                            child: Scrollbar(
                              isAlwaysShown: true,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
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
                                  child: _iconText(Colors.grey, Icons.timer, _orderTime, MainAxisAlignment.start)),
                              Expanded(
                                  flex: 3,
                                  child: _iconText(Colors.grey, Icons.date_range_outlined, _orderDate, MainAxisAlignment.end)),
                            ],
                          ),*/
                            SizedBox(height: MediaQuery.of(context).size.height/100,),
                            Divider(height: 1, thickness: 2, color: Colors.grey[400],),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/80,),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height *(0.22),
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
                            vertical: MediaQuery.of(context).size.height / 80,
                            horizontal: MediaQuery.of(context).size.width / 15),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/200*0),
                                child: Text(
                                  AppLocalizations.of(context)!.translate('List Of Tasks'),
                                  style: TextStyle(
        fontFamily: 'comfortaa',
                                    color: AppColors.black,
                                    fontSize: MediaQuery.of(context).size.width / 23,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height/180,),
                              Container(
                                height: MediaQuery.of(context).size.height *(0.09),
                                child: _taskList(),
                              ),
                              Expanded(child: _addTaskButton())
                            ],
                          ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/180,),
                    _raisedButton(AppLocalizations.of(context)!.translate('Ok'), () => _finishAllTasks(), AppWidth.w70),
                  ],
                ),
              ),
            ]),
          ),
    );

  }


  _taskList(){
    List _task = [];
    _task.clear();
    var k = 0;
    if(myOrders.length > 0)
      k = myOrders['Data'].length;
    for(int i=0; i < k; i++){
      if(myOrders['Data'][i]['OrderServicesId'] == _service['Id']){
        _task.add(myOrders['Data'][i]);
      }
    }
    tasks = _task;
    if(_task.length>0)
      return ListView.builder(
        key: UniqueKey(),
        itemCount: _task.length,
        itemBuilder: (context, index) {
          var _workersName =  _task[index]['User']['Name'] + ' ' + _task[index]['User']['LastName'];
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/25*0),
                    child: Text(
                      _task[index]['Name'].toString(),
                      style: TextStyle(
        fontFamily: 'comfortaa',
                        color: _task[index]['Status'] == 2 ? AppColors.blue : AppColors.black,
                        fontSize: MediaQuery.of(context).size.width/24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(_workersName, textAlign: TextAlign.end,
                      style: TextStyle(
        fontFamily: 'comfortaa',
                        color:  _task[index]['Status'] == 2 ? AppColors.blue : AppColors.black,
                        fontSize: MediaQuery.of(context).size.width/28,
                      ),),
                  )
                ],
              ),
              Divider(height: 1, thickness: 2, color: Colors.grey[400],),
              SizedBox(height: MediaQuery.of(context).size.height/160,),
            ],
          );
        },
        // addAutomaticKeepAlives: false,
      );
    else
      return Center(
        child:Text(
          AppLocalizations.of(context)!.translate('press add task to assign new worker'),
          style: TextStyle(
        fontFamily: 'comfortaa',
            color: Colors.grey,
            fontSize: MediaQuery.of(context).size.width/24,
          ),
          textAlign: TextAlign.center,
        ),
      );
  }

  bool chCircle = false;
  _raisedButton(text , press(), width){
    return MyWidget(context).raisedButton(text, ()=>press(), width, chCircle);
  }

  _addTaskButton(){
    return Container(
      alignment: Alignment.bottomRight,
      child: MyWidget(context).raisedButton(AppLocalizations.of(context)!.translate('add task'), ()=>  {
        Navigator.push(this.context, MaterialPageRoute(builder: (context) => AddTask(token, _service, _orderId),),).then((_) {
          setState(() {});
        }),
      }, MediaQuery.of(context).size.width/1.5, false),
    );
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
        fontFamily: 'comfortaa',fontSize: MediaQuery.of(context).size.width/25, color: AppColors.buttonTextColor),),
          )),
        ],
      ),
    );
  }

  _finishAllTasks() async{
    Navigator.of(context).pop();
   // _key.currentState!.openEndDrawer();
    /*if(tasks.length == 0) return;
    setState(() {
      chCircle = true;
    });
    String endDate = DateFormat('yyyy-MM-dd hh:mm:ss.sss').format(DateTime.now().add(timeDiff)).replaceAll(" ", "T") + "Z";
    //var fcmToken = '';
    for(int i = 0; i<tasks.length; i++){
      if(tasks[i]['Status'] != 2){
        await api!.updateWorkerTask(tasks[i]['Id'], tasks[i]['WorkerId'], tasks[i]['OrderServicesId'], tasks[i]['Notes'], tasks[i]['StartDate'], endDate, 'workerNotes', token, tasks[i]['Name'], 'null', tasks[i]['User']['FBKey']);
      }
    }
    await getMyOrders();
    setState(() {
      chCircle = false;
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainScreen(token: token, service: service, selectedIndex: 1, initialOrderTab: 1,)),
          (Route<dynamic> route) => false,
    );*/
  }

  _setState(){
    setState(() {});
  }

  _netWorkImage(netWorkImage){
    if(netWorkImage != '')
      return InteractiveViewer(
        boundaryMargin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        minScale: 1,
        maxScale: 3,
        child: GestureDetector(
          onTap: () => api!.showImage(netWorkImage),
          child:Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height / 7,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: NetworkImage(netWorkImage),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(
                  MediaQuery.of(context).size.height / 100)),
            ),
        ),),
    );
    else
      return SizedBox(
        height: MediaQuery.of(context).size.height / 7,
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
