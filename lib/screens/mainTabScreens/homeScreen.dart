import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:closer/constant/apiUrl.dart';
import 'package:closer/constant/font_size.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';
import 'package:closer/MyWidget.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/const.dart';
import 'package:closer/constant/app_size.dart';
import 'package:closer/localizations.dart';
import 'package:closer/screens/signin.dart';
import 'package:closer/screens/service/sub_service_screen.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:closer/localization_service.dart' as trrrr;

class HomeScreen extends StatefulWidget {
  List service;
  HomeScreen({Key? key, required this.service}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchConroler = TextEditingController();
  bool _loading = true, _transScreen = false, _go = false;
  List service = [];
  List subservice = [];
  @override
  Widget build(BuildContext context) {
    return DoubleBackToCloseApp(
      snackBar: SnackBar(
        content: Text(AppLocalizations.of(context)!
            .translate('Tap back again to leave')),
      ),
      child: Stack(
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //yellow driver
                MyWidget.topYellowDriver(),
                SizedBox(
                  height: AppHeight.h1/1.5,
                ),
                _search(),
                Expanded(
                  child:FutureBuilder(
                    future: _getServiceData(token),
                    builder : (BuildContext context, AsyncSnapshot snap){
                      if(snap.connectionState == ConnectionState.waiting){
                        _loading = true;
                        return MyWidget.jumbingDotes(_loading);
                        return SizedBox();
                      }
                      else{
                        //return SizedBox();
                        _loading = false;
                        return _go ? MyWidget.jumbingDotes(_go) : ListView.builder(
                          itemCount: service.length,
                          itemBuilder: (context, index) {
                            return serviceRow(service[index]);
                          },
                          addAutomaticKeepAlives: false,
                        );
                      }
                    },
                  ),
                ),
                MyWidget.loadBannerAdd(),
                MyWidget.bottomYellowDriver(),
              ]),
          _transScreen?
          MyWidget(context).transScreen():SizedBox()
        ],
      ),
    )
    ;
  }
  Padding serviceRow(ser) {
    var name = ser['Name'];
    var imagepath = ser['ImagePath'];
    // id = ser['Id'];
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.015,
          horizontal: MediaQuery.of(context).size.width / 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: min(MediaQuery.of(context).size.width * 0.28, MediaQuery.of(context).size.height * 0.18),
            height: min(MediaQuery.of(context).size.width / 3.5, MediaQuery.of(context).size.height / 8.5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(imagepath),
              ),
              borderRadius: BorderRadius.horizontal(
                  left: trrrr.LocalizationService.getCurrentLangInt() == 3? Radius.circular(0): Radius.circular(MediaQuery.of(context).size.height / 51)
                  ,right: trrrr.LocalizationService.getCurrentLangInt() == 3? Radius.circular(MediaQuery.of(context).size.height / 51) : Radius.circular(0)
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
            //child: Text(),
          ),
          GestureDetector(
            onTap: () {
              var id = ser['Id'];
              print("id-name");
              print(id);
              print(name);
              setState(() {
                _transScreen = true;
              });
              getSubServiceData(id);
              setState(() {
                _transScreen = false;
              });
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.85 - min(MediaQuery.of(context).size.width * 0.28, MediaQuery.of(context).size.height * 0.18),
              height: min(MediaQuery.of(context).size.width / 3.5, MediaQuery.of(context).size.height / 8.5),
              decoration: BoxDecoration(
                color: Color(0x1bffca05),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.horizontal(
                    right: trrrr.LocalizationService.getCurrentLangInt() == 3? Radius.circular(0): Radius.circular(MediaQuery.of(context).size.height / 51)
                    ,left: trrrr.LocalizationService.getCurrentLangInt() == 3? Radius.circular(MediaQuery.of(context).size.height / 51) : Radius.circular(0)
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 37,
                    horizontal: MediaQuery.of(context).size.width / 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: FittedBox(
                        child: MyWidget(context).textBlack20(name,bold: false),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: min(MediaQuery.of(context).size.width / 15, MediaQuery.of(context).size.height / 35),
                      color: AppColors.yellow,
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

  Future _getServiceData(tokenn) async {
    //token = tokenn;
    print(tokenn);
    var url = Uri.parse('${ApiUrl.mainServiceRead}cityid=$cityId&filter=Service.ServiceParentId~eq~null');
    http.Response response = await http.get(url, headers: {"Authorization": tokenn!,},);
    if (response.statusCode == 200) {
      var item = await json.decode(response.body)["result"]['Data'];
      service.clear();// = item;
      for(var e in item){
        service.add(e['Service']);
      }
      editTransactionService(transactions![0], service);
      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen(token: tokenn, service: service,selectedIndex: 0, initialOrderTab: 0,),),);
    } else {
      //service = [];
      /*Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SignIn(),
        ),
      );*/
    }
  }

  Future getSubServiceData(var id, {String? search}) async {
    try{
      var url = Uri.parse('${ApiUrl.mainServiceRead}cityid=$cityId&filter=Service.ServiceParentId~eq~$id');
      if(search != null)
        url = Uri.parse('${ApiUrl.mainServiceRead}cityid=$cityId&');
      http.Response response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        List item = json.decode(response.body)["result"]['Data'];
        setState(
              () {
                if(search != null){
                  List t = [];
                  for(var e in item){
                    var i=e['Service'];
                    if(i['ServiceParentId']!=null&& (i['Name'].toString().toLowerCase().contains(search.toLowerCase())||i['Desc'].toString().toLowerCase().contains(search.toLowerCase()))){
                      t.add(i);
                    }
                  }
                  subservice = t;
                }
                else{
                  subservice.clear();// = item;
                  for(var e in item){
                    subservice.add(e['Service']);
                  }
                  //subservice = item;
                }
                editTransactionService(transactions![0], service);
                editTransactionSubService(transactions![0], subservice, id);
                editTransactionUserUserInfo(transactions![0], userInfo);
              },
        );
        if (subservice.length==1) {
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
            message: 'This service will coming soon',
            messageSize: MediaQuery.of(context).size.width / 22,
          ).show(context);
        } else {
          allSubServices.clear();
          // ignore: use_build_context_synchronously
          Navigator.push(context, MaterialPageRoute(builder: (context) => SubServiceScreen(token: token, subservice: subservice),),).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
        }
      } else {
        setState(
              () {
            subservice = [];
          },
        );
      }
    }
    catch(e){
      subservice = transactions![0].subService;
      if(subservice.length==1){
        // ignore: use_build_context_synchronously
        await Flushbar(
          padding: EdgeInsets.symmetric(
              vertical: AppHeight.h4,),
          icon: Icon(
            Icons.error_outline,
            size: AppWidth.w6,
            color: Colors.white,
          ),
          duration: const Duration(seconds: 3),
          shouldIconPulse: false,
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.all(
            Radius.circular(AppHeight.h2*1.5),
          ),
          backgroundColor: Colors.grey.withOpacity(0.5),
          barBlur: 20,
          message: 'This service will coming soon',
          messageSize: AppWidth.w5,
        ).show(context);
      } else if(subservice[subservice.length-1]["id"]==id) {
        allSubServices.clear();
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => SubServiceScreen(token: token, subservice: subservice),),).then((_) {
          // This block runs when you have returned back to the 1st Page from 2nd.
          setState(() {
            // Call setState to refresh the page.
          });
        });
      }else{
        // ignore: use_build_context_synchronously
        await Flushbar(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 20),
          icon: Icon(
            Icons.error_outline,
            size: AppWidth.w6,
            color: Colors.white,
          ),
          duration: const Duration(seconds: 3),
          shouldIconPulse: false,
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.all(
            Radius.circular(AppHeight.h2),
          ),
          backgroundColor: Colors.grey.withOpacity(0.5),
          barBlur: 20,
          message: 'This service will coming soon',
          messageSize: AppWidth.w5,
        ).show(context);
      }
    }
  }

  Widget _search() {
    search() async{
      if(_searchConroler.text.length<2){
        return;
      }
      setState(() {
        _go = true;
      });
      await getSubServiceData("id", search: _searchConroler.text);
      _searchConroler.text = '';
      setState(() {
        _go = false;
      });
    }
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: AppHeight.h1,
          horizontal: AppWidth.w6),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: AppWidth.w80*1.05,
            child: TextField(
              controller: _searchConroler,
              decoration: InputDecoration(
                suffixIconColor: AppColors.mainColor1,
                suffixIcon: IconButton(onPressed: ()=> search(), icon: const Icon(Icons.search)),
                enabledBorder: OutlineInputBorder(
                  borderRadius:  BorderRadius.all(Radius.circular(AppWidth.w5)),
                  borderSide: BorderSide(color: AppColors.mainColor),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(AppWidth.w5)),
                    borderSide: BorderSide(color: AppColors.mainColor)),
                hintText: AppLocalizations.of(context)!.translate('Search'),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(AppWidth.w5)),
                    borderSide: BorderSide(color: AppColors.mainColor)),
              ),
            ),
          ),
          //IconButton(onPressed: ()=> search(), icon: Icon(Icons.manage_search_outlined))
          //MyWidget(context).raisedButton(AppLocalizations.of(context)!.translate('Go'), ()=> search(), AppWidth.w20, chLogIn, textH: FontSize.s18, buttonText: AppColors.mainColor, colorText: AppColors.white)
        ],
      ),
    );
  }

}
