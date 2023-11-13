import 'dart:math';

import 'package:closer/MyWidget.dart';
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/const.dart';
import 'package:closer/constant/app_size.dart';
import 'package:closer/localizations.dart';
import 'package:closer/map/location.dart';
import 'package:closer/screens/signin.dart';
import 'package:closer/screens/superVisior/orderID.dart';
import 'package:closer/screens/worker/taskId.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';

class WorkerOrder extends StatefulWidget {
  WorkerOrder({Key? key, required this.initialOrderTab}) : super(key: key);
  int initialOrderTab = 0;
  @override
  State<WorkerOrder> createState() => _WorkerOrderState();
}

class _WorkerOrderState extends State<WorkerOrder> {
  bool _loading = false, chCircle = false;
  final List _orderData = [];
  final List _finishedOrderData = [];
  final List _superNewOrderData = [];
  @override
  Widget build(BuildContext context) {
    if (isBoss) {
      return DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text(AppLocalizations.of(context)!
              .translate('Tap back again to leave')),
        ),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyWidget.topYellowDriver(),
            ////////////////////////////////////////////////////////////////////
            ////////////////////////////////////////////////////////////////////
            SizedBox(
              height: MediaQuery.of(context).size.height / 160,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 40,
                  horizontal: MediaQuery.of(context).size.width / 20),
              child: Container(
                //alignment: Alignment.topLeft,
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 20,
                    right: MediaQuery.of(context).size.width / 20),
                child: MyWidget(context).textTitle15(
                    AppLocalizations.of(context)!.translate('Supervisor')),
              ),
            ),
            Expanded(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      //vertical: MediaQuery.of(context).size.width / 22,
                      horizontal: MediaQuery.of(context).size.width / 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      DefaultTabController(
                        length: 3, // length of tabs
                        initialIndex: widget.initialOrderTab,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  MediaQuery.of(context).size.height / 51),
                              topRight: Radius.circular(
                                  MediaQuery.of(context).size.height / 51),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.WhiteSelver,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        MediaQuery.of(context).size.height /
                                            51),
                                    topRight: Radius.circular(
                                        MediaQuery.of(context).size.height /
                                            51),
                                  ),
                                ),
                                child: TabBar(
                                  indicatorColor: Colors.transparent,
                                  labelColor: AppColors.yellow,
                                  unselectedLabelColor: Colors.grey,
                                  indicator: const BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  tabs: [
                                    _tap(AppLocalizations.of(context)!
                                        .translate('NewOrders')),
                                    _tap(AppLocalizations.of(context)!
                                        .translate('Current Tasks')),
                                    _tap(AppLocalizations.of(context)!
                                        .translate('FinishedOrders')),
                                  ],
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height /
                                    2.15, //height of TabBarView
                                /*decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    color: Colors.grey,
                                                    width: 0.5))),*/
                                child: TabBarView(
                                  physics: NeverScrollableScrollPhysics(),
                                  children: <Widget>[
                                    ////////// Tab1
                                    Container(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: FutureBuilder(
                                              future: _getMyOrders(
                                                  userData!.content!.id),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snap) {
                                                if (snap.connectionState ==
                                                    ConnectionState.waiting) {
                                                  _loading = true;
                                                  return MyWidget.jumbingDotes(
                                                      _loading);
                                                  return SizedBox();
                                                } else {
                                                  //return SizedBox();
                                                  _loading = false;
                                                  return ListView.builder(
                                                    itemCount:
                                                        _superNewOrderData !=
                                                                null
                                                            ? _superNewOrderData
                                                                .length
                                                            : 0,
                                                    itemBuilder:
                                                        (context, index) {
                                                      //totalPrice =0;
                                                      return GestureDetector(
                                                        onTap: () {
                                                          APIService(
                                                                  context:
                                                                      context)
                                                              .getGroupUsers(
                                                                  groupId);
                                                          Navigator.push(
                                                            this.context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  OrderId(
                                                                      token,
                                                                      _superNewOrderData[
                                                                          index]),
                                                            ),
                                                          ).then((_) {
                                                            setState(() {});
                                                          });
                                                          // order details
                                                          //**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**
                                                          //**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**
                                                          //**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**
                                                        },
                                                        child: myNewOrderSuperVisorlist(
                                                            _superNewOrderData[
                                                                index],
                                                            index + 1),
                                                      );
                                                    },
                                                    addAutomaticKeepAlives:
                                                        false,
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ////////// Tab2
                                    Container(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: FutureBuilder(
                                              future: _getMyOrders(
                                                  userData!.content!.id),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snap) {
                                                if (snap.connectionState ==
                                                    ConnectionState.waiting) {
                                                  _loading = true;
                                                  return MyWidget.jumbingDotes(
                                                      _loading);
                                                  return SizedBox();
                                                } else {
                                                  //return SizedBox();
                                                  _loading = false;
                                                  return ListView.builder(
                                                    itemCount:
                                                        _orderData != null
                                                            ? _orderData.length
                                                            : 0,
                                                    itemBuilder:
                                                        (context, index) {
                                                      //totalPrice =0;
                                                      return GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            this.context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  TaskId(
                                                                      token,
                                                                      _orderData[
                                                                          index]),
                                                            ),
                                                          ).then((_) {
                                                            setState(() {});
                                                          });
                                                          // order details
                                                          //**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**
                                                          //**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**
                                                          //**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**
                                                        },
                                                        child:
                                                            MyWidget.myTasklist(
                                                                _orderData[
                                                                    index],
                                                                index + 1,
                                                                () =>
                                                                    _setState(),
                                                                chCircle),
                                                      );
                                                    },
                                                    addAutomaticKeepAlives:
                                                        false,
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ////////// Tab3
                                    Container(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: FutureBuilder(
                                              future: _getMyOrders(
                                                  userData!.content!.id),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snap) {
                                                if (snap.connectionState ==
                                                    ConnectionState.waiting) {
                                                  _loading = true;
                                                  return MyWidget.jumbingDotes(
                                                      _loading);
                                                  return SizedBox();
                                                } else {
                                                  //return SizedBox();
                                                  _loading = false;
                                                  return ListView.builder(
                                                    itemCount:
                                                        _finishedOrderData
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      //totalPrice =0;
                                                      return GestureDetector(
                                                        onTap: () {
                                                          /*_showOrderDetails(
                                                            finishedOrderData[index],
                                                            index + 1);*/
                                                          // order details
                                                          //**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**
                                                          //**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**
                                                          //**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**//**
                                                        },
                                                        child: myNewOrderSuperVisorlist(
                                                            _finishedOrderData[
                                                                index],
                                                            index + 1),
                                                      );
                                                    },
                                                    addAutomaticKeepAlives:
                                                        false,
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MyWidget.bottomYellowDriver(),
          ],
        ),
      );
    } else {
      //  updateWokerLocationPackground();
      return DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text(AppLocalizations.of(context)!
              .translate('Tap back again to leave')),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyWidget.topYellowDriver(),
            ////////////////////////////////////////////////////////////////////
            ////////////////////////////////////////////////////////////////////
            SizedBox(
              height: MediaQuery.of(context).size.height / 200,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 60,
                  horizontal: MediaQuery.of(context).size.width / 20),
              child: Container(
                //alignment: Alignment.topLeft,
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 20,
                    right: MediaQuery.of(context).size.width / 20),
                child: MyWidget(context).textTitle15(
                    AppLocalizations.of(context)!.translate('Worker')),
              ),
            ),
            Expanded(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      //vertical: MediaQuery.of(context).size.width / 22,
                      horizontal: MediaQuery.of(context).size.width / 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      DefaultTabController(
                        length: 2, // length of tabs
                        initialIndex: widget.initialOrderTab,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  MediaQuery.of(context).size.height / 51),
                              topRight: Radius.circular(
                                  MediaQuery.of(context).size.height / 51),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                decoration: new BoxDecoration(
                                  color: AppColors.WhiteSelver,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        MediaQuery.of(context).size.height /
                                            51),
                                    topRight: Radius.circular(
                                        MediaQuery.of(context).size.height /
                                            51),
                                  ),
                                ),
                                child: TabBar(
                                  indicatorColor: Colors.transparent,
                                  labelColor: AppColors.yellow,
                                  unselectedLabelColor: Colors.grey,
                                  indicator: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  tabs: [
                                    /*_tap(AppLocalizations.of(context)!
                                        .translate('NewOrders')),*/
                                    _tap(AppLocalizations.of(context)!
                                        .translate('New Tasks')),
                                    _tap(AppLocalizations.of(context)!
                                        .translate('Finished Tasks')),
                                  ],
                                ),
                              ),
                              Container(
                                height:
                                    AppHeight.h50 * 1.1, //height of TabBarView
                                /*decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    color: Colors.grey,
                                                    width: 0.5))),*/
                                child: TabBarView(
                                  physics: NeverScrollableScrollPhysics(),
                                  children: <Widget>[
                                    Container(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: FutureBuilder(
                                              future: _getMyOrders(
                                                  userData!.content!.id),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snap) {
                                                if (snap.connectionState ==
                                                    ConnectionState.waiting) {
                                                  _loading = true;
                                                  return MyWidget.jumbingDotes(
                                                      _loading);
                                                } else {
                                                  _loading = false;
                                                  return ListView.builder(
                                                    itemCount:
                                                        _orderData != null
                                                            ? _orderData.length
                                                            : 0,
                                                    itemBuilder:
                                                        (context, index) {
                                                      //totalPrice =0;
                                                      return GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            this.context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  TaskId(
                                                                      token,
                                                                      _orderData[
                                                                          index]),
                                                            ),
                                                          ).then((_) {
                                                            setState(() {});
                                                          });
                                                        },
                                                        child:
                                                            MyWidget.myTasklist(
                                                                _orderData[
                                                                    index],
                                                                index + 1,
                                                                () =>
                                                                    _setState(),
                                                                chCircle),
                                                      );
                                                    },
                                                    addAutomaticKeepAlives:
                                                        false,
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ////////// Tab3
                                    Container(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: FutureBuilder(
                                              future: _getMyOrders(
                                                  userData!.content!.id),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snap) {
                                                if (snap.connectionState ==
                                                    ConnectionState.waiting) {
                                                  _loading = true;
                                                  return MyWidget.jumbingDotes(
                                                      _loading);
                                                } else {
                                                  _loading = false;
                                                  return ListView.builder(
                                                    itemCount:
                                                        _finishedOrderData
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      //totalPrice =0;
                                                      return GestureDetector(
                                                        onTap: () {
                                                          /*Navigator.push(this.context, MaterialPageRoute(builder: (context) => TaskId(token, _finishedOrderData[index]),),).then((_) {
                                                          setState(() {});
                                                        });*/
                                                        },
                                                        child: MyWidget.myTasklist(
                                                            _finishedOrderData[
                                                                index],
                                                            index + 1,
                                                            () => _setState(),
                                                            chCircle),
                                                      );
                                                    },
                                                    addAutomaticKeepAlives:
                                                        false,
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MyWidget.bottomYellowDriver(),
          ],
        ),
      );
    }
  }

  Future _getMyOrders(
    var id,
  ) async {
    await APIService.getMyOrders(id);
    if (myOrders.isNotEmpty) {
      var k = myOrders['Total'];
      _orderData.clear();
      for (int i = 0; i < k; i++) {
        _orderData.add(myOrders['Data'][i]);
      }
      _orderData.sort((a, b) {
        var adate = a['OrderDate']; //before -> var adate = a.expiry;
        var bdate = b['OrderDate']; //before -> var bdate = b.expiry;
        return adate.compareTo(bdate);
      });
      if (!isBoss) {
        _finishedOrderData.clear();
        for (int i = 0; i < _orderData.length; i++) {
          if (_orderData[i]['Status'] == 2) {
            _finishedOrderData.add(_orderData[i]);
            _orderData.removeAt(i);
            i--;
          } else if (_orderData[i]['Status'] == 3 && !isBoss) {
            updateWokerLocationPackground();
          }
        }
      } else {
        for (int i = 0; i < _orderData.length; i++) {
          if (_orderData[i]['OrderService']['Order']['Status'] == 8) {
            //finishedOrderData.add(orderData[i]);
            _orderData.removeAt(i);
            i--;
          }
        }
      }
    } else {
      _orderData.clear();
    }
    if (NewOrdersSupervisor.isNotEmpty) {
      var k = NewOrdersSupervisor['Total'];
      _superNewOrderData.clear();
      for (int i = 0; i < k; i++) {
        for (int j = 0;
            j < NewOrdersSupervisor['Data'][i]['Servicess'].length;
            j++) {
          try {
            if (NewOrdersSupervisor['Data'][i]['Servicess'][j]['GroupId'] ==
                groupId) {
              _superNewOrderData.add(NewOrdersSupervisor['Data'][i]);
              j = NewOrdersSupervisor['Data'][i]['Servicess'].length;
            }
          } catch (e) {}
        }
      }
      _superNewOrderData.sort((a, b) {
        var adate =
            a['OrderDate' /*'InsertDate'*/]; //before -> var adate = a.expiry;
        var bdate =
            b['OrderDate' /*'InsertDate'*/]; //before -> var bdate = b.expiry;
        return bdate.compareTo(adate);
      });
      if (_superNewOrderData.isNotEmpty) {
        _finishedOrderData.clear();
      }
      for (int i = 0; i < _superNewOrderData.length; i++) {
        if (_superNewOrderData[i]['Status'] == 8) {
          _finishedOrderData.add(_superNewOrderData[i]);
          _superNewOrderData.removeAt(i);
          i--;
        }
      }
    }
  }

  _tap(String text) {
    return Tab(
      height: min(AppWidth.w6, AppHeight.h2 * 1.5) * 2,
      child: Center(
        child: GestureDetector(
          onDoubleTap: () {
            setState(() {});
          },
          child: MyWidget(context).textTap25(text),
        ),
      ),
    );
  }

  _setState() {
    setState(() {});
  }

  myNewOrderSuperVisorlist(ord, index) {
    var serial;
    serial = ord['Serial'];
    var Id;
    ord['Servicess'].length > 0 ? Id = ord['Servicess'][0]['OrderId'] : Id = 0;
    var amount = ord['Amount'].toString();
    var date = ord['OrderDate'];
    var addressArea = ord['Address']['Title'] ?? '';
    var addressCity = ord['Address']['Title'] ?? '';
    var statusCode = ord['Status'].toString();
    //statusCode = '2';
    String status = "";
    amount = amount.toString() +
        " \.${AppLocalizations.of(context)!.translate('TRY')} ";
    Color statusColor = Colors.grey;
    for (int i = 0; i < task.length; i++) {
      if (task[i][0]['OrderId'] == Id) statusColor = AppColors.blue;
    }
    String address = addressCity + " / " + addressArea;
    return _orderCard(
        index, statusColor, null, addressArea, amount, date, 1, Id, serial);
  }

  _orderCard(index, statusColor, status, addressArea, amount, String date,
      statusCode, Id, serial,
      {String? taskName}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 200,
          horizontal: MediaQuery.of(context).size.width / 40),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.height / 51),
            side: BorderSide(
              color: statusColor,
              width: 2.0,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 40),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyWidget(context).textBlack20(
                              taskName == null
                                  ? AppLocalizations.of(context)!
                                          .translate('Order Id: ') +
                                      serial.toString()
                                  : taskName,
                              scale: 0.85),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                            //child: Text(),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width / 22 * 0),
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height / 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [Text("")],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: status != null
                                      ? GestureDetector(
                                          onTap: () {},
                                          child: MyWidget(context).textBlack20(
                                              status,
                                              scale: 0.85,
                                              color: statusColor),
                                          /*Icon(
                                Icons.close_outlined,
                                size: MediaQuery.of(context).size.width / 18,
                                color: Colors.grey,
                              ),*/
                                        )
                                      : SizedBox(
                                          height: 0,
                                        ), //IconButton(onPressed: () => rejectOrder(), icon: Icon(Icons.delete_forever_outlined)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          MyWidget(context)
                              .textGrayk28(addressArea, color: Colors.grey)
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 80,
                      ),
                      Divider(
                        color: Colors.grey[900],
                        height: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyWidget(context)
                              .textBlack20(amount.toString(), scale: 0.85),
                          /* SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                            //child: Text(),
                          ),*/
                          Container(
                              alignment: Alignment.centerRight,
                              //width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height / 10,
                              child: MyWidget(context).textBlack20(
                                  DateTime.parse(date.replaceAll('T', ' '))
                                      .add(-timeDiff)
                                      .toString()
                                      .split(' ')[0],
                                  scale: 0.85)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
