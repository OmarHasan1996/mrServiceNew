import 'dart:math';

import 'package:closer/constant/app_size.dart';
import 'package:closer/constant/font_size.dart';
import 'package:closer/helper/adHelper.dart';
import 'package:html/parser.dart';

import 'dart:async';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/const.dart';
import 'package:closer/localizations.dart';
import 'package:closer/screens/PickAttachment.dart';
import 'package:image_picker/image_picker.dart';

import 'package:closer/MyWidget.dart';

// ignore: must_be_immutable
class SubServiceDec extends StatefulWidget {
  String token;
  List subservicedec;
  SubServiceDec({required this.token, required this.subservicedec});

  @override
  _SubServiceDecState createState() => _SubServiceDecState(this.token);
}

class _SubServiceDecState extends State<SubServiceDec> {
  String? lng;
  String token;
  List _subservicedec = [];
  TextEditingController _amountController = new TextEditingController();
  var fileTypeList = ['All', 'Image', 'Video', 'Audio', 'MultipleFile'];
  FilePickerResult? result;
  XFile? file;
  File? _file;
  String fileType = 'All';
  TextEditingController noteController = new TextEditingController();

  APIService? api;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  _SubServiceDecState(this.token);
  var _price = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AdHelper.loadInterstitialAd(() => null);
    _amountController.text = "1";
    noteController.text = "";
    widget.subservicedec.forEach((element) {
      _subservicedec.add(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    var barHight = MediaQuery.of(context).size.height / 5.7;
    //getServiceData();
    api = APIService(context: context);
    var discountService = _subservicedec[0]['DiscountsServices'] ??
        _subservicedec[0]['Service']['DiscountsServices'];
    var disAmount = 0.0;
    if (discountService != null && discountService.length > 0) {
      disAmount = discountService[0]['DiscountAmount'];
    }
    _price = _subservicedec[0]['Price'] - disAmount;
    return SafeArea(
      key: _key,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyWidget.appBar(title: '', isMain: false),
        endDrawer: MyWidget(context).drawer(barHight,
            MediaQuery.of(context).size.height / 80 * 3, () => _setState()),
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Column(children: [
            MyWidget.topYellowDriver(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 80,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: SingleChildScrollView(
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        //height: MediaQuery.of(context).size.height,
                        child: !_subservicedec.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //image
                                  GestureDetector(
                                    onTap: () => APIService(context: context).showImage(_subservicedec[0]['ImagePath']),
                                    child: Container(
                                        width: MediaQuery.of(context).size.width /
                                                1.2,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                (0.2 * 0.7),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                _subservicedec[0]['ImagePath']),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 3,
                                              offset: Offset(0,
                                                  1), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      80 *
                                                      2)),
                                        )),
                                  ),

                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 80,
                                  ),
                                  //description
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    height: MediaQuery.of(context).size.height *
                                            (0.7 * 0.7) +
                                        FontSize.s16 * 2,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 3,
                                          offset: Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              80 *
                                              2)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              50,
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              22),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyWidget(context).textTitle15(
                                              AppLocalizations.of(context)!
                                                      .translate('Name') +
                                                  ': ',
                                              bold: true,
                                              scale: 1.2),
                                          SingleChildScrollView(
                                              child: MyWidget(context)
                                                  .textTitle15(
                                                      _subservicedec[0]['Name'],
                                                      bold: true)),
                                          Expanded(
                                              flex: 4,
                                              child: SingleChildScrollView(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: AppHeight.h2,
                                                  ),
                                                  Row(
                                                    children: [
                                                      MyWidget(context).textTitle15(
                                                          AppLocalizations.of(
                                                                      context)!
                                                                  .translate(
                                                                      'Unit') +
                                                              ': ',
                                                          bold: true,
                                                          scale: 1.2),
                                                      MyWidget(context).textTitle15(
                                                          '${_subservicedec[0]['Service']['Unit'] ?? _subservicedec[0]['Unit']}',
                                                          bold: true),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: AppHeight.h2,
                                                  ),
                                                  MyWidget(context).textTitle15(
                                                      AppLocalizations.of(
                                                                  context)!
                                                              .translate(
                                                                  'Description') +
                                                          ":",
                                                      bold: true,
                                                      scale: 1.2),
                                                  MyWidget.htmlScreen(
                                                      _subservicedec[0]['Desc']
                                                          .toString()),
                                                  //MyWidget(context).textTap25(_subservicedec[0]['Desc'].toString(), scale: 1.2, textAlign: TextAlign.start),
                                                  SizedBox(
                                                    height: AppHeight.h1,
                                                  ),
                                                ],
                                              ))),
                                          Expanded(
                                            flex: 1,
                                            child: TextField(
                                              textInputAction:
                                                  TextInputAction.done,
                                              controller: noteController,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              //decoration: InputDecoration(hintText:AppLocalizations.of(context)!.translate('Add your notes here!')),
                                              maxLines: null,
                                              style: TextStyle(
                                                  fontFamily: 'comfortaa',
                                                  color: AppColors.mainColor,
                                                  fontSize: min(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          20,
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          45)),
                                              decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)!
                                                    .translate(
                                                        'Add your notes here!'),
                                                //labelText: labelText,
                                                errorStyle: TextStyle(
                                                    fontFamily: 'comfortaa',
                                                    fontSize: min(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            25,
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            55)),
                                                labelStyle: TextStyle(
                                                  fontFamily: 'comfortaa',
                                                  fontSize: min(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          25,
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          55),
                                                  color: Colors.white,
                                                ),
                                                hintStyle: TextStyle(
                                                  fontFamily: 'comfortaa',
                                                  fontSize: min(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          25,
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          55),
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          80 *
                                                          0,
                                                  vertical:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          1000 *
                                                          0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal:
                                                                  MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      20,
                                                              vertical: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  60 *
                                                                  0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              MyWidget(context).textBlack20(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .translate(
                                                                          "Amount")),
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        MediaQuery.of(context).size.width /
                                                                            20,
                                                                    //  vertical: MediaQuery.of(context).size.height / 160,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                            .grey[
                                                                        200],
                                                                    borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context)
                                                                            .size
                                                                            .height /
                                                                        80 *
                                                                        1.5)),
                                                                  ),
                                                                  child: Row(
                                                                    children: <Widget>[
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            TextFormField(
                                                                          enabled:
                                                                              false, //Not clickable and not editable
                                                                          readOnly:
                                                                              true,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          controller:
                                                                              _amountController,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            border:
                                                                                InputBorder.none,
                                                                          ),
                                                                          keyboardType:
                                                                              TextInputType.numberWithOptions(
                                                                            decimal:
                                                                                false,
                                                                            signed:
                                                                                true,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            MediaQuery.of(context).size.height /
                                                                                20,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: <Widget>[
                                                                            Container(
                                                                              child: InkWell(
                                                                                child: Icon(
                                                                                  Icons.arrow_drop_up,
                                                                                  size: MediaQuery.of(context).size.height / 40,
                                                                                ),
                                                                                onTap: () {
                                                                                  int currentValue = int.parse(_amountController.text);
                                                                                  setState(() {
                                                                                    currentValue++;
                                                                                    _amountController.text = (currentValue).toString(); // incrementing value
                                                                                  });
                                                                                },
                                                                              ),
                                                                            ),
                                                                            InkWell(
                                                                              child: Icon(
                                                                                Icons.arrow_drop_down,
                                                                                size: MediaQuery.of(context).size.height / 40,
                                                                              ),
                                                                              onTap: () {
                                                                                int currentValue = int.parse(_amountController.text);
                                                                                setState(() {
                                                                                  print("Setting state");
                                                                                  currentValue--;
                                                                                  _amountController.text = (currentValue > 1 ? currentValue : 1).toString(); // decrementing value
                                                                                });
                                                                              },
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
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          80 *
                                                          0,
                                                  vertical:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          1000 *
                                                          0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal:
                                                                  MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      20,
                                                              vertical: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  60 *
                                                                  0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              MyWidget(context).textBlack20(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .translate(
                                                                          "Price")),
                                                              Expanded(
                                                                flex: 1,
                                                                child: MyWidget(context).textBlack20(
                                                                    '  ' +
                                                                        prettify(_price *
                                                                            int.parse(_amountController
                                                                                .text)) +
                                                                        ' ' +
                                                                        AppLocalizations.of(context)!.translate(
                                                                            'TRY'),
                                                                    color: AppColors
                                                                        .gray),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        100,
                                  ),
                                  //amount
                                  //attach
                                  /*Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10),
                                      child: MyWidget(context).raisedButton(AppLocalizations.of(context)!.translate('Attachment'), ()=>{camera =false,pickFiles(),}, MediaQuery.of(context).size.width / 1.4, false, padV: 3.0),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(onPressed:()=> {
                                      camera =true,
                                      pickFiles(),}, icon: Icon(Icons.camera_alt_outlined) ,padding: EdgeInsets.only(left:MediaQuery.of(context).size.width / 10),),
                                  )

                                ],
                              ),*/
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        80 *
                                        0,
                                  ),
                                  //add button
                                  MyWidget(context).raisedButton(
                                      AppLocalizations.of(context)!
                                          .translate('Add To MY ORDER'),
                                      () => _addToMyOrder(),
                                      MediaQuery.of(context).size.width / 1.2,
                                      false,
                                      padV: 3.0),
                                  /////////////////////
                                ],
                              )
                            : SizedBox(
                                height: 0,
                              ),
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

  pickFiles() async {
    /*switch (fileType) {
      case 'Image':
        result = await FilePicker.platform.pickFiles(type: FileType.image);
        if (result == null) return;
        file = result!.files.first;
        setState(() {});
        break;
      case 'Video':
        result = await FilePicker.platform.pickFiles(type: FileType.video);
        if (result == null) return;
        file = result!.files.first;
        setState(() {});
        break;
      case 'Audio':
        result = await FilePicker.platform.pickFiles(type: FileType.audio);
        if (result == null) return;
        file = result!.files.first;
        setState(() {});
        break;
      case 'All':
        result = await FilePicker.platform.pickFiles();
        if (result == null) return;
        file = result!.files.first;
        setState(() {});
        break;
      case 'All':
        result = await FilePicker.platform.pickFiles();
        if (result == null) return;
        file = result!.files.first;
        setState(() {});
        break;
      case 'MultipleFile':
        result = await FilePicker.platform.pickFiles(allowMultiple: true);
        if (result == null) return;
        break;
    }*/
    if (camera) {
      file = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 25);
    } else {
      file = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 25);
    }
    print(file!.name);
    /*print(file!.bytes);
    print(file!.size);
    print(file!.extension);*/
    print(file!.path);
    _file = File(file!.path);
    _subservicedec[0]['Service']['File'] = _file;
    print(_subservicedec);
    _flushbar(AppLocalizations.of(context)!
        .translate('Attachment is added... Finish the order to upload'));
    flushBarStatus = true;
    Timer(Duration(seconds: 3), () => {flushBarStatus = false});
    setState(() {});
  }

  bool camera = false;

  _addToMyOrder() {
    setState(() {});
    _subservicedec[0]['Price'] = _price;
    _subservicedec.add({"Notes": noteController.text});
    bool addNew = true;
    order.forEach((element) {
      if (element[0][0]['Id'] == _subservicedec[0]['Id']) {
        addNew = false;
        element[1] = (int.parse(_amountController.text) + int.parse(element[1]))
            .toString();
      }
    });
    if (addNew) {
      order.add([_subservicedec, _amountController.text]);
    }
    //order[order.length] = ;
    print(_subservicedec);
    orderCounter++;
    print(orderCounter);
    prices = prices + _price * int.parse(_amountController.text);

    // print(order[6]);
    //Flushbar().dismiss();

    _subservicedec = [];
    if (!flushBarStatus)
      Navigator.of(context).pop();
    else {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    _flushbar(AppLocalizations.of(context)!
        .translate('Your Order Added To MY ORDER'));

    editTransactionOrder(transactions![0], order);
  }

  _flushbar(text) async {
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
          Radius.circular(MediaQuery.of(context).size.height / 37)),
      backgroundColor: Colors.grey.withOpacity(0.5),
      barBlur: 20,
      message: text,
      messageSize: MediaQuery.of(context).size.width / 22,
    ).show(context);
  }

  bool flushBarStatus = false;

  _camera() async {}

  _setState() {
    setState(() {});
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }
}
