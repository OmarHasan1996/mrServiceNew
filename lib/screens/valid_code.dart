import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:closer/constant/app_size.dart';
import 'package:closer/constant/font_size.dart';
import 'package:closer/constant/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:closer/MyWidget.dart';
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/localizations.dart';

import 'dart:convert';
import '../const.dart';
import 'main_screen.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:get/get.dart';
import 'package:closer/screens/signin.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:closer/localization_service.dart' as trrrr;

bool chVer = false;

// ignore: must_be_immutable
class Verification extends StatefulWidget {
  String value;
  String email;
  String password;

  Verification({super.key, required this.value, required this.email, required this.password});
  @override
  // ignore: library_private_types_in_public_api
  _VerificationState createState() =>
      _VerificationState(this.value, this.email, this.password);
}

class _VerificationState extends State<Verification> {
  String value;
  String email;
  String password;
  bool newPassword = false;

  _VerificationState(this.value, this.email, this.password) {
    password == '' ? newPassword = true : newPassword = false;
  }

  int codeLength = 0;
  String code = "";
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  var requiredValidator = RequiredValidator(errorText: 'Required'.tr);
  bool _secureText = true;

  @override
  void initState() {
    super.initState();
    chVer = false;
  }

  @override
  Widget build(BuildContext context) {
    requiredValidator = RequiredValidator(
        errorText: AppLocalizations.of(context)!.translate('Required'));
    var active;
    if (codeLength == 6) {
      active = () async{
        print(value);
        await ver();
      };
    } else {
      active = null;
    }
    var heightSpace = MediaQuery.of(context).size.height / 40;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.mainColor,
        body: DoubleBackToCloseApp(
          snackBar: SnackBar(
            content: Text(AppLocalizations.of(context)!
                .translate('Tap back again to leave')),
          ),
          child: Container(
            //height: MediaQuery.of(context).size.height/1.5,
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 20,
                horizontal: MediaQuery.of(context).size.width / 10),
            child: ListView(
              //crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                !newPassword
                    ? Image.asset(
                        'assets/images/code.png',
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 3,
                      )
                    : Container(
                        //height: MediaQuery.of(context).size.height/30,
                        child: Column(
                          children: [
                            /*Image.asset(
                                'assets/images/code.png',
                                width: MediaQuery.of(context).size.width/5,
                                height: MediaQuery.of(context).size.height/7,
                              ),*/
                            SizedBox(
                              height: heightSpace * 2,
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.height / 70),
                              child: MyWidget(context).textFiled(
                                  passwordController,
                                  '',
                                  AppLocalizations.of(context)!
                                      .translate('newPassword'),
                                  password: true,
                                  obscureText: _secureText,
                                  clickIcon: () => {
                                        setState(() {
                                          _secureText = !_secureText;
                                        })
                                      }),
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.height / 70),
                              child: MyWidget(context).textFiled(
                                  confirmPasswordController,
                                  '',
                                  AppLocalizations.of(context)!
                                      .translate('Confirm Password'),
                                  password: true,
                                  obscureText: _secureText,
                                  clickIcon: () => {
                                        setState(() {
                                          _secureText = !_secureText;
                                        })
                                      },
                                  passwordText: passwordController.text),
                            ),
                            SizedBox(
                              height: heightSpace * 2,
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: heightSpace * 2,
                ),
                Column(
                  //height: MediaQuery.of(context).size.height/5,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: MediaQuery.of(context).size.width / 20),
                      child: MyWidget(context).textBlack20(
                        AppLocalizations.of(context)!.translate(
                            "Enter the 6-digit code sent to your phone"),
                        color: AppColors.white,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: heightSpace / 2,
                    ),
                    buildCodeBox(first: true, last: false),
                  ],
                ),
                //Expanded(child: Container()),
                SizedBox(
                  height: heightSpace * 7,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyWidget(context).textBlack20(
                        AppLocalizations.of(context)!
                            .translate("Didn't receive the code?"),
                        color: AppColors.white,
                        bold: false, scale: 0.9),
                    SizedBox(
                      width: 2,
                    ),
                    GestureDetector(
                      onTap: () {
                        _resend();
                      },
                      child: MyWidget(context).textBlack20(
                          AppLocalizations.of(context)!.translate('Resend'),
                          color: AppColors.yellow,
                          bold: false),
                    )
                  ],
                ),
                SizedBox(
                  height: heightSpace,
                ),
                MyWidget(context).raisedButton(
                    AppLocalizations.of(context)!.translate('Confirm'),
                    active,
                    MediaQuery.of(context).size.width / 1.3,
                    chVer),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCodeBox({required bool first, last}) {
    return Center(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: PinCodeTextField(
          appContext: context,
          textStyle: TextStyle(
              fontSize: FontSize.s18,
              color: AppColors.mainColor,
              fontFamily: 'Gotham'),
          pastedTextStyle: TextStyle(
              fontSize: FontSize.s16,
              color: Colors.green.shade600,
              fontWeight: FontWeight.bold,
              fontFamily: 'BCArabicB'),
          length: 6,
          blinkWhenObscuring: true,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(AppWidth.w1),
              fieldHeight: AppWidth.w12,
              fieldWidth: AppWidth.w12,
              inactiveColor: AppColors.white,
              selectedColor: AppColors.white,
              selectedFillColor: AppColors.white,
              inactiveFillColor: Colors.transparent,
              activeFillColor: AppColors.white,
              borderWidth: 12),
          cursorColor: AppColors.black,
          animationDuration: const Duration(milliseconds: 2),
          enableActiveFill: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (pin) {
            codeLength = pin.length;
            code = pin;
          },
          onCompleted: (pin) {},
        ),
      ),
    );
  }

  Future ver() async {
    setState(() => chVer = true);
    if (newPassword) {
      await _newPasswordVer(passwordController.text);
    } else {
      await _firstVer();
    }
    setState(() => chVer = false);
  }

  _firstVer() async {
    print('Here');
    var apiUrl = Uri.parse('$apiDomain/Main/SignUp/SignUp_Verify');
    Map mapDate = {
      "guidParam": value,
      "txtParam": code,
    };
    http.Response response = await http.post(apiUrl, body: jsonEncode(mapDate), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    });
    if (response.statusCode == 200) {
      //print(response.body);
      // ignore: use_build_context_synchronously
      MyApplication.navigateTo(context, const SignIn());
    } else {
      // ignore: use_build_context_synchronously
      Flushbar(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 30),
        icon: Icon(
          Icons.error_outline,
          size: MediaQuery.of(context).size.height / 30,
          color: AppColors.white,
        ),
        duration: Duration(seconds: 3),
        shouldIconPulse: false,
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        backgroundColor: Colors.grey.withOpacity(0.5),
        barBlur: 20,
        message: jsonDecode(response.body)['Errors'],
        messageSize: MediaQuery.of(context).size.height / 37,
      ).show(context);
    }
  }

  _newPasswordVer(String newPassword) async {
    var apiUrl = Uri.parse(
        '$apiDomain/Main/SignUp/ResetPassword?UserEmail=${email}&code=$code&password=$newPassword');

    print(apiUrl.toString());
    http.Response response = await http.post(apiUrl, headers: {
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      print("we're good");
      print(jsonDecode(response.body));
      //userData = jsonDecode(response.body);
      setState(() {
        if (jsonDecode(response.body)['Errors'] == "") {
          Navigator.of(context).pushNamed('sign_in');
          //isLogIn = true;
          //token = jsonDecode(response.body)["content"]["Token"].toString();
          //updateUserInfo(userData["content"]["Id"]);
        } else {
          //setState(() => chLogIn = false);
          Flushbar(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 30),
            icon: Icon(
              Icons.error_outline,
              size: MediaQuery.of(context).size.height / 30,
              color: AppColors.white,
            ),
            duration: Duration(seconds: 3),
            shouldIconPulse: false,
            flushbarPosition: FlushbarPosition.TOP,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            backgroundColor: Colors.grey.withOpacity(0.5),
            barBlur: 20,
            message: jsonDecode(response.body)['Errors'],
            messageSize: MediaQuery.of(context).size.height / 37,
          ).show(context);
          chVer = false;
        }
      });
    } else {
      print(response.statusCode);
      print('A network error occurred');
    }
  }

  void _resend() async {
    var apiUrl = Uri.parse(
        '$apiDomain/Main/SignUp/ReSendVerificationCode?UserEmail=$email');
    http.Response response = await http.post(apiUrl, headers: {
      "Accept-Language":
          trrrr.LocalizationService.getCurrentLocale().languageCode,
      "Accept": "application/json",
    });
    print(jsonDecode(response.body).toString());
    if (response.statusCode == 200) {
      print("we're good");
      //userData = jsonDecode(response.body);
      setState(() {
        if (jsonDecode(response.body)['Errors'] == "") {
          Flushbar(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 30),
            icon: Icon(
              Icons.error_outline,
              size: MediaQuery.of(context).size.height / 30,
              color: AppColors.white,
            ),
            duration: Duration(seconds: 3),
            shouldIconPulse: false,
            flushbarPosition: FlushbarPosition.TOP,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            backgroundColor: Colors.grey.withOpacity(0.5),
            barBlur: 20,
            message: jsonDecode(response.body)['Errors'],
            messageSize: MediaQuery.of(context).size.height / 37,
          ).show(context);
          //isLogIn = true;
          //token = jsonDecode(response.body)["content"]["Token"].toString();
          //updateUserInfo(userData["content"]["Id"]);
        } else {
          //setState(() => chLogIn = false);
          Flushbar(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 30),
            icon: Icon(
              Icons.error_outline,
              size: MediaQuery.of(context).size.height / 30,
              color: AppColors.white,
            ),
            duration: Duration(seconds: 3),
            shouldIconPulse: false,
            flushbarPosition: FlushbarPosition.TOP,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            backgroundColor: Colors.grey.withOpacity(0.5),
            barBlur: 20,
            message: jsonDecode(response.body)['Errors'],
            messageSize: MediaQuery.of(context).size.height / 37,
          ).show(context);
        }
      });
    } else {
      print(response.statusCode);
      print('A network error occurred');
    }
  }
}
