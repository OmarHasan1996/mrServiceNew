import 'dart:convert';
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:closer/constant/apiUrl.dart';
import 'package:closer/constant/functions.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/localizations.dart';
import 'package:closer/screens/register.dart';
import 'package:closer/screens/valid_code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:closer/map/orderTrackingPage.dart';
import 'package:closer/MyWidget.dart';
import 'package:closer/const.dart';
import 'main_screen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
bool isLogIn = false;
bool chLogIn = false;
String token = '';
List service = [];
List serviceTotoal = [];

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  void getServiceData() async {
    var url = Uri.parse('${ApiUrl.mainServiceRead}cityid=$cityId&filter=Service.ServiceParentId~eq~null');
    http.Response response = await http.get(url, headers: {
      "Authorization": token,
    });
    print("we're here now");
    if (response.statusCode == 200) {
      var item = json.decode(response.body)["result"]['Data'];
      setState(() {
        editTransactionService(transactions![0], service);
        /*for(int i =0; i<item.length; i++){
          if(item[i]['ServiceParentId']==null){
            item.removeAt(i);
            i--;
          }
        }*/
        service.clear();// = item;
        for(var e in item){
          service.add(e['Service']);
        }
      });
      setState(() => chLogIn = false);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MainScreen(
                token: token,
                service: service,selectedIndex: 0,
            initialOrderTab: 0,
          )));
    } else {
      setState(() {
        service = [];
      });
    }
  }

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  //late LoginRequestModel requestModel;
  bool isApiCallProcess = false;
  var _formKey = GlobalKey<FormState>();
  //bool _isLoading =false;
  bool _secureText = true;

  Map userobj = {};//for facebookSignIn
  late GoogleSignInAccount? userObjg; //for google

  GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
    //requestModel = new LoginRequestModel(email: '', password: '');
    apiService = APIService(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.mainColor,
        body: DoubleBackToCloseApp(
          snackBar: SnackBar(
            content: Text(AppLocalizations.of(context)!.translate('Tap back again to leave')),
          ),
          child: Builder(builder: (context) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height /25,
                    horizontal: MediaQuery.of(context).size.width / 15),
                child: Container(
                    // padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 40.0),
                    child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: MyWidget(context).textHead10(
                        AppLocalizations.of(context)!.translate('Sign In'),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 25,
                    ),
                    Expanded(
                      flex: 3,
                      child: MyWidget(context).textFiled(emailController,AppLocalizations.of(context)!.translate('useremail@domain.com'),AppLocalizations.of(context)!.translate('Email Address'),email: true),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 60,
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: MediaQuery.of(context).size.height / 10,
                        child: MyWidget(context).textFiled(passwordController, '********', AppLocalizations.of(context)!.translate('Password'), password: true, clickIcon: ()=>{
                        setState(() {
                        _secureText = !_secureText;
                        }),
                        }, obscureText: _secureText),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 120,
                    ),
                   //forget password
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: MediaQuery.of(context).size.height / 20,
                        child: GestureDetector(
                          onTap: () {
                            _forgetPasssword(emailController.text);
                          },
                          child: MyWidget(context).textBlack20(AppLocalizations.of(context)!.translate('Forgot Password?'), color: AppColors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 60,
                    ),
                    Expanded(
                      flex: 2,
                      child: MyWidget(context).raisedButton(AppLocalizations.of(context)!.translate('Sign In'), () => _signIn(),  MediaQuery.of(context).size.width/1.2, chLogIn)
                      /*Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: MediaQuery.of(context).size.height / 10,
                        // ignore: deprecated_member_use
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(MediaQuery.of(context).size.height / 12)),
                          color: MyColors.yellow,
                        ),
                        /*shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height / 12)),
                        */
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              //color: MyColors.yellow,
                              primary: MyColors.yellow,
                              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.height / 12)),
                          ),
                          //elevation: 5.0,
                          child: chLogIn == true
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      MyColors.blue),
                                  backgroundColor: Colors.grey,
                                )
                              : Text(AppLocalizations.of(context)!.translate('Sign In'),
                                  style: TextStyle(
        fontFamily: 'comfortaa',
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              20,
                                      color: MyColors.buttonTextColor,
                                      fontWeight: FontWeight.bold),
                                ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences.setString('email', emailController.text);
                              await SharedPreferences.getInstance();
                              sharedPreferences.setString('password', passwordController.text);
                              signIn(emailController.text,
                                  passwordController.text);
                            } else {
                              await Flushbar(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height /
                                            20),
                                icon: Icon(
                                  Icons.error_outline,
                                  size: MediaQuery.of(context).size.width / 18,
                                  color: Colors.white,
                                ),
                                duration: Duration(seconds: 3),
                                shouldIconPulse: false,
                                flushbarPosition: FlushbarPosition.TOP,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    MediaQuery.of(context).size.height / 37)),
                                backgroundColor: Colors.grey.withOpacity(0.5),
                                barBlur: 20,
                                message:
                                AppLocalizations.of(context)!.translate('Please Enter Username and Password'),
                                messageSize: MediaQuery.of(context).size.width / 22,
                              ).show(context);
                            }
                          },
                        ),
                      ),*/
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 30,
                    ),
                    //register
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        // ignore: deprecated_member_use
                        child: MyWidget(context).raisedButton(AppLocalizations.of(context)!.translate('Sign Up'), () => _signUp(),  MediaQuery.of(context).size.width/1.2, chLogIn)

                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20,
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    //faceBook
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              FacebookAuth.instance.login(permissions: [
                                "public_profile", "email"
                              ]).then((value) async {
                                if(value.status.index== 1){
                                  APIService.flushBar(AppLocalizations.of(context)!.translate("Sign in doesn't complete"));
                                  return;
                                }else if(value.status.index == 0){
                                  await _faceBookLogIn();
                                }else{
                                  APIService.flushBar(value.message.toString());
                                  return;
                                }
                              });
                            },
                            child: Container(
                              height: min(MediaQuery.of(context).size.width / 5,MediaQuery.of(context).size.height / 12),
                              width: min(MediaQuery.of(context).size.width / 5,MediaQuery.of(context).size.height / 12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/facebook.png')),
                              ),

                              //child: Icon(Icons.facebook, size: 80, color: Color(0xffffca05),),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 12,
                          ),
                        //googleSignIn
                          GestureDetector(
                            onTap: () async {
                              await _googleLogIn();
                            },
                            child: Container(
                              height: min(MediaQuery.of(context).size.width / 5,MediaQuery.of(context).size.height / 12),
                              width: min(MediaQuery.of(context).size.width / 5,MediaQuery.of(context).size.height / 12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/google.png')),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 12,
                          ),
                          //AppleSignIn
                          GestureDetector(
                            onTap: () async {
                              final credential = await SignInWithApple.getAppleIDCredential(
                                scopes: [
                                  AppleIDAuthorizationScopes.email,
                                  AppleIDAuthorizationScopes.fullName,
                                ],
                                webAuthenticationOptions: WebAuthenticationOptions(
                                      // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
                                   //redirectURL = "https://SERVER_AS_PER_THE_DOCS.glitch.me/callbacks/sign_in_with_apple";
                                  //'https://api.mr-service.co.com/callbacks/sign_in_with_apple'
                                  //clientID = "AS_PER_THE_DOCS";
                                      clientId:
                                      'co.mr-service.api',

                                      redirectUri:
                                      // For web your redirect URI needs to be the host of the "current page",
                                      // while for Android you will be using the API server that redirects back into your app via a deep link
                                      //kIsWeb
                                       //   ? Uri.parse('https://${window.location.host}/') :
                                      Uri.parse(
                                        //'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                                        'https://api.mr-service.co.com/callbacks/sign_in_with_apple'
                                      ),
                                    ),
                                // TODO: Remove these if you have no need for them
                                // nonce: 'example-nonce',
                                // state: 'example-state',
                              );

                              // ignore: avoid_print
                              print(credential);

                              try{

                                Map mapDate = {
                                  "Name": credential.givenName!,
                                  "LastName": credential.familyName!.toString(),
                                  "Mobile": '',
                                  "Email": credential.email!.toString(),
                                  "Password": 'password',
                                };
                                setState(() => chLogIn = false);
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => new Register(true,mapDate: mapDate,)));
                                //setState(()=>chLogIn =false);
                            }catch(e){
                                APIService.flushBar(e.toString());
                              }
                              // This is the endpoint that will convert an authorization code obtained
                              // via Sign in with Apple into a session in your system
                              final signInWithAppleEndpoint = Uri(
                                scheme: 'https',
                                host: 'flutter-sign-in-with-apple-example.glitch.me',
                                path: '/sign_in_with_apple',
                                queryParameters: <String, String>{
                                  'code': credential.authorizationCode,
                                  if (credential.givenName != null)
                                    'firstName': credential.givenName!,
                                  if (credential.familyName != null)
                                    'lastName': credential.familyName!,
                                  'useBundleId':
                                  /*!kIsWeb && (Platform.isIOS || Platform.isMacOS)
                                          ? 'true':*/
                                  'false',
                                  if (credential.state != null) 'state': credential.state!,
                                },
                              );

                              final session = await http.Client().post(
                                signInWithAppleEndpoint,
                              );

                              // If we got this far, a session based on the Apple ID credential has been created in your system,
                              // and you can now set this as the app's session
                              // ignore: avoid_print
                              print(session);
                            },
                            child: Container(
                              height: min(MediaQuery.of(context).size.width / 5,MediaQuery.of(context).size.height / 12),
                              width: min(MediaQuery.of(context).size.width / 5,MediaQuery.of(context).size.height / 12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage('assets/images/apple.png'), fit: BoxFit.cover),
                              ),
                              /*child: SignInWithAppleButton(
                                onPressed: () async {
                                  final credential = await SignInWithApple.getAppleIDCredential(
                                    scopes: [
                                      AppleIDAuthorizationScopes.email,
                                      AppleIDAuthorizationScopes.fullName,
                                    ],
                                    /*webAuthenticationOptions: WebAuthenticationOptions(
                                      // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
                                      clientId:
                                      'de.lunaone.flutter.signinwithappleexample.service',

                                      redirectUri:
                                      // For web your redirect URI needs to be the host of the "current page",
                                      // while for Android you will be using the API server that redirects back into your app via a deep link
                                      kIsWeb
                                          ? Uri.parse('https://${window.location.host}/')
                                          : Uri.parse(
                                        'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                                      ),
                                    ),*/
                                    // TODO: Remove these if you have no need for them
                                   // nonce: 'example-nonce',
                                   // state: 'example-state',
                                  );

                                  // ignore: avoid_print
                                  print(credential);

                                  // This is the endpoint that will convert an authorization code obtained
                                  // via Sign in with Apple into a session in your system
                                  final signInWithAppleEndpoint = Uri(
                                    scheme: 'https',
                                    host: 'flutter-sign-in-with-apple-example.glitch.me',
                                    path: '/sign_in_with_apple',
                                    queryParameters: <String, String>{
                                      'code': credential.authorizationCode,
                                      if (credential.givenName != null)
                                        'firstName': credential.givenName!,
                                      if (credential.familyName != null)
                                        'lastName': credential.familyName!,
                                      'useBundleId':
                                      /*!kIsWeb && (Platform.isIOS || Platform.isMacOS)
                                          ? 'true':*/
                                           'false',
                                      if (credential.state != null) 'state': credential.state!,
                                    },
                                  );

                                  final session = await http.Client().post(
                                    signInWithAppleEndpoint,
                                  );

                                  // If we got this far, a session based on the Apple ID credential has been created in your system,
                                  // and you can now set this as the app's session
                                  // ignore: avoid_print
                                  print(session);
                                },
                              ),*/
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 30,
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyWidget(context).textBlack20(AppLocalizations.of(context)!.translate("Don't have an account?"), color: AppColors.white, bold: false),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 72,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => new Register(false)));
                            },
                            child: MyWidget(context).textBlack20(AppLocalizations.of(context)!.translate('Register'), color: AppColors.yellow, bold: false),
                          )
                        ],
                      ),
                    )
                  ],
                )
                ),
              ),
            );
          }),
        ),
      );

  }

  _signIn() async {
    //MyApplication.navigateTo(context, OrderTrackingPage());
    if (_formKey.currentState!.validate()) {
      final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      sharedPreferences.setString('email', emailController.text);
      await SharedPreferences.getInstance();
      sharedPreferences.setString('password', passwordController.text);
      signIn(emailController.text,
          passwordController.text);
    } else {
      await Flushbar(
        padding: EdgeInsets.symmetric(
            vertical:
            MediaQuery.of(context).size.height /
                20),
        icon: Icon(
          Icons.error_outline,
          size: MediaQuery.of(context).size.width / 18,
          color: Colors.white,
        ),
        duration: Duration(seconds: 3),
        shouldIconPulse: false,
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.all(Radius.circular(
            MediaQuery.of(context).size.height / 37)),
        backgroundColor: Colors.grey.withOpacity(0.5),
        barBlur: 20,
        message:
        AppLocalizations.of(context)!.translate('Please Enter Username and Password'),
        messageSize: MediaQuery.of(context).size.width / 22,
      ).show(context);
    }
  }

  _signUp() {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => new Register(false)));
    // Navigator.of(context).pushNamed('main_screen');
  }
  void updateUserInfo(var id) async {
    print("flag1");
    print(id);
    var url = Uri.parse("$apiDomain/Main/Users/SignUp_Read?filter=Id~eq~'$id'");

    http.Response response = await http.get(url, headers: {"Authorization": token,});
    if (response.statusCode == 200) {
      print("flag2");
      userInfo = jsonDecode(response.body)['result']['Data'][0];
      editTransactionUserUserInfo(transactions![0], userInfo);
      print(jsonDecode(response.body));
      print("flag3");
    } else {
      print("flag4");
      print(response.statusCode);
    }
    print("flag5");
    //await Future.delayed(Duration(seconds: 1));
  }

  signIn(String email, String password) async {
    setState(() => chLogIn = true);
    //http.Response? response;
    var response = await APIService.login(email, password);
    // ignore: unnecessary_null_comparison
    if(response == null) {
      setState(() => chLogIn = false);
      return;
    }
      print("we're good");
      userData = response;
      //editTransactionUserData(transactions![0], userData);
      setState(() {
        // ignore: unrelated_type_equality_checks
        if (response.errorDes == "") {
          isLogIn = true;
          token = response.content!.token.toString();
          updateUserInfo(response.content!.id);
        } else {
          isLogIn = false;
          setState(() => chLogIn = false);
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
            message:response.errorDes,
            messageSize: MediaQuery.of(context).size.height / 37,
          ).show(context);
        }
      });
    if (isLogIn) {
      getServiceData();
    }
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('token', token);
  }

  _faceBookLogIn() async{
    try{
      FacebookAuth.instance.getUserData().then((userData111) async {
        setState(() {
          isLogIn = true;
          userobj = userData111;
          chLogIn = true;
        });
        //setState(()=>chLogIn =true);
        var password = "FB_P@ssw0rd_FB";
        var mobile;
        mobile = userobj["phone"] ??= '';
        Map mapDate = {
          "Name": userobj["name"].toString().split(' ')[0],
          "LastName": userobj["name"].toString().split(' ')[1],
          "Mobile": mobile,
          "Email": userobj["email"],
          "Password": password,
        };
        setState(() => chLogIn = false);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => new Register(true,mapDate: mapDate,)));
      });
    }catch(e){
      APIService.flushBar(e.toString());
    }

  }

  _googleLogIn() async{
   // FacebookAuth.instance.getUserData().then((userData) async {
    try{
      _googleSignIn.signIn().then((userData111) async{
        setState(() {
          isLogIn = true;
          userObjg = userData111!;
          chLogIn = true;
        });
        if (userObjg == null) {
          APIService.flushBar(AppLocalizations.of(context)!.translate("Sign in doesn't complete"));
          setState(() => chLogIn = false);
          return;
        }
        //setState(()=>chLogIn =true);
        var password = "GM_P@ssw0rd_GM";
        var mobile;
        mobile = '';
        Map mapDate = {
          "Name": userObjg!.displayName.toString().split(' ')[0],
          "LastName": userObjg!.displayName.toString().split(' ')[1],
          "Mobile": mobile,
          "Email": userObjg!.email,
          "Password": password,
        };
        setState(() => chLogIn = false);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => new Register(true,mapDate: mapDate,)));

        //setState(()=>chLogIn =false);
      });
    }catch(e){
      APIService.flushBar(e.toString());
    }

  }

  ver(value, code)async{
    var apiUrl = Uri.parse('$apiDomain/Main/SignUp/SignUp_Verify');
    Map mapDate = {
      "guidParam": value,
      "txtParam": code,
    };
    http.Response response = await http.post(apiUrl, body: jsonEncode(mapDate), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    });
    print(response.statusCode);
    print(response.body);

  }

  void _afterLayout(Duration timeStamp) {
    _read();
  }

  _read() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    emailController.text = sharedPreferences.getString('email')??'';
    passwordController.text = sharedPreferences.getString('password')??'';
  }

  void _forgetPasssword(email) async {
    http.Response response = await http.post(Uri.parse('$apiDomain/main/SignUp/RequestResetPassword?UserEmail=$email'),
        headers: {
          "accept": "application/json",
        });
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      print("we're good");
      //userData = jsonDecode(response.body);
      setState(() {
        if (jsonDecode(response.body)['Errors'] == "") {
          Navigator.of(context).push(MaterialPageRoute(
            builder:(context)=>Verification(value: 'value' ,email: emailController.text, password: '', ),
          ));
        }
        else if (jsonDecode(response.body)['data'] == "Wait one hour and retry"){
          Navigator.of(context).push(MaterialPageRoute(
            builder:(context)=>Verification(value: 'value' ,email: emailController.text, password: '', ),
          ));
        }
        else {
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
    }
    else {
      print('A network error occurred');
    }
  }


}
