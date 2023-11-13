
import 'dart:convert';

import 'package:closer/constant/app_size.dart';
import 'package:flutter/material.dart';
import 'package:closer/MyWidget.dart';
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';

import 'package:closer/const.dart';
import 'package:closer/localizations.dart';

import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../loading_screen.dart';
import '../main_screen.dart';
import 'package:http/http.dart' as http;

class AddTask extends StatefulWidget {
  String token, _orderId;
  var service;
  AddTask(this.token, this.service, this._orderId);
  @override
  _AddTaskState createState() => _AddTaskState(token, service, _orderId);
}

class _AddTaskState extends State<AddTask> {
  String token, _orderId;
  var _service;
  _AddTaskState(this.token, this._service, this._orderId);
  APIService? api;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  TextEditingController descriptionController = new TextEditingController();
  TextEditingController _taskNameController = new TextEditingController();

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
                    fontSize: MediaQuery.of(context).size.width/25,
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

  @override
  void initState(){
    // TODO: implement initState
    getWorkers(userData!.content!.id);
    super.initState();
    _dateController.text = DateTime.now().day.toString() + '/' + DateTime.now().month.toString() + '/' + DateTime.now().year.toString() ;
    _timeController.text =  DateTime.now().hour.toString() + ' : ' + DateTime.now().minute.toString();
    selectedTime = TimeOfDay(hour: int.parse(_timeController.text.split(':')[0]),minute: int.parse(_timeController.text.split(':')[1]));
    //print(subservicedec);

     // descriptionController.text = 'Description NameDescription NameDescription NameDescription NameDescription NameDescription NameDescription NameDescription NameDescription Name';
  }

  @override
  Widget build(BuildContext context) {
    _refreshIndexWorker();
    var barHight = MediaQuery.of(context).size.height / 5.7;
    //getServiceData();
    api = APIService(context: context);
    var leftPadding = MediaQuery.of(context).size.width/12;

    return SafeArea(
        child: Scaffold(
          key: _key,
          resizeToAvoidBottomInset: true,
          appBar: MyWidget.appBar(title: AppLocalizations.of(context)!.translate('Add Task'), withoutCart: true),
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 80,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: MediaQuery.of(context).size.height *(0.72),
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
                              _containerName(AppLocalizations.of(context)!.translate('Task Name'), MediaQuery.of(context).size.height/160,
                                  MediaQuery.of(context).size.height/14,
                                  MediaQuery.of(context).size.width,
                                  _taskNameController,
                                  MediaQuery.of(context).size.width/20,
                                  AppLocalizations.of(context)!.translate('Ex.Task 1')

                              ),
                              SizedBox(height: MediaQuery.of(context).size.height/80,),
                              _containerName(AppLocalizations.of(context)!.translate('Description'), MediaQuery.of(context).size.height/160,
                                  MediaQuery.of(context).size.height/8,
                                  MediaQuery.of(context).size.width,
                                  descriptionController,
                                  MediaQuery.of(context).size.width/20,
                                  AppLocalizations.of(context)!.translate('add your description')
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height/80,),
                              Row(children: [
                                _dateCard(),
                                SizedBox(width: MediaQuery.of(context).size.width/35,),
                                _timeCard(),
                              ],),
                              SizedBox(height: MediaQuery.of(context).size.height/80,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
                                child: Text(
                                  AppLocalizations.of(context)!.translate('Choose Worker'),
                                  style: TextStyle(
        fontFamily: 'comfortaa',
                                    color: AppColors.black,
                                    fontSize: MediaQuery.of(context).size.width/18,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: _chooseWorkerList(),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height/80,),
                              _raisedButton(AppLocalizations.of(context)!.translate('Send Worker'), () => _addTAsk(), AppWidth.w70)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
             ]),
          ),
        ),
    );
  }


  _containerName(desc, padding, height, width, controller, fontSize, hint){
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
          child: Scrollbar(
            //isAlwaysShown: true,
            child: TextField(
            showCursor: true,
            maxLines: null,
            textInputAction: TextInputAction.done,
            //enabled: false,
            //readOnly: true,
            textAlign: TextAlign.left,
            controller: controller,
            style: TextStyle(
        fontFamily: 'comfortaa',fontSize: fontSize),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
        fontFamily: 'comfortaa',fontSize: fontSize/1.5, color: Colors.black26),
              border: InputBorder.none,
            ),
          ),),
        )
      ],
    );
  }

  _chooseWorkerList(){
    String? _setDropValue(index){
      String? v = '';
      try{
        v = value3[index]['name'];
        //worker.removeWhere((item) => item['Id'] == v);
      }catch(e){
        v = null;
      }
      return v;
    }
    return ListView.builder(
      key: UniqueKey(),
      itemCount: indexWorker,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
              child: Text(
                AppLocalizations.of(this.context)!.translate('Worker') + ' ' + (index+1).toString(),
                style: TextStyle(
        fontFamily: 'comfortaa',
                  color: AppColors.black,
                  fontSize: MediaQuery.of(context).size.width/22,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/100),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
              width: MediaQuery.of(context).size.width/2.5,
              height: MediaQuery.of(context).size.height/22,
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
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _setDropValue(index),
                  iconSize: 0.0,
                  hint: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      /*Expanded(
                      flex: 9,
                      child: Text(
                        "City/Town/Near By Near By something",
                        overflow:
                        TextOverflow
                            .ellipsis,
                        style: TextStyle(
        fontFamily: 'comfortaa',
                          fontSize: MediaQuery.of(
                              context)
                              .size
                              .width /
                              30,
                        ),
                      )),*/
                      Icon(Icons.arrow_drop_down_outlined),
                    ],
                  ),
                  items: worker.map(buildMenuItem).toList(),
                  onChanged: (value) =>
                      setState(() {
                        this.value3[index] = {"number":index.toString(),"name":value};
                      }),
                ),
              ),
            )
          ],
        );
      },
      // addAutomaticKeepAlives: false,
    );
  }

  List worker =[];
  List value3 =[];
  var indexWorker = 1;
  bool chCircle = false;

  _refreshIndexWorker(){
    indexWorker = 1;
    /*try{
      for(int i = 0; i<value3.length; i++){
        if(value3[i].length > 0)
          indexWorker++;
      }
    }catch(e){

    }*/
  }

  _raisedButton(text , press(), width){
    return MyWidget(context).raisedButton(text, ()=>press(), width, chCircle);
    /*return  Container(
      width: width,
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 20,
          vertical: MediaQuery.of(context).size.height / 1000*0),
      // ignore: deprecated_member_use
      child: RaisedButton(
        onPressed: () => {
          press(),
        },
        padding: EdgeInsets.symmetric(vertical: 0,horizontal: MediaQuery.of(context).size.width/7),
        color: MyColors.yellow,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.height / 12))),
        child: chCircle == true
            ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              MyColors.blue),
          backgroundColor: Colors.grey,
        )
            : Text(
          text,
          style: TextStyle(
        fontFamily: 'comfortaa',
              fontSize: MediaQuery.of(context).size.width / 22,
              color: MyColors.buttonTextColor,
              fontWeight: FontWeight.bold),
        ),
      ),
    );*/
  }

  _addTAsk() async{
    setState(() {
      chCircle = true;
    });
    navigat(){
      Navigator.of(context).pop();
      Navigator.of(context).pop();

    }
    //task.clear();
    List _workerss = [];
    for(int i = 0; i< value3.length; i++){
      if(value3[i] != ''){
        for(int j=0; j<worker.length; j++){
          if(worker[j]['Id'] == value3[i]['name'])
            _workerss.add([{'Name':worker[j]['name'],'Id':worker[j]['Id'], 'fcmToken':worker[j]['fcmToken']}]);
        }
      }
    }
    if(_taskNameController.text == '' || descriptionController.text == '' || _workerss.length == 0 )
      APIService.flushBar('Please! Fill all information before confirm');
    else {
      var startDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime!.hour, selectedTime!.minute).add(timeDiff).toString().replaceAll(" ", "T") + "Z";
      task.add([{'StartDate':startDateTime, 'TaskName':_taskNameController.text, 'Description':descriptionController.text, 'Workers' : _workerss, 'Service': _service, 'OrderId': _orderId}]);
      for(int i = 0; i<task.length; i++){
        var _task = task[i];
        var Id = _task[0]['Service']['Id'];
        var name = _task[0]['TaskName'];
        var _workersName = '';
        for(int i = 0; i<_task[0]['Workers'].length; i++){
          if(_workersName != '')
            _workersName = _workersName + ' , ' + _task[0]['Workers'][i][0]['Name'];
          else
            _workersName = _workersName + ' ' + _task[0]['Workers'][i][0]['Name'];
        }
        bool upload = false;
        for(int i=0; i<_task[0]['Workers'].length; i++) {
          upload = await api!.createWorkerTask(
            _task[0]['OrderId'],
            _task[0]['Workers'][i][0]['Id'],
            _task[0]['Service']['Id'],
            _task[0]['Description'],
            _task[0]['StartDate'],
            ' endDate',
            'workerNotes',
            token,
            _task[0]['Workers'][i][0]['fcmToken'],
            _task[0]['TaskName'],
          );
        }
        if (upload) {
          await getMyOrders();
          APIService.flushBar(name + ' ' +
              AppLocalizations.of(context)!.translate('has been added to') +
              _workersName);
          MyWidget(context).deleteTask(task, Id, _task[0]['Workers'], name);
          setState(() {
            chCircle = false;
          });
          var duration = new Duration(seconds:2);
          return new Timer(duration, navigat);
        }
        //await api!.createWorkerTask(orderId, workerId, serviceId, supervisorNotes, startDate, endDate, workerNotes, token);
      }
    }
    setState(() {
      chCircle = false;
    });

  }

  getWorkers(var id) async {
    setState(()
    {
      worker.clear();
      for(int i =0; i< groupUsers.length; i++){
        String? fcm = groupUsers[i]['Users']['FBKey'];
        if(groupUsers[i]['isBoss'] == false)
          worker.add({'Id':groupUsers[i]['UserId'].toString(),'fcmToken':fcm,'name':groupUsers[i]['Users']['Name']+' '+groupUsers[i]['Users']['LastName']});
      }
    });
    value3.clear();
    for(int i=0; i<worker.length; i++){
      value3.add('');
    }
  }

  _setState(){
    setState(() {});
  }

  String? _setTime, _setDate;

  TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2021),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        print("this is the Date");
        print(selectedDate);
        print("timeZone");
        print(DateTime.now().timeZoneName);
        print(DateTime.now().timeZoneOffset);
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  TimeOfDay? selectedTime;
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectTime(BuildContext context) async {
    //selectedTime = TimeOfDay(hour: int.parse(_timeController.text.split(':')[0]),minute: int.parse(_timeController.text.split(':')[1]));
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime as TimeOfDay,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        print("this is the Time");
        print(selectedTime!.hour);
        var _hour = selectedTime!.hour.toString();
        var _minute = selectedTime!.minute.toString();
        var _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
       /* _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime!.hour, selectedTime!.minute),
            [hh, ':', nn, " ", am]).toString();*/
      });
  }

  _dateCard() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height / 160,
      ),
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width / 2.9,
      height: MediaQuery.of(context).size.height / 13,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.all(
            Radius.circular(MediaQuery.of(context).size.height / 80)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 40,
          vertical: MediaQuery.of(context).size.height / 60*0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.date_range, color: AppColors.black,),
            Expanded(
              flex: 1,
              child:InkWell(
                onTap: () {
                    _selectDate(context);
                },
                child: TextFormField(
                  style:
                  TextStyle(
        fontFamily: 'comfortaa',fontSize: MediaQuery.of(context).size.width / 22, color: AppColors.black),
                  textAlign: TextAlign.center,
                  enabled: false,
                  keyboardType: TextInputType.text,
                  controller: _dateController,
                  onSaved: (String? val) {
                    _setDate = val;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _timeCard() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height / 160,
      ),
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width / 3.1,
      height: MediaQuery.of(context).size.height / 13,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.all(
            Radius.circular(MediaQuery.of(context).size.height / 80)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 40,
          vertical: MediaQuery.of(context).size.height / 60*0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.timer_outlined, color: AppColors.black),
            Expanded(
              flex: 1,
              child:InkWell(
                onTap: () {
                    _selectTime(context);
                },
                child: TextFormField(
                  style:
                  TextStyle(
        fontFamily: 'comfortaa',fontSize: MediaQuery.of(context).size.width / 22, color: AppColors.black),
                  textAlign: TextAlign.center,
                  enabled: false,
                  keyboardType: TextInputType.text,
                  controller: _timeController,
                  onSaved: (String? val) {
                    _setTime = val;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
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
