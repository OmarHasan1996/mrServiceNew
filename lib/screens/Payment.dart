
import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/localizations.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:closer/screens/signin.dart';
import 'package:closer/MyWidget.dart';
import 'package:closer/const.dart';
import 'main_screen.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:iyzico/iyzico.dart' as iyzi;
import 'package:closer/localization_service.dart' as trrrr;
/*//import 'package:stripe_payment/stripe_payment.dart';
import 'dart:io';
*/

class Payment extends StatefulWidget {
  var order;
  var token;
  Payment(this.order, this.token);
  @override
  _PaymentState createState() => new _PaymentState(this.order, this.token);
}

class _PaymentState extends State<Payment> {
 /* Token? _paymentToken;
  PaymentMethod? _paymentMethod;
  String? _error;
  final String _currentSecret = "Your_Secret_key"; //set this yourself, e.g using curl
  PaymentIntentResult? _paymentIntent;
  Source? _source;

  ScrollController _controller = ScrollController();

  final CreditCard testCard = CreditCard(
    number: '4111111111111111',
    expMonth: 08,
    expYear: 22,
  );
*/
 TextEditingController cardHolderNameControler = new TextEditingController();
 TextEditingController cardNumberControler = new TextEditingController();
 TextEditingController cardExperationControler = new TextEditingController();
 TextEditingController cardSecurityControler = new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  var _order;
  var token;

  APIService? api;

 _PaymentState(this._order, this.token);
/*
 Future<void> checkout()async{
   try{
     /// retrieve data from the backend
     //final paymentSheetData = backend.fetchPaymentSheetData();
     // set the publishable key for Stripe - this is mandatory
     Stripe.publishableKey = 'pk_test_51JT7jkCTAUDjRNFVfafy4Gskx1KzUNk8nPj8T51zzCPE18fA17DOFO6MqSZVTCxhVCSWGwouDSe0yjcObAznHLW600VBoGyDcg';
     await Stripe.instance.applySettings();
     await Stripe.instance.initPaymentSheet(
         paymentSheetParameters: SetupPaymentSheetParameters(
           applePay: true,
           googlePay: true,
           style: ThemeMode.dark,
           testEnv: true,
           merchantCountryCode: 'DE',
           merchantDisplayName: 'Mr-Service',
           customerId: cardHolderNameControler.text,
           paymentIntentClientSecret: cardNumberControler.text,
           customerEphemeralKeySecret: cardSecurityControler.text,
         ));

     await Stripe.instance.presentPaymentSheet();
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Payment completed!')),);

   }catch(e){
     if (e is StripeException) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text('Error from Stripe: ${e.error.localizedMessage}'),
         ),
       );
     } else {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Error: $e')),
       );
     }
   }
 }
*/
  @override
  initState() {
    super.initState();
    _dateController.text = DateTime.now().toString().split(' ')[0].split('-')[0].substring(2) + ' / ' + selectedDate.toString().split(' ')[0].split('-')[1];
    cardNumberControler.text = '';
    cardHolderNameControler.text = '';
    cardExperationControler.text = '';
    cardSecurityControler.text = '';
    _order['PayType'] == 1 ? cash = true: cash = false;
    cardSecurityControler.addListener(() { _onlyThreeChar(cardSecurityControler); });
    cardNumberControler.addListener(() { _cardNumber(cardNumberControler); });

    /*StripePayment.setOptions(
        StripeOptions(
            publishableKey: "Your_Publish_key",
            merchantId: "Your_Merchant_id",
            androidPayMode: 'test'
        ));*/
  }
/*
  void setError(dynamic error) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
    });
  }
*/

  @override
  Widget build(BuildContext context) {
    var barHight = MediaQuery.of(context).size.height / 5.7;
    api = APIService(context: context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      key: _scaffoldKey,
      appBar: MyWidget.appBar(title: AppLocalizations.of(context)!.translate('payment'), ),
      endDrawer: MyWidget(context).drawer(barHight, MediaQuery.of(context).size.height / 80 * 3, ()=> _setState()),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child:  Column(
            children: [
              MyWidget.topYellowDriver(),
              SizedBox(
                height: MediaQuery.of(context).size.height / 80,
              ),
              _cardCheck(MediaQuery.of(context).size.width),
              //_bottun(AppLocalizations.of(context)!.translate('Bay Cash'),_bayCash),
              _card(AppLocalizations.of(context)!.translate('cardHolderName'), cardHolderNameControler, '', MediaQuery.of(context).size.width, false, false),
              _card(AppLocalizations.of(context)!.translate('card number'), cardNumberControler, '', MediaQuery.of(context).size.width, false, true, cardNum: true),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width / 15,),
                  _dateSelect(AppLocalizations.of(context)!.translate('Expiration Date'),  MediaQuery.of(context).size.width/2.3),
                  _card(AppLocalizations.of(context)!.translate('Security code'), cardSecurityControler, '', MediaQuery.of(context).size.width/2.75, true, true),
                ],
              ),
              _bottun(AppLocalizations.of(context)!.translate('Order Now'),_orderNow),
            ],
          ),
        ),
      ),
    );
  }
  _appBar(barHight, ){
    return AppBar(
      toolbarHeight: barHight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(MediaQuery.of(context).size.height / 80 * 3),
            bottomLeft: Radius.circular(MediaQuery.of(context).size.height / 80 * 3)),
      ),
      backgroundColor: AppColors.blue,
      title: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height / 80 * 3),
        child: Image.asset(
          'assets/images/Logo1.png',
          width: MediaQuery.of(context).size.width / 6,
          height: barHight / 2,
        ),
      ),
      actions: [
        IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }

  _card(headerText, controller, hintText, width, obscureText, bool num, {bool? cardNum}){
    cardNum??=false;
    return !cash? Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height / 80,
        horizontal: MediaQuery.of(context).size.width / 15,
      ),
      child: Container(
        alignment: Alignment.centerLeft,
        width: width,
        height: MediaQuery.of(context).size.height / 7,
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
        child:  Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 20,
            vertical: MediaQuery.of(context).size.height / 40,
          ),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  headerText,
                  style: TextStyle(
        fontFamily: 'comfortaa',color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.width / 28,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextField(
                  keyboardType: num? TextInputType.number: TextInputType.name,
                  inputFormatters: cardNum?[
                    LengthLimitingTextInputFormatter(19),
                    // ignore: deprecated_member_use
                    //WhitelistingTextInputFormatter.digitsOnly
                  ]:[],
                  onChanged: (k){
                    if(cardNum!){
                      k = k.replaceAll(' ', '');
                      k = k.replaceAll('  ', '');
                      k = k.replaceAll('   ', '');
                      List siplt = [];
                      for(int i = 4; i < k.length; i++){
                        if(i % 4 == 0){
                          siplt.add(k.substring(i-4,i));
                        }
                      }
                      for(int i = 0; i < siplt.length; i++){
                        k = k.replaceRange(i*5, i*5+4, siplt[i] + ' ');
                      }
                      cardNumberControler.text = k;
                      cardNumberControler.selection = TextSelection.fromPosition(TextPosition(offset: cardNumberControler.text.length));
                      print(k);
                    }
                    //controller.text=k;
                  },
                  obscureText: obscureText,
                  controller: controller,
                  style: TextStyle(
        fontFamily: 'comfortaa',
                      color: AppColors.black,
                      fontSize: MediaQuery.of(context).size.width / 20),
                  decoration: InputDecoration(
                    hintText: hintText,
                    labelText: AppLocalizations.of(context)!.translate('Email Address'),
                    errorStyle: TextStyle(
        fontFamily: 'comfortaa',
                        fontSize:
                        MediaQuery.of(context).size.width / 24),
                    labelStyle: TextStyle(
        fontFamily: 'comfortaa',
                      fontSize: MediaQuery.of(context).size.width / 20,
                      color: Colors.white,
                    ),
                    hintStyle: TextStyle(
        fontFamily: 'comfortaa',
                      fontSize: MediaQuery.of(context).size.width / 20,
                      color: Colors.grey,
                    ),
                    /*enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height / 12),
                                  borderSide:
                                  BorderSide(color: Colors.grey, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.height / 12),
                                borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.height / 12),
                                borderSide:
                                BorderSide(color: Colors.red, width: 2),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.height / 12),
                                borderSide:
                                BorderSide(color: Colors.red, width: 2),
                              ),*/
                  ),
                ),),
            ],
          ),
        ),
      ),
    ):SizedBox(height: MediaQuery.of(context).size.height / 7,);
  }

  _cardCheck(width){
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height / 80,
        horizontal: MediaQuery.of(context).size.width / 15,
      ),
      child: ToggleSwitch(
        minWidth: MediaQuery.of(context).size.width/2.4,
        minHeight: MediaQuery.of(context).size.height/13,
        fontSize: MediaQuery.of(context).size.width / 15,
        initialLabelIndex: cash ? 0:1,
        cornerRadius: MediaQuery.of(context).size.height/51,
        activeFgColor: AppColors.yellow,
        inactiveBgColor: Colors.grey,
        inactiveFgColor: AppColors.white,
        totalSwitches: 2,
        labels: [AppLocalizations.of(context)!.translate('cash'), AppLocalizations.of(context)!.translate('card')],
        //icons: [Icons.credit_card, Icons.credit_card],
        activeBgColors: [[AppColors.mainColor],[AppColors.mainColor]],
        animate: true, // with just animate set to true, default curve = Curves.easeIn
        curve: Curves.bounceInOut, // animate must be set to true when using custom curve
        onToggle: (index) {
          setState(() {
            index == 0? cash = true : cash = false;
          });
          //print('switched to: $index');
        },
      ),
      /* Container(
        alignment: Alignment.center,
        width: width,
        height: MediaQuery.of(context).size.height / 12,
        decoration: BoxDecoration(
          color: MyColors.White,
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
            vertical: MediaQuery.of(context).size.height / 60,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.translate('Bay Cash'),style: TextStyle(
        fontFamily: 'comfortaa',
                  color: MyColors.black,
                  fontSize: MediaQuery.of(context).size.width / 15,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'OpenSans'),),
              SizedBox(width: MediaQuery.of(context).size.width / 10,),
              _checkBox(),
            ],
          ),
        ),
      ),*/
    );
  }

  var chCircle = false;
  bool cash = false;

  /*_listView(){
    ListView(
      controller: _controller,
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        RaisedButton(
          child: Text("Create Source"),
          onPressed: () {
            StripePayment.createSourceWithParams(SourceParams(
              type: 'ideal',
              amount: 2102,
              currency: 'eur',
              returnURL: 'example://stripe-redirect',
            )).then((source) {
              _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text('Received ${source.sourceId}')));
              setState(() {
                _source = source;
              });
            }).catchError(setError);
          },
        ),
        Divider(),
        RaisedButton(
          child: Text("Create Token with Card Form"),
          onPressed: () {
            StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest()).then((paymentMethod) {
              _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text('Received ${paymentMethod.id}')));
              setState(() {
                _paymentMethod = paymentMethod;
              });
            }).catchError(setError);
          },
        ),
        RaisedButton(
          child: Text("Create Token with Card"),
          onPressed: () {
            StripePayment.createTokenWithCard(
              testCard,
            ).then((token) {
              _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
              setState(() {
                _paymentToken = token;
              });
            }).catchError(setError);
          },
        ),
        Divider(),
        RaisedButton(
          child: Text("Create Payment Method with Card"),
          onPressed: () {
            StripePayment.createPaymentMethod(
              PaymentMethodRequest(
                card: testCard,
              ),
            ).then((paymentMethod) {
              _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text('Received ${paymentMethod.id}')));
              setState(() {
                _paymentMethod = paymentMethod;
              });
            }).catchError(setError);
          },
        ),
        RaisedButton(
          child: Text("Create Payment Method with existing token"),
          onPressed: _paymentToken == null
              ? null
              : () {
            StripePayment.createPaymentMethod(
              PaymentMethodRequest(
                card: CreditCard(
                  token: _paymentToken!.tokenId,
                ),
              ),
            ).then((paymentMethod) {
              _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text('Received ${paymentMethod.id}')));
              setState(() {
                _paymentMethod = paymentMethod;
              });
            }).catchError(setError);
          },
        ),
        Divider(),
        RaisedButton(
          child: Text("Confirm Payment Intent"),
          onPressed: _paymentMethod == null || _currentSecret == null
              ? null
              : () {
            StripePayment.confirmPaymentIntent(
              PaymentIntent(
                clientSecret: _currentSecret,
                paymentMethodId: _paymentMethod!.id,
              ),
            ).then((paymentIntent) {
              _scaffoldKey.currentState!
                  .showSnackBar(SnackBar(content: Text('Received ${paymentIntent.paymentIntentId}')));
              setState(() {
                _paymentIntent = paymentIntent;
              });
            }).catchError(setError);
          },
        ),
        RaisedButton(
          child: Text("Authenticate Payment Intent"),
          onPressed: _currentSecret == null
              ? null
              : () {
            StripePayment.authenticatePaymentIntent(clientSecret: _currentSecret).then((paymentIntent) {
              _scaffoldKey.currentState!
                  .showSnackBar(SnackBar(content: Text('Received ${paymentIntent.paymentIntentId}')));
              setState(() {
                _paymentIntent = paymentIntent;
              });
            }).catchError(setError);
          },
        ),
        Divider(),
        RaisedButton(
          child: Text("Native payment"),
          onPressed: () {
            if (Platform.isIOS) {
              _controller.jumpTo(450);
            }
            StripePayment.paymentRequestWithNativePay(
              androidPayOptions: AndroidPayPaymentRequest(
                totalPrice: "2.40",
                currencyCode: "EUR",
              ),
              applePayOptions: ApplePayPaymentOptions(
                countryCode: 'DE',
                currencyCode: 'EUR',
                items: [
                  ApplePayItem(
                    label: 'Test',
                    amount: '27',
                  )
                ],
              ),
            ).then((token) {
              setState(() {
                _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
                _paymentToken = token;
              });
            }).catchError(setError);
          },
        ),
        RaisedButton(
          child: Text("Complete Native Payment"),
          onPressed: () {
            StripePayment.completeNativePayRequest().then((_) {
              _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text('Completed successfully')));
            }).catchError(setError);
          },
        ),
        Divider(),
        Text('Current source:'),
        Text(
          JsonEncoder.withIndent('  ').convert(_source?.toJson() ?? {}),
          style: TextStyle(
        fontFamily: 'comfortaa',fontFamily: "Monospace"),
        ),
        Divider(),
        Text('Current token:'),
        Text(
          JsonEncoder.withIndent('  ').convert(_paymentToken?.toJson() ?? {}),
          style: TextStyle(
        fontFamily: 'comfortaa',fontFamily: "Monospace"),
        ),
        Divider(),
        Text('Current payment method:'),
        Text(
          JsonEncoder.withIndent('  ').convert(_paymentMethod?.toJson() ?? {}),
          style: TextStyle(
        fontFamily: 'comfortaa',fontFamily: "Monospace"),
        ),
        Divider(),
        Text('Current payment intent:'),
        Text(
          JsonEncoder.withIndent('  ').convert(_paymentIntent?.toJson() ?? {}),
          style: TextStyle(
        fontFamily: 'comfortaa',fontFamily: "Monospace"),
        ),
        Divider(),
        Text('Current error: $_error'),
      ],
    );

  }*/
  _bottun(text,press){
    return MyWidget(context).raisedButton(text, ()=>press(), MediaQuery.of(context).size.width/1.2, chCircle);
    /*return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/80),
      width: MediaQuery.of(context).size.width/1.2,
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.height / 12)),
        color: MyColors.yellow,
        child: chCircle == true
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

    );*/
  }

  _bayCash() async{
    _bay() async{
      setState(() {chCircle = true;});
      bool _suc = await api!.updateOrder(token, _order, 6, 1, null, null);
      setState(() {chCircle = false;});
      if (_suc){
        Navigator.pop(context);
        //api!.flushBar(AppLocalizations.of(context)!.translate('Order Saved'));
        //new Timer(Duration(seconds:2), ()=>setState(() {}));
        //setState(() {});
      }
    }
    showDialog(context: context, builder: (context) => AlertDialog(
      content: ListTile(
        title:  SizedBox(height: MediaQuery.of(context).size.height/40,),
        subtitle: Text(AppLocalizations.of(context)!.translate('Are you sure? You want to pay Cash!')),
      ),
      actions: <Widget> [
        IconButton(icon: Icon(Icons.close, /*color: MyColors.yellow*/), onPressed:(){
          Navigator.pop(context);
          //setState(() {});
        }, alignment: Alignment.centerLeft,
        ),
        SizedBox(width: MediaQuery.of(context).size.width/4.5,),
        ElevatedButton(
            onPressed: () => {
              Navigator.pop(context),
              _bay(),
            },
            child: Icon(Icons.check, color: AppColors.yellow)),
      ],
    ));
  }

  DateTime? selectedDate = DateTime.now();

  TextEditingController _dateController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate as DateTime,
        initialDatePickerMode: DatePickerMode.year,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null)

      setState(() {
        selectedDate = picked;
        print("this is the Date");
        //print(selectedDate.toString().split(' ')[0].split('-')[0].substring(2) + '-' + selectedDate.toString().split(' ')[0].split('-')[1]);
        print(selectedDate);
        print("timeZone");
        print(DateTime.now().timeZoneName);
        print(DateTime.now().timeZoneOffset);
        //_dateController.text = DateFormat.yMMMM().format(selectedDate as DateTime);
        _dateController.text = selectedDate.toString().split(' ')[0].split('-')[0].substring(2) + ' / ' + selectedDate.toString().split(' ')[0].split('-')[1];
      });
  }

  String? _setTime, _setDate;

  _dateSelect(headerText, width){
    return !cash? Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 80,
        bottom: MediaQuery.of(context).size.height / 80,
        //left: MediaQuery.of(context).size.width / 15,
        //right: MediaQuery.of(context).size.width / 15,
      ),
      child: Container(
        alignment: Alignment.centerLeft,
        width: width,
        height: MediaQuery.of(context).size.height / 7,
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
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text(headerText,
                  style: TextStyle(
        fontFamily: 'comfortaa',color: Colors.grey, fontSize: MediaQuery.of(context).size.width / 28,),),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: TextFormField(
                          style: TextStyle(
        fontFamily: 'comfortaa',fontSize: MediaQuery.of(context).size.width / 20),
                          //textAlign: TextAlign.left,
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _dateController,
                          onSaved: (String?val) {_setDate = val;},
                          decoration: InputDecoration(
                              disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                              // labelText: 'Time',
                              contentPadding: EdgeInsets.only(top: 0.0)),
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
    ):SizedBox(height: MediaQuery.of(context).size.height / 7,);
  }

  _checkBox(){
    return FlutterSwitch(
      width: MediaQuery.of(context).size.width/4,//125.0,
      height: MediaQuery.of(context).size.height/15,//55.0,
      valueFontSize: MediaQuery.of(context).size.width/16,//25.0,
      toggleSize: MediaQuery.of(context).size.height/18,//45.0,
      value: cash,
      activeColor: AppColors.yellow,
      borderRadius: MediaQuery.of(context).size.height/26,//30.0,
      padding: MediaQuery.of(context).size.width/50,//8.0,
      showOnOff: true,
      onToggle: (val) {
        setState(() {
          cash = val;
        });
      },
    );
  }

  _orderNow() async{

    if(cash){
      _bayCash();
    }else{
      //await checkout();
      if(cardSecurityControler.text == '' || cardHolderNameControler.text == '' || cardNumberControler.text == '' || _dateController.text == '' )
        APIService.flushBar(AppLocalizations.of(context)!.translate('Please! Fill all information before Order'));
      else
        await checkoutIyzi();
    }
  }

  Future<void> checkoutIyzi() async {
    setState(() {
      chCircle = true;
    });
//Set up your iyzico configurations
    const iyziConfig = iyzi.IyziConfig(
        'sandbox-6mnciSLrn4PTZ9YO6L46stxBTZAqx2wK',
        'sandbox-gOIur7Xtqtjdom9rtvtJPnL8FEZv9pFk',
        'https://sandbox-api.iyzipay.com');

    //Create an iyzico object
    final iyzico = iyzi.Iyzico.fromConfig(configuration: iyziConfig);

    // //requesting bin number
    // final binResult = await iyzico.retrieveBinNumberRequest(binNumber: '542119');
    // print(binResult);

    // //requesting Installment Info

    // final installmentResult =
    //     await iyzico.retrieveInstallmentInfoRequest(price: 10);
    // print(installmentResult);

    // final installmentResult2 = await iyzico.retrieveInstallmentInfoRequest(
    //     price: 10, binNumber: '542119');
    // print(installmentResult2);

    //Create Payment Request

    // ignore: omit_local_variable_types
    final double price =  _order['Amount'];
    // ignore: omit_local_variable_types
    final double paidPrice = _order['Amount'];
    /*try{
      cardNumberControler.text = cardNumberControler.text.replaceAll(' ', '');
    }catch(e){

    }*/
    var paymentCard = iyzi.PaymentCard(
      cardHolderName: cardHolderNameControler.text,
      cardNumber: cardNumberControler.text.replaceAll(' ', ''),
      expireYear: selectedDate!.year.toString(),
      expireMonth: selectedDate!.month.toString(),
      cvc: cardSecurityControler.text,
    );
    /*paymentCard = iyzi.PaymentCard(
      cardHolderName: "John Doe",
      cardNumber: "5528790000000008",
      expireYear: "2030",
      expireMonth: "12",
      cvc: "222",
    );*/

    final shippingAddress = iyzi.Address(
        address: '${_order['Address']['notes']}, ${_order['Address']['building']}. ${_order['Address']['Floor']}. No:${_order['Address']['appartment']}',
        contactName: '${_order['User']['Name']} ${_order['User']['LastName']}',
        zipCode: '${_order['Address']['AreaId']}',
        city: '${_order['Address']['Area']['City']['Name']}',
        country: '${_order['Address']['Area']['Name']}');
    final billingAddress = iyzi.Address(
        address: '${_order['Address']['notes']}, ${_order['Address']['building']}. ${_order['Address']['Floor']}. No:${_order['Address']['appartment']}',
        contactName: '${_order['User']['Name']} ${_order['User']['LastName']}',
        city: '${_order['Address']['Area']['City']['Name']}',
        country: '${_order['Address']['Area']['Name']}');


    final buyer = iyzi.Buyer(
        id: '${_order['CustomerId']}',
        name: '${_order['User']['Name']}',
        surname: '${_order['User']['LastName']}',
        identityNumber: '${_order['User']['Mobile']}',
        email: '${_order['User']['Email']}',
        registrationAddress: '${_order['AddressId']}',
        city: '${_order['Address']['Area']['City']['Name']}',
        country: '${_order['Address']['Area']['Name']}',
        ip: '85.34.78.112'
    );

    final basketItems = <iyzi.BasketItem>[
      iyzi.BasketItem(
          id: 'BI101',
          price: '0.3',
          name: 'Binocular',
          category1: 'Collectibles',
          category2: 'Accessories',
          itemType: iyzi.BasketItemType.PHYSICAL),
      iyzi.BasketItem(
          id: 'BI102',
          price: '0.5',
          name: 'Game code',
          category1: 'Game',
          category2: 'Online Game Items',
          itemType: iyzi.BasketItemType.VIRTUAL),
    ];
    basketItems.clear();
    for(int i = 0; i < _order['Servicess'].length; i++){
      basketItems.add(iyzi.BasketItem(
          id: '${_order['Servicess'][i]['Service']['Id']}',
          price: '${_order['Servicess'][i]['Service']['Price']}',
          name: '${_order['Servicess'][i]['Service']['Name']}',
          category1: '${_order['Servicess'][i]['Service']['ServiceParentId']}',
          //category2: 'Usb / Cable',
          itemType: iyzi.BasketItemType.PHYSICAL
      ));
    }
    print(trrrr.LocalizationService.getCurrentLocale().languageCode);
    var _local = trrrr.LocalizationService.getCurrentLocale().languageCode;
    if(_local == 'ar')
      _local = 'en';
    final paymentResult = await iyzico.CreatePaymentRequest(
        locale: _local,
        price: price,
        paidPrice: paidPrice * 1.00,
        paymentCard: paymentCard,
        buyer: buyer,
        currency: iyzi.Currency.TRY,
        shippingAddress: shippingAddress,
        billingAddress: billingAddress,
        basketItems: basketItems);

    //print(paymentResult);
    print(paymentResult);

    // Initialize 3DS PAYMENT REQUEST
/*
    final initializeThreeds = await iyzico.initializeThreedsPaymentRequest(
      locale: trrrr.LocalizationService.getCurrentLocale().languageCode,
      price: price,
      paidPrice: paidPrice,
      paymentCard: paymentCard,
      buyer: buyer,
      shippingAddress: shippingAddress,
      billingAddress: billingAddress,
      currency: iyzi.Currency.USD,
      basketItems: basketItems,
      callbackUrl: 'info@mr-service.online',
    );
    print(initializeThreeds);
*/
    // // Create 3DS payment requesr
    // final createThreedsRequest = await iyzico.createThreedsPaymentRequest(
    //     paymentConversationId: '123456789');
    // print(createThreedsRequest);

    // // Init Checkout Form

    //final initChecoutForm = await iyzico.initializeCheoutForm(
    //    price: price,
    //    currency: iyzi.Currency.USD.toString(),
    //    paidPrice: paidPrice,
    //    paymentCard: paymentCard,
    //    buyer: buyer,
    //    shippingAddress: shippingAddress,
    //    billingAddress: billingAddress,
    //    basketItems: basketItems,
    //    callbackUrl: 'info@mr-service.online',
    //    locale: trrrr.LocalizationService.getCurrentLocale().languageCode,
    //    enabledInstallments: []);
    //print(initChecoutForm);
    if(paymentResult.status.toString() == 'failure'){
      APIService.flushBar(paymentResult.errorMessage);
      setState(() {
        chCircle = false;
      });
    }
    else{
     bool _suc = await api!.updateOrder(token, _order, 6, 2, null, null);
      if (_suc){
        setState(() {});
        Navigator.of(context).pop();
        //api!.flushBar(AppLocalizations.of(context)!.translate('Order Saved'));
        //new Timer(Duration(seconds:2), ()=>setState(() {}));
        //setState(() {});
      }else
        setState(() {
          chCircle = false;
        });
    }
    // final retrieveCheckoutForm =
    //     await iyzico.retrieveCheckoutForm(token: 'token');
    // print(retrieveCheckoutForm);
  }

  _setState() {
    setState(() {

    });
  }

  _onlyThreeChar(TextEditingController controller){
    if(controller.text.length>3){
      controller.text = controller.text.substring(0,3);
    }
  }
  
  _cardNumber(TextEditingController controller){
    /*try{
      controller.text = controller.text.replaceAll(' ', '');
    }catch(e){

    }*/
   /* var k = controller.text;
    k = k.replaceAll(' ', '');
    k = k.replaceAll('  ', '');
    k = k.replaceAll('   ', '');
    if(k.length>17) {
      //controller.text = controller.text.substring(0,19);
      return;
    }

    List siplt = [];
    for(int i = 4; i < k.length; i++){
      if(i % 4 == 0){
        siplt.add(k.substring(i-4,i));
      }
    }
    for(int i = 0; i < siplt.length; i++){
      k = k.replaceRange(i*5, i*5+4, siplt[i] + ' ');
    }
    print(k);
    if(k.length>19){
      k.substring(0,19);
      //controller.text = k;
    }
    //controller.text=k;*/
  }
}
