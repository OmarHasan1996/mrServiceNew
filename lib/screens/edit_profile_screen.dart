import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:closer/constant/apiUrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/localizations.dart';
import 'package:path_provider/path_provider.dart';

import '../MyWidget.dart';
import '../const.dart';
import 'main_screen.dart';

List service = [];

// ignore: must_be_immutable
class EditProfileScreen extends StatefulWidget {
  String token;

  EditProfileScreen({
    required this.token,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState(this.token);
}

class _EditProfileScreenState extends State<EditProfileScreen> {

//
  ImageProvider? image = null;
  String? lng;
  String token;
  String? path ;
  TextEditingController nameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController mailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  _EditProfileScreenState(
    this.token,
  );

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback(_localPath);
    updateUserInfo(userData!.content!.id);
    super.initState();
    // print(subservice);

   }

   _changeProfile()async  {
  final ImagePicker _picker = ImagePicker();
  final XFile? xFile = await _picker.pickImage(source: ImageSource.gallery);
  path = xFile!.path;
  print(path);
  setState(
  () {
  image = FileImage(File(path!));
  },
  );
/*final bytes = await XFile(path).readAsBytes();
                          final img.Image image = img.decodeImage(bytes);*/
}

  @override
  Widget build(BuildContext context) {
    var barHight = MediaQuery.of(context).size.height / 5.7;
    //getServiceData();
    //checkSave = false;

    return SafeArea(
        child: Scaffold(
          appBar: MyWidget.appBar(title: ''),
          backgroundColor: Colors.grey[100],
          body: Column(
            children: [
              MyWidget.topYellowDriver(),
              SizedBox(
                height: MediaQuery.of(context).size.height / 80,
              ),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.24,
                        width: MediaQuery.of(context).size.width * 0.50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: image == null ? (userInfo['ImagePath'] == 'https://mr-service.online/ProfilesFiles/${userInfo["Id"]} ' ? AssetImage('assets/images/profile.jpg') as ImageProvider
                                    : NetworkImage(userInfo['ImagePath'])) : image as ImageProvider,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset:
                                  Offset(0, 1), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        //child: Text(),
                      ),
                      // ignore: deprecated_member_use
                      MyWidget(context).raisedButton(AppLocalizations.of(context)!.translate('Change profile Photo'), ()=>  _changeProfile(), MediaQuery.of(context).size.width /1.7, false, buttonText: AppColors.mainColor, colorText: AppColors.white, padV: 0.1, textH: min(MediaQuery.of(context).size.width/25, MediaQuery.of(context).size.height / 56)),
                      /*RaisedButton(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.height / 12),
                        ),
                        color: MyColors.blue,
                        child: Text(
                          AppLocalizations.of(context)!.translate('Change profile Photo'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
        fontFamily: 'comfortaa',
                            fontSize: MediaQuery.of(context).size.width / 25,
                            color: MyColors.White,
                          ),
                        ),
                        onPressed: () async {
                          final ImagePicker _picker = ImagePicker();
                          final XFile? xFile = await _picker.pickImage(source: ImageSource.gallery);
                          path = xFile!.path;
                          print(path);
                          setState(
                            () {
                              image = FileImage(File(path!));
                            },
                          );
                          /*final bytes = await XFile(path).readAsBytes();
                          final img.Image image = img.decodeImage(bytes);*/
                        },
                      ),*/
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        //child: Text(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 160,
                            horizontal: MediaQuery.of(context).size.width / 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyWidget(context).textBlack20(AppLocalizations.of(context)!.translate("First Name") + ":", scale: 0.8),

                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height / 200,
                              ),
                              child: Container(
                                //height: MediaQuery.of(context).size.height/40,
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextFormField(
                                  textAlign: TextAlign.end,
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                  controller: nameController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  style: TextStyle(
        fontFamily: 'comfortaa',
                                      color: AppColors.black,
                                      fontSize: min(MediaQuery.of(context).size.width / 20, MediaQuery.of(context).size.height / 45)),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '${userInfo["Name"]}',
                                    hintStyle: TextStyle(
        fontFamily: 'comfortaa',
                                        color: Colors.grey,
                                        fontSize: min(MediaQuery.of(context).size.width / 20, MediaQuery.of(context).size.height / 45)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 160,
                            horizontal: MediaQuery.of(context).size.width / 10),
                        child: Divider(
                          height: 1,
                          thickness: 2,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 160,
                            horizontal: MediaQuery.of(context).size.width / 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyWidget(context).textBlack20(AppLocalizations.of(context)!.translate("Last Name") + ":", scale: 0.8),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height / 200,
                              ),
                              child: Container(
                                //height: MediaQuery.of(context).size.height/40,
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextFormField(
                                  textAlign: TextAlign.end,
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                  controller: lastNameController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  style: TextStyle(
        fontFamily: 'comfortaa',
                                      color: AppColors.black,
                                      fontSize: min(MediaQuery.of(context).size.width / 20, MediaQuery.of(context).size.width / 45)),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '${userInfo["LastName"]}',
                                    hintStyle: TextStyle(
        fontFamily: 'comfortaa',
                                        color: Colors.grey,
                                        fontSize: min(MediaQuery.of(context).size.width / 20, MediaQuery.of(context).size.height / 45)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 160,
                            horizontal: MediaQuery.of(context).size.width / 10),
                        child: Divider(
                          height: 1,
                          thickness: 2,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 160,
                            horizontal: MediaQuery.of(context).size.width / 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyWidget(context).textBlack20(AppLocalizations.of(context)!.translate("E-Mail:"), scale: 0.8),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height / 200,
                              ),
                              child: Container(
                                child: MyWidget(context).textTap25('${userInfo["Email"]}', color: AppColors.black)
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 160,
                            horizontal: MediaQuery.of(context).size.width / 10),
                        child: Divider(
                          height: 1,
                          thickness: 2,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 160,
                            horizontal: MediaQuery.of(context).size.width / 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyWidget(context).textBlack20(AppLocalizations.of(context)!.translate("Phone:"), scale: 0.8),

                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height / 200,
                              ),
                              child: MyWidget(context).textTap25('${userInfo['Mobile']}', color: AppColors.black)
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 160,
                            horizontal: MediaQuery.of(context).size.width / 10),
                        child: Divider(
                          height: 1,
                          thickness: 2,
                          color: Colors.grey[400],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 30,
                            horizontal: MediaQuery.of(context).size.width / 10),
                        alignment: Alignment.bottomRight,
                        // ignore: deprecated_member_use
                        child: MyWidget(context).raisedButton(AppLocalizations.of(context)!.translate('Save'), ()async=> {
                          await getServiceData(),
                          await updateProfile(),
                        }, MediaQuery.of(context).size.width/1.5, checkSave),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  bool checkSave = false;
  _localPath(Duration timeStamp) async {
  final directory = await getApplicationDocumentsDirectory();
  ///data/user/0/com.mr_service/cache/image_picker3183086957643510790.jpg
   try{
    this.path = directory.path.replaceAll('app_flutter', 'cache') + userInfo['ImagePath'].toString().createPath().split(' ')[1].createPath();
    print(path);
   } catch(e){

   }
  }


  Future getServiceData() async {
    setState(() {
      checkSave = true;
    });
    var url = Uri.parse('${ApiUrl.mainServiceRead}cityid=$cityId&filter=Service.IsMain~eq~true');
    http.Response response = await http.get(url, headers: {"Authorization": token,},);
    if (response.statusCode == 200) {
      var item = json.decode(response.body)["result"]['Data'];
      setState(() {
        service.clear();// = item;
        for(var e in item){
          service.add(e['Service']);
        }
        },);
    } else {
      setState(
            () {
          service = [];
        },
      );
    }
    setState(() {
      checkSave = false;
    });
  }

  Future updateProfile() async {
    setState(() {
      checkSave = true;
    });
    var apiUrl = Uri.parse('$apiDomain/Main/Users/SignUp_UpdateInfo?');
    var request = http.MultipartRequest('POST', apiUrl);
    request.fields['Id'] = userData!.content!.id;
    if (nameController.text == "")
      request.fields['Name'] = userInfo["Name"];
    else
      request.fields['Name'] = nameController.text;
    if (lastNameController.text == "")
      request.fields['LastName'] = userInfo["LastName"];
    else
      request.fields['LastName'] = lastNameController.text;
    if (phoneController.text == "")
      request.fields['Mobile'] = userInfo["Mobile"];
    else
      request.fields['Mobile'] = phoneController.text;
    request.fields['Email'] = userInfo["Email"];
    request.fields['Password'] = userInfo["Password"];
    request.fields['Type'] = userInfo["Type"].toString();
    print(this.path);
    if (this.path != "") {
      print("############################");
      try{
        request.files.add(await http.MultipartFile.fromPath('File', this.path as String),);
      }catch(e){
        print(e.toString());
      }
      print(this.path);
    }
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-type": "multipart/form-data",
      "Authorization": token,
    };
    request.headers.addAll(headers);

    var response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      updateUserInfo(userData!.content!.id);
      print('success');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(token: token, service: service, selectedIndex: 2, initialOrderTab: 0,)),
            (Route<dynamic> route) => false,
      );
    } else {
      print(response.statusCode);
      print('fail');
    }
    setState(() {
      checkSave = false;
    });

  }

  void updateUserInfo(var id) async {
    var url = Uri.parse("$apiDomain/Main/Users/SignUp_Read?filter=Id~eq~'$id'");

    http.Response response = await http.get(
      url,
      headers: {
        "Authorization": token,
      },
    );
    if (response.statusCode == 200) {
      userInfo = jsonDecode(response.body)['result']['Data'][0];
      editTransactionUserUserInfo(transactions![0], userInfo);
    } else {
      print(response.statusCode);
    }
  }

  //Image.network
  ////////////////////////////
}
