import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _outputs;
  File _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    String dateNow = date.toString().split(' ')[0];
    String time = date.toString().split(' ')[1].split('.')[0];
    return WillPopScope(
      onWillPop: () => _exitConfirm(),
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Color(0xffffe971),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/amas_homeBG.png',
            ),
          ),
          Visibility(
            visible: _image == null,
            child: Center(
              child: Image.asset('assets/images/amas_home.gif'),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              title: Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/images/amas_splash.gif',
                  height: 100.0,
                ),
              ),
              // Text(
              //   'AMAS',
              //   style: GoogleFonts.lobster(
              //     color: Colors.black,
              //     fontSize: 30.0,
              //   ),
              // ),
            ),
            body: _loading
                ? Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _image == null
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Material(
                                  color: Colors.transparent,
                                  elevation: 20.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                    child: Image.file(
                                      _image,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3,
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        _outputs != null
                            ? Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    color: Colors.blue,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Student Name: ${_outputs[0]["label"]}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        Text(
                                          '\nAttendance marked on',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Date: $dateNow',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        Text(
                                          'Time: $time',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Visibility(
                          visible: _image != null,
                          child: RaisedButton(
                            color: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            child: Text('Reset'),
                            onPressed: () {
                              setState(() {
                                _image = null;
                                _outputs = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color(0xff00c2cb),
              onPressed: _optionsDialogBox,
              child: Icon(
                Icons.camera,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      height: 45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Take a picture',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    onTap: openCamera,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    child: Container(
                      height: 45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Select from gallery',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    onTap: openGallery,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _exitConfirm() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Are you sure you want to exit?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 30.0,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.done,
                          color: Colors.green,
                          size: 30.0,
                        ),
                        onPressed: () => exit(1),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future openGallery() async {
    Navigator.of(context).pop();
    var image;
    image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _image = image;
    });
    classifyImage(image);
  }

  Future openCamera() async {
    Navigator.of(context).pop();
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      _image = image;
    });
    classifyImage(image);
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _outputs = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void dispose() async {
    await Tflite.close();
    super.dispose();
  }
}
