import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:closer/constant/app_size.dart';
import 'package:closer/constant/font_size.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/constant/functions.dart';
import 'package:closer/helper/adHelper.dart';
import 'package:closer/main.dart';
import 'package:closer/screens/Payment.dart';
import 'package:flutter/material.dart';
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/screens/order/newOrder.dart';
import 'package:closer/screens/signin.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'const.dart';
import 'localization_service.dart';
import 'localizations.dart';
import 'package:flutter_html/flutter_html.dart' as h;

class MyWidget{
  BuildContext context;

  MyWidget(this.context) {
    _padButtonV = min(MediaQuery.of(context).size.height / 80, MediaQuery.of(context).size.width / 25);
  }

  static htmlScreen(htmlText,{dirction}){
    dirction??=Axis.vertical;
    return SingleChildScrollView(
     // scrollDirection: dirction,
      child: h.Html(
        data: """
        $htmlText
                """,
      ),
    );
  }

  static myTasklist(ord, index, Function() setState, chCircle,) {
    var serial = ord['OrderService']['Order']['Serial']??1;
    var taskName = ord['Name'];
    var Id = ord['OrderService']['OrderId'];
    var workerName = ord['User']['Name'] + ' ' + ord['User']['LastName'];
    var date = ord['OrderDate'];
    var addressArea = ord['OrderService']['Order']['Address']['Title'];
    var statusCode = ord['Status'].toString();
   // statusCode = '1';
    String status = "";
    Color statusColor = Colors.grey;
    switch (statusCode) {
      case "5":
        {
          status = AppLocalizations.of(navigatorKey.currentContext!)!.translate("Rejected");
          statusColor = AppColors.red;
        }
        break;
      case "4":
        {
          status = AppLocalizations.of(navigatorKey.currentContext!)!.translate("Pending");
          statusColor = AppColors.blue;
        }
        break;
      case "3":
        {
          status = AppLocalizations.of(navigatorKey.currentContext!)!.translate("At the road");
          statusColor = AppColors.blue;
        }
        break;
      case "2":
        {
          status = AppLocalizations.of(navigatorKey.currentContext!)!.translate("finished");
          statusColor = AppColors.blue;
        }
        break;
      case "1":
        {
          status = AppLocalizations.of(navigatorKey.currentContext!)!.translate("Pending");
          statusColor = Colors.grey;
        }
        break;
      default:
        {
          status = AppLocalizations.of(navigatorKey.currentContext!)!.translate("Pending");
          statusColor = Colors.grey;
        }
        break;
    }
    orderCard(index, statusColor, status, addressArea, amount,String date, statusCode, Id, serial, {String? taskName}) {
      return Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(navigatorKey.currentContext!).size.height / 200,
            horizontal: MediaQuery.of(navigatorKey.currentContext!).size.width / 40),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(AppHeight.h2),
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
                        horizontal: AppWidth.w2),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyWidget(navigatorKey.currentContext!).textBlack20(taskName ?? AppLocalizations.of(navigatorKey.currentContext!)!.translate('Order Id: ') + serial.toString(), scale: 0.85),
                            SizedBox(
                              width: AppWidth.w1,
                              //child: Text(),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              width: MediaQuery.of(navigatorKey.currentContext!).size.width * 0.5,
                              height: MediaQuery.of(navigatorKey.currentContext!).size.height / 10,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
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
                                    child: status != null? GestureDetector(
                                      onTap: () {},
                                      child:
                                      MyWidget(navigatorKey.currentContext!).textBlack20(status, scale: 0.85, color: statusColor),
                                      /*Icon(
                                Icons.close_outlined,
                                size: MediaQuery.of(context).size.width / 18,
                                color: Colors.grey,
                              ),*/
                                    ):SizedBox(height: 0,),//IconButton(onPressed: () => rejectOrder(), icon: Icon(Icons.delete_forever_outlined)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            MyWidget(navigatorKey.currentContext!).textGrayk28(addressArea, color: Colors.grey)
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(navigatorKey.currentContext!).size.height / 80,
                        ),
                        Divider(
                          color: Colors.grey[900],
                          height: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyWidget(navigatorKey.currentContext!).textBlack20(amount.toString(), scale: 0.85),
                            /* SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                            //child: Text(),
                          ),*/
                            Container(
                                alignment: Alignment.centerRight,
                                //width: MediaQuery.of(context).size.width * 0.5,
                                height: AppHeight.h10,
                                child:
                                MyWidget(navigatorKey.currentContext!).textBlack20(DateTime.parse(date.replaceAll('T', ' ')).add(-timeDiff).toString().split(' ')[0], scale: 0.85)
                            ),
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
    String address = /*addressCity + " / " +*/ addressArea??'';
    return orderCard(index, statusColor, status, address, workerName, date, statusCode, Id, serial, taskName: taskName);
  }

  static myOrderlist(ord, index, Function() setState, chCircle,) {
    var serial; serial = ord['Serial'];
    var Id;Id = ord['Servicess'][0]['OrderId'];
    var amount; amount = prettify(double.parse(ord['Amount'].toString()));
    var date; date = ord['OrderDate'];
    var addressArea; addressArea = ord['Address']['Title']??'';
    var addressCity; addressCity = ord['Address']['Title']??'';
    var statusCode; statusCode = ord['Status'].toString();
    var rate = ord['Score']??0;
    var rateNote = ord['ScoreNote']??'';
    amount = amount.toString() +" \.${AppLocalizations.of(navigatorKey.currentContext!)!.translate('TRY')} ";
    //statusCode = '2';
    String status = "";
    Color statusColor = Colors.grey;
    bool showReview = false;
    switch (statusCode) {
      case "8":
        {
          //return SizedBox(height: 0.001,);
          showReview = true;
          status = AppLocalizations.of(navigatorKey.currentContext!)!.translate("finished");
          statusColor = Colors.grey;
        }
        break;
      case "7":
        {
          //return SizedBox(height: 0.001,);
          status = AppLocalizations.of(navigatorKey.currentContext!)!.translate("Tracking");
          statusColor = Colors.grey;
        }
        break;
      case "6":
        {
          //return SizedBox(height: 0.001,);
          status = AppLocalizations.of(navigatorKey.currentContext!)!.translate("payed");
          statusColor = AppColors.green;
        }
        break;
      case "5":
        {
          status = AppLocalizations.of(navigatorKey.currentContext!)!.translate("Rejected");
          statusColor = AppColors.red;
        }
        break;
      case "4":
        {
          status = AppLocalizations.of(navigatorKey.currentContext!)!.translate("Pending");
          statusColor = AppColors.blue;
        }
        break;
      case "3":
        {
          status = AppLocalizations.of(navigatorKey.currentContext!)!.translate("Change Date");
          statusColor = AppColors.blue;
        }
        break;
      case "2":
        {
          if(!worker){
            status = AppLocalizations.of(navigatorKey.currentContext!)!.translate("Accepted");
            statusColor = AppColors.yellow;
          }else{
            status = AppLocalizations.of(navigatorKey.currentContext!)!.translate("finished");
            statusColor = AppColors.blue;
          }
        }
        break;
      case "1":
        {
          status = AppLocalizations.of(navigatorKey.currentContext!)!.translate("Pending");
          statusColor = Colors.grey;
        }
        break;
      default:
        {
          status = AppLocalizations.of(navigatorKey.currentContext!)!.translate("Pending");
          statusColor = Colors.grey;
        }
        break;
    }
    void _goToPay(i) {
      Navigator.push(navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => Payment(ord, token))).then((_) {setState();});
    }

    String address = addressCity + " / " + addressArea;
    clickCardButton() async {
      switch (statusCode) {
        case "6":
          {}
          break;
        case "5":
          {
            bool _suc = await APIService(context: navigatorKey.currentContext).destroyOrder(Id);
            if (_suc){
              setState();
              APIService.flushBar(AppLocalizations.of(navigatorKey.currentContext!)!.translate('Order Destroy'));
             // Timer(Duration(seconds:1), ()=>setState(() {}));
              setState();
            }
          }
          break;
        case "4":
          {

          }
          break;
        case "3":
          {

          }
          break;
        case "2":
          {
            _goToPay(index-1);
          }
          break;
        case "1":
          {}
          break;
        default:
          {}
          break;
      }
    }
    _review({required orderId}){

      final _dialog = RatingDialog(
        initialRating: 1.0,
        // your app's name?
        title: MyWidget(navigatorKey.currentContext!).textBlack20("#"+AppLocalizations.of(navigatorKey.currentContext!)!.translate('Order Id: ') + serial.toString(), scale: 0.9),
        // encourage your user to leave a high rating?
        message: MyWidget(navigatorKey.currentContext!).textBlack20(AppLocalizations.of(navigatorKey.currentContext!)!.translate('Reviews are public and include your account and device info'), scale: 0.8),
        // your app's logo?
        image: Image.asset('assets/images/logo000.png', height: AppHeight.h18,),
        submitButtonText: 'Submit',
        submitButtonTextStyle: TextStyle(
        fontFamily: 'comfortaa',color: AppColors.mainColor, fontSize: FontSize.s20),
        commentHint: AppLocalizations.of(navigatorKey.currentContext!)!.translate('Describe your experience'),
        starColor: AppColors.mainColor,
        onCancelled: () => print('cancelled'),
        onSubmitted: (response) async{
          await APIService.rateOrder(orderId: orderId, rateNote: response.comment, rateScore: response.rating);
          setState();
          print('rating: ${response.rating}, comment: ${response.comment}');
          // TODO: add your own logic
        },
      );

      // show the dialog
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) => _dialog,
      );
    }
    _reviewWidget({required bool reviewed}){
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppHeight.h1),
            child: Divider(
              color: Colors.grey[900],
              height: 1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyWidget(navigatorKey.currentContext!).textBlack20(AppLocalizations.of(navigatorKey.currentContext!)!.translate(reviewed?'Ratings and Reviews':'Write a Review'), scale: 0.8),
              IconButton(onPressed: ()=>_review(orderId: Id), icon: Icon(reviewed?Icons.edit_outlined:Icons.arrow_forward, color: AppColors.mainColor,)),
              ],
          ),
          reviewed?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ratingStars(rate: rate),
              MyWidget(navigatorKey.currentContext!).textBlack20(rateNote, scale: 0.7),
              SizedBox(height: AppHeight.h1,)
            ],
          ):
          SizedBox()
        ],
      );
    }

    cardButton(statusCode, color, id, index) {
      if(worker) return SizedBox(
          width: 0.1,
        );
      var apiUrl;
      Map? mapDate;
      String text = '';
      switch (statusCode) {
        case "6":
          {
            text = AppLocalizations.of(navigatorKey.currentContext!)!.translate("payed");
            return SizedBox(
              width: 0.1,
            );
          }
          break;
        case "5":
          {
            text = AppLocalizations.of(navigatorKey.currentContext!)!.translate("Destroy");
          }
          break;
        case "4":
          {
            text = AppLocalizations.of(navigatorKey.currentContext!)!.translate("Pending");
            return SizedBox(
              width: 0.1,
            );
          }
          break;
        case "3":
          {
            text = AppLocalizations.of(navigatorKey.currentContext!)!.translate("Update");
            return SizedBox(
              width: 0.1,
            );
          }
          break;
        case "2":
          {
            text = AppLocalizations.of(navigatorKey.currentContext!)!.translate("go to pay");
          }
          break;
        case "1":
          {
            text = AppLocalizations.of(navigatorKey.currentContext!)!.translate("Pending");
            return SizedBox(
              width: 0.1,
            );
          }
          break;
        default:
          {
            text = AppLocalizations.of(navigatorKey.currentContext!)!.translate("Pending");
            return SizedBox(
              width: 0.1,
            );
          }
          break;
      }
      return Container(
        //width: MediaQuery.of(context).size.width / 4,
        // ignore: deprecated_member_use
        //padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/5),
        //height: double.infinity,
        alignment: Alignment.bottomCenter,
        child: MyWidget(navigatorKey.currentContext!).raisedButton(text, () => clickCardButton(),  AppWidth.w28, chCircle, buttonText: color, colorText: Colors.grey, roundBorder:  AppHeight.h2, padV: AppHeight.h2),
      );
    }
    orderCard(index, statusColor, status, addressArea, amount,String date, statusCode, Id, serial, {String? taskName}) {
      return Padding(
        padding: EdgeInsets.symmetric(
            vertical: AppHeight.h1/2,
            horizontal: MediaQuery.of(navigatorKey.currentContext!).size.width / 40),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(AppWidth.w4),
              side: BorderSide(
                color: statusColor,
                width: 1.0,
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppWidth.w4,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppHeight.h2,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyWidget(navigatorKey.currentContext!).textBlack20(taskName ?? AppLocalizations.of(navigatorKey.currentContext!)!.translate('Order Id: ') + serial.toString(), scale: 0.85),
                            MyWidget(navigatorKey.currentContext!).textBlack20(status, scale: 0.85, color: statusColor),
                          ],
                        ),
                        SizedBox(height: AppHeight.h1,),
                        MyWidget(navigatorKey.currentContext!).textGrayk28(addressArea, color: Colors.grey),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: AppHeight.h1),
                          child: Divider(
                            color: Colors.grey[900],
                            height: 1,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyWidget(navigatorKey.currentContext!).textBlack20(amount.toString(), scale: 0.85, color: AppColors.red),
                            MyWidget(navigatorKey.currentContext!).textBlack20(DateTime.parse(date.replaceAll('T', ' ')).add(-timeDiff).toString().split(' ')[0], scale: 0.85),
                          ],
                        ),
                        showReview?_reviewWidget(reviewed: ord['Score']!=null?true:false):SizedBox(),
                        SizedBox(height: showReview? AppHeight.h1/2:AppHeight.h2,),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: cardButton(statusCode, statusColor, Id, index),
                ),
              ],
            )),
      );
    }
     return orderCard(index, statusColor, status, addressArea, amount, date, statusCode, Id, serial);
  }

  static ratingStars({required int rate}){
    List<bool> l = [];
    for(int i=0; i<5; i++){
      if(rate > i) l.add(true);
      else l.add(false);
    }
    return Row(
      children: l.map((e) => Icon(e?Icons.star : Icons.star_border_outlined, color: AppColors.mainColor,)).toList(),
    );
  }

  static textHeader(text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'comfortaa',
        color: Colors.grey,
        fontSize: AppWidth.w4,
        fontWeight: FontWeight.normal,
        
      ),
    );
  }

  static text(text) {
    return Padding(padding: EdgeInsets.symmetric(vertical: AppHeight.h2/10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          text,
          style: TextStyle(
        fontFamily: 'comfortaa',
            color: AppColors.black,
            fontSize: AppWidth.w5,
            fontWeight: FontWeight.normal,
          ),
        ),
      )
      ,);
  }

  static card(widget) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: AppHeight.h2/10,
          horizontal: AppWidth.w2
      ),
      //alignment: Alignment.l,
      width: AppWidth.w80,
      //height: MediaQuery.of(context).size.height / 7,
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
            Radius.circular(AppHeight.h2/1.5)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppWidth.w5,
          vertical: AppHeight.h2/1.5,
        ),
        child: widget,
      ),
    );
  }

  static loadBannerAdd(){
    if (AdHelper.bannerAd != null) {
      return Center(
        child: SizedBox(
        width: AdHelper.bannerAd!.size.width.toDouble(),
        height: AdHelper.bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: AdHelper.bannerAd!),
    ),
      );
    }
    return SizedBox();
    /*bannerSize = AdmobBannerSize.ADAPTIVE_BANNER(
      // height: MediaQuery.of(context).size.height.toInt()-40,
      width: MediaQuery.of(context).size.width.toInt(), // considering EdgeInsets.all(20.0)
    );
    return AdmobBanner(
      adUnitId: getBannerAdUnitId()!,
      adSize: bannerSize!,
      listener: (AdmobAdEvent event,
          Map<String, dynamic>? args) {
        handleEvent(event, args, 'Banner');
      },
      onBannerCreated:
          (AdmobBannerController controller) {
        // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
        // Normally you don't need to worry about disposing this yourself, it's handled.
        // If you need direct access to dispose, this is your guy!
        // controller.dispose();
      },
    );*/
  }

  static jumbingDotes(bool loading){
    if(loading) {
      return JumpingDotsProgressIndicator(
        fontSize: 40.0,
        numberOfDots:7,
      );
    } else
      return SizedBox();
  }

  static topYellowDriver() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: AppWidth.w90,
        height: AppHeight.h1,
        decoration: BoxDecoration(
          color: AppColors.barline,
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(AppHeight.h2)),
        ),
      ),
    );
  }

  static bottomYellowDriver() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: AppWidth.w100,
        height: AppHeight.h1,
        decoration: BoxDecoration(
          color: AppColors.barline,
        ),
      ),
    );
  }

  static appBar({required title, isMain, withoutCart, key}){
    bool empty = order.isEmpty;
    isMain??=false;
    withoutCart??=false;
    bool newOrder = false;
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: AppHeight.h16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(24),
            bottomLeft: Radius.circular(24)),
      ),
      backgroundColor: AppColors.mainColor,
      title: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: AppHeight.h1,),
            SvgPicture.asset(
              'assets/images/app_bar_logo.svg',
              width: AppWidth.w20,
              height: AppHeight.h2,
            ),
            SizedBox(height: AppHeight.h1/2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                !isMain?
                IconButton(onPressed: ()=> Navigator.of(navigatorKey.currentContext!).pop(), icon: Icon(Icons.arrow_back)):
                IconButton(onPressed: ()=> key.currentState!.openDrawer(), icon: Icon(Icons.list, size: AppWidth.w8), ),
                textTitle(title),
                withoutCart || worker? SizedBox(width: AppWidth.w8,) : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    !empty? Text(order.length.toString(),style: TextStyle(
        fontFamily: 'comfortaa',color: AppColors.yellow,fontSize: FontSize.s14),):SizedBox(height: FontSize.s14*2,),
                    IconButton(onPressed: () => _iconPress(empty, newOrder: newOrder), icon: Icon(Icons.shopping_cart_outlined,size: AppWidth.w8,))
                  ],
                ),
              ],
            )
          ],
        )
      ),
      actions: [
        SizedBox()
         /*IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            country.clear();
            city.clear();
            area.clear();
            Navigator.of(navigatorKey.currentContext!).pop();
          },
        )*/
      ],
    );
  }

  textBlack20(text, {color, bold, textAlign, scale}){
    color??= AppColors.black;
    bold??= true;
    scale??= 1.0;
    textAlign??= TextAlign.start;
    return Padding(
      padding: EdgeInsets.only(bottom: AppHeight.h1/5),
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          fontFamily: 'comfortaa',
            fontSize: min(MediaQuery.of(context).size.width / 20, MediaQuery.of(context).size.height / 45) * scale ,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: color),
      ),
    );
  }

  textTitle15(text, {color, bold, textAlign, scale}){
    color??= AppColors.black;
    bold??= false;
    scale??= 1.0;
    textAlign??= TextAlign.start;
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: 'comfortaa',
          fontSize: FontSize.s16*scale ,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: color),
    );
  }

  static textTitle(text, {color, bold, textAlign, scale}){
    color??= AppColors.white;
    bold??= true;
    scale??= 1.0;
    textAlign??= TextAlign.start;
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: 'comfortaa',

          fontSize: FontSize.s18*scale ,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: color),
    );
  }

  textTap25(text, {color, bold, textAlign, scale, lineTrought}){
    color??= AppColors.textColorGray;
    bold??= false;
    lineTrought??= false;
    textAlign??= TextAlign.center;
    scale??=1.0;
    return Text(
      text,
      maxLines: 2,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: 'comfortaa',
          decoration: lineTrought? TextDecoration.lineThrough : TextDecoration.none,
          fontSize: FontSize.s16 * scale ,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: color),
    );
  }

  textHead10(text,{scale, color, textAlign}){
    scale??=1.0;
    color??=AppColors.white;
    textAlign?? TextAlign.start;
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: AppHeight.h1*0),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'comfortaa',
            color: color,
            fontSize: min(MediaQuery.of(context).size.width / 10,MediaQuery.of(context).size.height / 23)*scale,
            fontWeight: FontWeight.bold,
            ),
        textAlign: textAlign,
      ),
    );
  }

  textGrayk28(text,{scale, color}){
    scale??=1;
    color??= AppColors.gray;
    return Text(
        text,
        maxLines: 1,
        style: TextStyle(
        fontFamily: 'comfortaa',
        color: color,
        fontSize: min(MediaQuery.of(context).size.width / 28, MediaQuery.of(context).size.height / 64) * scale,
          fontWeight: FontWeight.bold,
        ),
    );
  }

  textButton30(text,{scale}){
    scale??=1;
    return Text(
        text,
        maxLines: 1,
        style: TextStyle(
        fontFamily: 'comfortaa',
        color: AppColors.buttonTextColor,
        fontSize: min(MediaQuery.of(context).size.width / 28, MediaQuery.of(context).size.height / 65) * scale,
          fontWeight: FontWeight.bold,
        ),
    );
  }

  logoDrawer(barHight, radius,){
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 37,
          horizontal: MediaQuery.of(context).size.width / 20),
      width: double.infinity,
      height: barHight,
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(radius),
            bottomRight: Radius.circular(radius)),
      ),
      child: Image.asset(
        'assets/images/Logo1.png',
        width: MediaQuery.of(context).size.width / 6,
        height: barHight / 2,
      ),
    );
  }

  dropDownLang(List<String> list, setState()){
    String? lng;
    return DropdownButton<String>(
      dropdownColor: Colors.grey,
      items: list.map(
            (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
        fontFamily: 'comfortaa',color: Colors.white, fontSize: min(MediaQuery.of(context).size.height/55, MediaQuery.of(context).size.width/25)),
            ),
          );
        },
      ).toList(),
      value: LocalizationService().getCurrentLang(),
      underline: Container(
        color: Colors.grey,
      ),
      isExpanded: false,
      onChanged: (newVal) {
        lng = newVal!;
        LocalizationService().changeLocale(newVal, context);
        setState();
      },
    );
  }

  drawer(barHight, radius, setState()) {
    return Container(
      width: MediaQuery.of(context).size.width/4*3,
      child: Drawer(
          child: Container(
              height: double.infinity,
              //width: MediaQuery.of(context).size.width/4*3,
              color: AppColors.mainColor,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: AppHeight.h2,
                        horizontal: AppWidth.w4,),
                    child: Image.asset('assets/images/logo111.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height / 37,
                        horizontal: MediaQuery.of(context).size.width / 20),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textBlack20(AppLocalizations.of(context)!.translate('lang'),),
                            Text("   "),
                            dropDownLang(LocalizationService.langs, ()=>setState()),
                          ],
                        ),
                        // ignore: deprecated_member_use
                        // button(
                        //     AppLocalizations.of(context)!.translate('Log Out'),
                        //         ()=>APIService(context: context).logOut,
                        //     MediaQuery.of(context).size.width/1.7),
                        // button(
                        //     AppLocalizations.of(context)!.translate('Contact Us'),
                        //         ()=>_goAbout,MediaQuery.of(context).size.width/1.7),
                      ],
                    ),
                  ),
                  Expanded(
                    child: !worker?
                    ListView.builder(
                      itemCount: order.length == 0 ? 0 : order.length,
                      itemBuilder: (context, index) {
                        //totalPrice =0;s
                        return orderlist(order[index],0.80,()=>setState());
                      },
                      addAutomaticKeepAlives: false,
                    ):
                    isBoss?
                    ListView.builder(
                      itemCount: task.length == 0 ? 0 : task.length,
                      itemBuilder: (context, index) {
                        //totalPrice =0;s
                        return tasklist(task[index],0.83,()=>setState());
                      },
                      addAutomaticKeepAlives: false,
                    ):SizedBox(),
                  ),
                ],
              ))
      ),
    );
  }

  Padding orderlist(ord,scale,setState()) {
    DateTime  pickDate = DateTime.now();
    TimeOfDay time = TimeOfDay.now();
    var Id = ord[0][0]['Id'];
    var name = ord[0][0]['Name'];
    var imagepath = ord[0][0]['ImagePath'];
    var price = prettify(ord[0][0]['Price']).toString();
    var amount = ord[1].toString();
    /*var date = Text(
      '${pickDate.day}-${pickDate.month}-${pickDate.year} / ${time.hour}:${time.minute}',
      maxLines: 1,
      style: TextStyle(
        fontFamily: 'comfortaa',
        color: MyColors.black,
        fontSize: MediaQuery.of(context!).size.width / 30 * scale,
        fontWeight: FontWeight.bold,
      ),
    );*/
    var date = textGrayk28(AppLocalizations.of(context)!.translate('Amount').replaceAll(' ', '') + ' = ' + amount,scale: scale);
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 80,
          horizontal: MediaQuery.of(context).size.width / 50),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  alignment: Alignment.center,
                  width: min(MediaQuery.of(context).size.width * 0.20, MediaQuery.of(context).size.height * 0.92) * scale,
                  height: min(MediaQuery.of(context).size.height / 9, MediaQuery.of(context).size.width / 4) * scale,
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
                    borderRadius: BorderRadius.all(Radius.circular(
                        MediaQuery.of(context).size.height / 100)),
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01 * scale,
                //child: Text(),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 22),
                alignment: Alignment.center,
                width: (MediaQuery.of(context).size.width * 0.85 - min(MediaQuery.of(context).size.width * 0.20, MediaQuery.of(context).size.height * 0.92)) * scale,
                height: min(MediaQuery.of(context).size.height / 9, MediaQuery.of(context).size.width / 4) * scale,
                //height: MediaQuery.of(context).size.height / 9.5 * scale,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
        fontFamily: 'comfortaa',
                              color: Colors.black,
                              fontSize: min(MediaQuery.of(context).size.width / 24, MediaQuery.of(context).size.height / 55) * scale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          date,
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        price + ' ' + AppLocalizations.of(context)!.translate('TRY'),
                        style: TextStyle(
        fontFamily: 'comfortaa',
                          color: Colors.blue,
                          fontSize: min(MediaQuery.of(context).size.width / 24, MediaQuery.of(context).size.height / 55) * scale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          deleteOrder(order, Id);
                          editTransactionOrder(transactions![0], order);
                          setState();
                        },
                        child: Icon(
                          Icons.close_outlined,
                          size: min(MediaQuery.of(context).size.width / 20, MediaQuery.of(context).size.height / 45) * scale,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 80,
          ),
          Divider(
            color: Colors.grey[900],
            height: 1,
          ),
        ],
      ),
    );
  }

  Padding tasklist(task,scale,setState()) {
    var Id = task[0]['Service']['Id'];
    var name = task[0]['TaskName'];
    var imagepath = 'https://controlpanel.mr-service.online' + task[0]['Service']['Service']['ImagePath'];
    var price = task[0]['Description'].toString();
    var workersName0 = '';
    for(int i = 0; i<task[0]['Workers'].length; i++){
      if(workersName0 != '')
        workersName0 = workersName0 + ' , ' + task[0]['Workers'][i][0]['Name'];
      else
        workersName0 = workersName0 + ' ' + task[0]['Workers'][i][0]['Name'];
    }
    var workersName = textButton30(
      workersName0,
    );
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 80,
          horizontal: MediaQuery.of(context).size.width / 50),
      child: Column(
        children: [
          Row(
            children: [
              //image
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.20 * scale,
                  height: MediaQuery.of(context).size.height / 10 * scale,
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
                    borderRadius: BorderRadius.all(Radius.circular(
                        MediaQuery.of(context).size.height / 100)),
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01 * scale,
                //child: Text(),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 22),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.65 * scale,
                height: MediaQuery.of(context).size.height / 10 * scale,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
        fontFamily: 'comfortaa',
                              color: Colors.black,
                              fontSize: min(MediaQuery.of(context).size.width / 20, MediaQuery.of(context).size.height / 45) * scale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          workersName,
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () async{
                          bool upload = false;
                          for(int i=0; i<task[0]['Workers'].length; i++){
                            upload = await APIService(context: context).createWorkerTask(task[0]['OrderId'], task[0]['Workers'][i][0]['Id'], task[0]['Service']['Id'], task[0]['Description'], task[0]['StartDate'],' endDate', 'workerNotes', token, task[0]['Workers'][i][0]['fcmToken'] ,name);
                          }
                          if(upload) {
                            deleteTask(task, Id, task[0]['Workers'], name);
                            flushBar(name +  AppLocalizations.of(context)!.translate('has been added to') + workersName0);
                            setState();
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context)!.translate('Send'),
                          style: TextStyle(
        fontFamily: 'comfortaa',
                            color: Colors.blue,
                            fontSize: min(MediaQuery.of(context).size.width / 24, MediaQuery.of(context).size.height / 55) * scale,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          deleteTask(task, Id, task[0]['Workers'], name);
                          //editTransactionOrder(transactions![0], order);
                          setState();
                        },
                        child: Icon(
                          Icons.close_outlined,
                          size: min(MediaQuery.of(context).size.width / 20, MediaQuery.of(context).size.height / 45) * scale,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 80,
          ),
          Divider(
            color: Colors.grey[900],
            height: 1,
          ),
        ],
      ),
    );
  }

  appBarTittle(barHight,key, {bool? newOrder}){
    barHight = barHight * 0.95;
    newOrder ??= false;
    bool empty = order.isEmpty;
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 80 * 3),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/Logo1.png',
            width: MediaQuery.of(context).size.width / 6,
            height: barHight / 2,
          ),
          Align(
            //alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/5,),
                  !worker?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      !empty? Text(order.length.toString(),style: TextStyle(
        fontFamily: 'comfortaa',color: AppColors.yellow,fontSize: min(MediaQuery.of(context).size.width/20,MediaQuery.of(context).size.height/45)),):SizedBox(height: MediaQuery.of(context).size.width/30,),
                      IconButton(onPressed: () => _iconPress(empty, newOrder: newOrder), icon: Icon(Icons.shopping_cart_outlined,size: min(MediaQuery.of(context).size.width/12, MediaQuery.of(context).size.height/26),))
                    ],
                  ):
                  isBoss?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    /*children: [
                      !task.isEmpty? Text(task.length.toString(),style: TextStyle(
        fontFamily: 'comfortaa',color: MyColors.yellow,fontSize: MediaQuery.of(context!).size.width/20),):SizedBox(height: MediaQuery.of(context!).size.width/30,),
                      IconButton(onPressed: () => _iconPress(task.isEmpty, _key), icon: Icon(Icons.work,size: MediaQuery.of(context!).size.width/12,))
                    ],*/
                  ):
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    /*children: [
                      !task.isEmpty? Text(task.length.toString(),style: TextStyle(
        fontFamily: 'comfortaa',color: MyColors.yellow,fontSize: MediaQuery.of(context!).size.width/20),):SizedBox(height: MediaQuery.of(context!).size.width/30,),
                      IconButton(onPressed: () => _iconPress(task.isEmpty, _key), icon: Icon(Icons.work,size: MediaQuery.of(context!).size.width/12,))
                    ],*/
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width/60,),
                ],
              )
          ),
        ],
      ),
    );
  }

  static _iconPress(empty, {bool? newOrder}){
    newOrder ??= false;
    if(newOrder) return;
    if(empty){
      flushBar(AppLocalizations.of(navigatorKey.currentContext!)!.translate("There isn't any new order"));
    }else{
      MyApplication.navigateTo(navigatorKey.currentContext!, NewOrder(token, mainService));
      //_key.currentState!.openEndDrawer();
    }
  }

  var _padButtonV = 0.0;

  button(text, click(),width) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: _padButtonV,
      ),
      child: raisedButton(text, ()=> click(), width, false),
    ) ;
  }

  void deleteOrder(ord, id) {
    ord.removeWhere((item) => item[0][0]['Id'] == id);
    //id++;
  }

  void deleteTask(tas, id, workers, taskName) {
    tas.removeWhere((item) => item[0]['Service']['Id'] == id && item[0]['TaskName'] == taskName && item[0]['Workers'] == workers);
    //id++;
  }

  _goAbout() {
    Navigator.pushNamed(context, 'about');
  }

  raisedButton(text , press, width, chLogIn, {height, colorText, buttonText, padV, textH, roundBorder}){
    colorText??=AppColors.buttonTextColor;
    buttonText??=AppColors.mainColor1;
    padV??= AppHeight.h1*1.5;
    textH??= min(MediaQuery.of(context).size.width / 20, MediaQuery.of(context).size.height / 46);
    roundBorder??= MediaQuery.of(context).size.height / 12;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width*1,
          // ignore: deprecated_member_use
          //padding: EdgeInsets.symmetric(vertical: 0,horizontal: MediaQuery.of(context!).size.width/10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              //color: MyColors.yellow,
              primary: buttonText,
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: padV),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      roundBorder)),
            ),
            onPressed: chLogIn==true?()=>{}: press,
            //elevation: 5.0,
            child: chLogIn == true
                ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.mainColor),
              backgroundColor: Colors.grey,
            )
                : Text(text,
              style: TextStyle(
        fontFamily: 'comfortaa',
                  fontSize: textH,
                  color: colorText,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    )
    ;
  }

  transScreen(){
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white12,
      child: SizedBox(),
    );
  }

  static flushBar(text){
    Flushbar(
      padding: EdgeInsets.symmetric(
          vertical:AppPadding.p20),
      icon: Icon(
        Icons.error_outline,
        size: AppWidth.w4,
        color: AppColors.white,
      ),
      duration: Duration(seconds: 3),
      shouldIconPulse: false,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.all(Radius.circular(16)),
      backgroundColor: Colors.grey.withOpacity(0.5),
      barBlur: 20,
      message: text,
      messageSize: MediaQuery.of(navigatorKey.currentContext!).size.height / 40,
    ).show(navigatorKey.currentContext!);
  }

  textFiled(textController, hintText, labelText,{email, password, clickIcon()?, obscureText, passwordText}){
     email??= false;
     password??= false;
     obscureText??= false;
     passwordText??= '';
    var borderRad= min(MediaQuery.of(context).size.height / 12, MediaQuery.of(context).size.width / 5.2);
    return Container(
      alignment: Alignment.centerLeft,
      height: MediaQuery.of(context).size.height / 10,
      child: TextFormField(
        // onSaved: (input)=>requestModel.email = input!,
        controller: textController,
        validator: (val) {
          if (val!.isEmpty) {
            return AppLocalizations.of(context)!.translate('Required');
          }
          if (email & !RegExp(
              "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(val)) {
            return AppLocalizations.of(context)!.translate('enter a valid email address');
          }

          if (passwordText!= '' && val != passwordText){
            return AppLocalizations.of(context)!.translate('Password Do not Match');
          }
        },

        autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: obscureText,
        style: TextStyle(
        fontFamily: 'comfortaa',
            color: Colors.white,
            fontSize: min(MediaQuery.of(context).size.width / 20,MediaQuery.of(context).size.height / 45)),
        decoration: password?
        InputDecoration(
          hintText: hintText,
          labelText: labelText,
          errorStyle: TextStyle(
        fontFamily: 'comfortaa',
            color: AppColors.black,
              fontSize: min(MediaQuery.of(context).size.width / 25,MediaQuery.of(context).size.height / 55)),
          labelStyle: TextStyle(
        fontFamily: 'comfortaa',
            fontSize: min(MediaQuery.of(context).size.width / 25,MediaQuery.of(context).size.height / 55),
            color: Colors.white,
          ),
          hintStyle: TextStyle(
        fontFamily: 'comfortaa',
            fontSize: min(MediaQuery.of(context).size.width / 25,MediaQuery.of(context).size.height / 55),
            color: Colors.grey,
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  borderRad),
              borderSide:
              BorderSide(color: Colors.grey, width: 2)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                borderRad),
            borderSide:
            BorderSide(color: Colors.grey, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                borderRad),
            borderSide:
            BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                borderRad),
            borderSide:
            BorderSide(color: AppColors.white, width: 2),
          ),
          suffixIcon: password ? IconButton(
            padding: EdgeInsets.symmetric(
                horizontal:
                MediaQuery.of(context).size.width / 20),
            icon: Icon(
              Icons.remove_red_eye,
              color: Colors.white,
              size: min(MediaQuery.of(context).size.width / 12,MediaQuery.of(context).size.height / 28),
            ),
            onPressed: () => clickIcon!() ,
          ):SizedBox(width: 0.0,),
        ):
        InputDecoration(
          hintText: hintText,
          labelText: labelText,
          errorStyle: TextStyle(
        fontFamily: 'comfortaa',
              color: AppColors.black,
              fontSize: min(MediaQuery.of(context).size.width / 25,MediaQuery.of(context).size.height / 55)),
          labelStyle: TextStyle(
        fontFamily: 'comfortaa',
            fontSize: min(MediaQuery.of(context).size.width / 25,MediaQuery.of(context).size.height / 55),
            color: Colors.white,
          ),
          hintStyle: TextStyle(
        fontFamily: 'comfortaa',
            fontSize: min(MediaQuery.of(context).size.width / 25,MediaQuery.of(context).size.height / 55),
            color: Colors.grey,
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  borderRad),
              borderSide:
              BorderSide(color: Colors.grey, width: 2)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                borderRad),
            borderSide:
            BorderSide(color: Colors.grey, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                borderRad),
            borderSide:
            BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                borderRad),
            borderSide:
            BorderSide(color: AppColors.white, width: 2),
          ),
        ),
      ),
    );
  }

  textFiledAddress(textController, hintText){
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical:
          AppHeight.h1/2,
          horizontal:
          AppWidth.w6),
      child: Container(
       // height: FontSize.s18*2.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.all(Radius.circular(AppWidth.w4/2)),
        ),
        child: TextFormField(
          textAlign: TextAlign.start,
          obscureText: false,
          keyboardType: TextInputType.text,
          controller: textController,
          autovalidateMode:
          AutovalidateMode.onUserInteraction,
          style: TextStyle(
        fontFamily: 'comfortaa',
              color: Colors.black,
              fontSize: FontSize.s18
          ),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.height / 5),
              borderSide: BorderSide(
                color: Colors.white,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.height / 5),
              borderSide: BorderSide(
                color: Colors.white,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
        fontFamily: 'comfortaa',
              fontSize: FontSize.s16,
            ),
          ),
        ),
      ),
    );

  }

  rowIconProfile(icon, text){
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height / 20,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius:
              BorderRadius.all(Radius.circular(10)),
            ),
            child: Icon(
              icon,
              color: Colors.grey[600],
              size: min(MediaQuery.of(context).size.width / 15, MediaQuery.of(context).size.height / 35),
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                MediaQuery.of(context).size.width / 22),
            child: Container(
              child: Text(
                text,
                style: TextStyle(
        fontFamily: 'comfortaa',
                  fontSize: min(MediaQuery.of(context).size.width / 20, MediaQuery.of(context).size.height / 45),
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.grey[600],
              size: min(MediaQuery.of(context).size.width / 20, MediaQuery.of(context).size.height / 45),
            ),
          ),
        ),
      ],
    );
  }

}