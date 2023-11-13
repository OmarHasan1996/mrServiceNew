import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

import 'package:closer/const.dart';

class UploadAttachment extends StatefulWidget {
  @override
  _UploadAttachmentState createState() => _UploadAttachmentState();
}

class _UploadAttachmentState extends State<UploadAttachment> {
  late File selectedfile;
  late Response response;
  late String progress;
  Dio dio = new Dio();
  FilePickerResult? result;
  PlatformFile? file; String fileType = 'All';

/*
  selectFile() async {
    selectedfile = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4'],
      //allowed extension to choose
    );

    //for file_pocker plugin version 2 or 2+
    /*
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4'],
      //allowed extension to choose
    );

    if (result != null) {
      //if there is selected file
      selectedfile = File(result.files.single.path);
    } */

    setState((){}); //update the UI so that file name is shown
  }
 */

  void pickFiles(fileTyp) async {
    switch (fileType) {
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
    }
    print(file!.name);
    print(file!.bytes);
    print(file!.size);
    print(file!.extension);
    print(file!.path);
    setState((){}); //update the UI so that file name is shown

  }

  uploadFile() async {
    String uploadurl = "$apiDomain/Main/Orders/Orders_CreateWithAttachs?";
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP
    dio.options.baseUrl = uploadurl;
    dio.options.connectTimeout = const Duration(seconds: 50); //50s
    dio.options.receiveTimeout = const Duration(seconds: 50);
    dio.options.headers = {
      "Accept": "application/json",
      "content-type": "application/json",
    };
    var amount = 0.0;
    List<Map<String, dynamic>> serviceTmp = [];
    for (int i = 0; i < order.length; i++) {
      amount += (order[i][0][0]['Price']) * int.parse(order[i][1]);
      serviceTmp.add({
        "ServiceId": order[i][0][0]['Id'],
        "Price": order[i][0][0]['Price'],
        "Quantity": int.parse(order[i][1]),
        "File": await MultipartFile.fromFile(order[i][0][0]['Service']['File'].path.toString(), filename: basename(order[i][0][0]['Service']['File'].name.toString()),),
        /*"Notes": "string",*/
      });
    }

    if(response.statusCode == 200){
      print(response.toString());
      //print response from server
    }else{
      print("Error during connection to server.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:Text("Select File and Upload"),
          backgroundColor: Colors.orangeAccent,
        ), //set appbar
        body:Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(40),
            child:Column(children: <Widget>[

              Container(
                margin: EdgeInsets.all(10),
                //show file name here
                child:progress == null?
                Text("Progress: 0%"):
                Text(basename("Progress: $progress"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
        fontFamily: 'comfortaa',fontSize: 18),),
                //show progress status here
              ),

              Container(
                margin: EdgeInsets.all(10),
                //show file name here
                child:selectedfile == null?
                Text("Choose File"):
                Text(basename(selectedfile.path)),
                //basename is from path package, to get filename from path
                //check if file is selected, if yes then show file name
              ),

              Container(
                  child:ElevatedButton.icon(
                    onPressed: (){
                      pickFiles(fileType);
                    },
                    icon: Icon(Icons.folder_open),
                    label: Text("CHOOSE FILE"),
                    style: ElevatedButton.styleFrom(
                      //color: MyColors.yellow,
                      primary: Colors.redAccent,
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: 0.1),
                      /*shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              roundBorder)),*/
                    ),
                   // color: Colors.redAccent,
                   // colorBrightness: Brightness.dark,
                  )
              ),

              //if selectedfile is null then show empty container
              //if file is selected then show upload button
              selectedfile == null? Container():
              Container(
                  child:ElevatedButton.icon(
                    onPressed: (){
                      uploadFile();
                    },
                    icon: Icon(Icons.folder_open),
                    label: Text("UPLOAD FILE"),
                    style: ElevatedButton.styleFrom(
                      //color: MyColors.yellow,
                      primary: Colors.redAccent,
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10, vertical: 0.0),
                      /*shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context!).size.height / 12)),*/
                    ),
                    //color: Colors.redAccent,
                    //colorBrightness: Brightness.dark,
                  )
              )

            ],)
        )
    );
  }
}