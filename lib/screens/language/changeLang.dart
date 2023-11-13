import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/const.dart';
import 'package:closer/localization_service.dart';
import 'package:closer/localizations.dart';

import '../../MyWidget.dart';

class ChangeLang extends StatefulWidget {
  @override
  _ChangeLangState createState() => _ChangeLangState();
}

class _ChangeLangState extends State<ChangeLang> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  APIService? api;
  @override
  void initState() {
    super.initState();
    lang = box.read('lng');
    if(lang == 'English') en = true;
    if(lang == 'France') fr = true;
    if(lang == 'العربية') ar = true;
    if(lang == 'Turkish') tr = true;
  }

  @override
  Widget build(BuildContext context) {
    var barHight = MediaQuery.of(context).size.height / 5.7;
    api = APIService(context: context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      appBar: _appBar(barHight),
      endDrawer: MyWidget(context).drawer(barHight, MediaQuery.of(context).size.height / 80 * 3, ()=>_setState()),
      backgroundColor: Colors.grey[100],
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child:  Column(
            children: [
              MyWidget.topYellowDriver(),
              SizedBox(
                height: MediaQuery.of(context).size.height / 40,
              ),
              MyWidget(context).textHead10(AppLocalizations.of(context)!.translate("lang"), color: AppColors.black),
             /*SizedBox(
                height: MediaQuery.of(context).size.height / 80,
              ),*/
              _card(MediaQuery.of(context).size.width,),
              MyWidget(context).raisedButton(AppLocalizations.of(context)!.translate('Save'), ()=>_save(), MediaQuery.of(context).size.width/1.2, chLogIn),
              //_card(AppLocalizations.of(context)!.translate('card number'), cardNumberControler, '', MediaQuery.of(context).size.width, false),
            ],
          ),
        ),
      ),
    );
  }

  _appBar(barHight){
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: barHight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(MediaQuery.of(context).size.height / 80 * 3),
            bottomLeft: Radius.circular(MediaQuery.of(context).size.height / 80 * 3)),
      ),
      backgroundColor: AppColors.blue,
      title: MyWidget(context).appBarTittle(barHight, _scaffoldKey),
      actions: [
        new IconButton(
          icon: new Icon(Icons.close_outlined),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
      //leading: SizedBox(height: 0,width: 0,),
    );
  }

  final box = GetStorage();
  var lang;
  bool en = false;
  bool fr = false;
  bool ar = false;
  bool tr = false;

  _card(width){
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height / 80,
        horizontal: MediaQuery.of(context).size.width / 15,
      ),
      child: Container(
        alignment: Alignment.centerLeft,
        width: width,
        height: MediaQuery.of(context).size.height / 2.2,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(
                  0, 1), // changes position of shadow
            ),
          ],
          borderRadius:
          BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height / 51)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 20,
            vertical: MediaQuery.of(context).size.height / 40,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: _checkListEN(AppLocalizations.of(context)!.translate("english"), "English")
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height /80,
              ),
              Divider(
                height: 1,
                thickness: 2,
                color: Colors.grey[400],
              ),
              /*Expanded(
                flex: 1,
                child: _checkListFR(AppLocalizations.of(context)!.translate("france"), "France")
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height /80,
              ),
              Divider(
                height: 1,
                thickness: 2,
                color: Colors.grey[400],
              ),*/
              Expanded(
                flex: 1,
                child: _checkListAR(AppLocalizations.of(context)!.translate("arabic"), "Arabic")
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height /80,
              ),
              Divider(
                height: 1,
                thickness: 2,
                color: Colors.grey[400],
              ),
              Expanded(
                flex: 1,
                child: _checkListTR(AppLocalizations.of(context)!.translate("Turkish"), "Turkish")
              ),
            ],
          ),
        ),
      ),
    );
  }

  var chLogIn = false;

/*
  _bottun(text,press){
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/80),
      width: MediaQuery.of(context).size.width/1.2,
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.height / 12)),
        color: MyColors.yellow,
        child: chLogIn == true
            ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              MyColors.blue),
          backgroundColor: Colors.grey,
        )
            : Text(text,
          style: TextStyle(
        fontFamily: 'comfortaa',
              fontSize:
              MediaQuery.of(context).size.width / 20,
              color: MyColors.buttonTextColor,
              fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          press();
        },
      ),

    );
  }
*/
  _checkListEN(text1, text2){
    return Padding(padding:  EdgeInsets.symmetric(
      vertical: MediaQuery.of(context).size.height / 80,
      horizontal: MediaQuery.of(context).size.width / 15,
    ),
        child: Transform.scale(scale: 1.3,
          child: CheckboxListTile(
            title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyWidget(context).textBlack20(text1, bold: false),
            MyWidget(context).textBlack20(text1, bold: false, color: Colors.grey, scale: 0.8),
           ],
        ),
            controlAffinity: ListTileControlAffinity.trailing,
            value: en,
            onChanged: (bool? value) {
              setState(() {
                if(value == true){
                  lang = AppLocalizations.of(context)!.translate('english');
                  en = value!;
                  fr = ar = tr = !value;
                }
              });
              },
            activeColor: AppColors.yellow,
            checkColor: AppColors.black,
        //secondary: const Icon(Icons.language),
      ),
    ),);
  }

  _checkListFR(text1, text2){
    return Padding(padding:  EdgeInsets.symmetric(
      vertical: MediaQuery.of(context).size.height / 80,
      horizontal: MediaQuery.of(context).size.width / 15,
    ),
        child: Transform.scale(scale: 1.3,
          child: CheckboxListTile(
            title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text1,
              textAlign: TextAlign.left,
              style: TextStyle(
        fontFamily: 'comfortaa',
                  color: AppColors.black,
                  fontSize: MediaQuery.of(context).size.width / 20,
                  fontWeight: FontWeight.normal,
                  ),
            ),
            Text(
              text2,
              textAlign: TextAlign.left,
              style: TextStyle(
        fontFamily: 'comfortaa',
                  color: Colors.grey,
                  fontSize: MediaQuery.of(context).size.width / 25,
                  fontWeight: FontWeight.normal,
                  ),
            ),
          ],
        ),
            controlAffinity: ListTileControlAffinity.trailing,
            value: fr,
            onChanged: (bool? value) {
              setState(() {
                if(value == true){
                  lang = AppLocalizations.of(context)!.translate('france');
                  fr = value!;
                  en = ar = tr =!value;
                }
              });
              },
            activeColor: AppColors.yellow,
            checkColor: AppColors.black,
        //secondary: const Icon(Icons.language),
      ),
    ),);
  }

  _checkListAR(text1, text2){
    return Padding(padding:  EdgeInsets.symmetric(
      vertical: MediaQuery.of(context).size.height / 80,
      horizontal: MediaQuery.of(context).size.width / 15,
    ),
        child: Transform.scale(scale: 1.3,
          child: CheckboxListTile(
            title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyWidget(context).textBlack20(text1, bold: false),
            MyWidget(context).textBlack20(text1, bold: false, color: Colors.grey, scale: 0.8),
          ],
        ),
            controlAffinity: ListTileControlAffinity.trailing,
            value: ar,
            onChanged: (bool? value) {
              setState(() {
                if(value == true){
                  lang = AppLocalizations.of(context)!.translate('arabic');
                  ar = value!;
                  fr = en = tr = !value;
                }
              });
              },
            activeColor: AppColors.yellow,
            checkColor: AppColors.black,
        //secondary: const Icon(Icons.language),
      ),
    ),);
  }

  _checkListTR(text1, text2){
    return Padding(padding:  EdgeInsets.symmetric(
      vertical: MediaQuery.of(context).size.height / 80,
      horizontal: MediaQuery.of(context).size.width / 15,
    ),
        child: Transform.scale(scale: 1.3,
          child: CheckboxListTile(
            title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyWidget(context).textBlack20(text1, bold: false),
            MyWidget(context).textBlack20(text1, bold: false, color: Colors.grey, scale: 0.8),
          ],
        ),
            controlAffinity: ListTileControlAffinity.trailing,
            value: tr,
            onChanged: (bool? value) {
              setState(() {
                if(value == true){
                  lang = AppLocalizations.of(context)!.translate('Turkish');
                  tr = value!;
                  fr = en = ar = !value;
                }
              });
              },
            activeColor: AppColors.yellow,
            checkColor: AppColors.black,
        //secondary: const Icon(Icons.language),
      ),
    ),);
  }

  _setState() {
    setState(() {

    });
  }

  _save() async{
    setState(() {
      chLogIn = true;
    });
    await LocalizationService().changeLocale(lang, context);
    setState(() {
      chLogIn = false;
    });
  }

}
