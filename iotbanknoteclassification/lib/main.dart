import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iotbanknoteclassification/utils/size_helpers.dart';
import 'package:iotbanknoteclassification/widgets/rounded_button_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank Note Classifier',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _selectedFile;
  bool _inProcess = false;
  String result = '';

  final picker = ImagePicker();

  Widget getImageWidget() {
    if (_selectedFile != null) {
      return Image.file(
        _selectedFile,
        width: 250,
        height: 250,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        "assets/placeholder.jpg",
        width: 250,
        height: 250,
        fit: BoxFit.cover,
      );
    }
  }

  Future getImage(ImageSource source) async {
    this.setState(() {
      _inProcess = true;
    });

    final pickedFile = await picker.getImage(
      source: source,
      imageQuality: 15,
    );

    if (pickedFile != null) {
      this.setState(() {
        _selectedFile = File(pickedFile.path);
        _inProcess = false;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }
  }

  void submitImage() async {
    List<int> imageBytes = _selectedFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    String url =
        'http://302246c6-065b-4a25-8cf8-8e70627924aa.southeastasia.azurecontainer.io/score';

    print("Sending POST Request");
    this.setState(() {
      _inProcess = true;
    });

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'image_data': base64Image,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final parsedJSON = json.decode(response.body);

    print(parsedJSON);

    switch (parsedJSON) {
      case 'two_dollar':
        result = "Result is Two Dollar SGD";
        break;
      case 'five_dollar':
        result = "Result is Five Dollar SGD";
        break;
      case 'ten_dollar':
        result = "Result is Ten Dollar SGD";
        break;
      case 'fifty_dollar':
        result = "Result is Fifty Dollar SGD";
        break;
      default:
        result = "Unknown";
    }

    this.setState(() {
      _inProcess = false;
      _showMyDialog();
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Classification Result'),
          content: SingleChildScrollView(
            child: Text(result),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _inProcess
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: Column(
                  children: [
                    Spacer(),
                    Expanded(
                      flex: 4,
                      child: getImageWidget(),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RoundedButton(
                          btnText: "Camera",
                          btnColor: Colors.green,
                          btnFunction: () {
                            getImage(ImageSource.camera);
                          },
                          width: displayWidth(context) * 0.3,
                        ),
                        RoundedButton(
                          btnText: "Device",
                          btnColor: Colors.deepOrange,
                          btnFunction: () {
                            getImage(ImageSource.gallery);
                          },
                          width: displayWidth(context) * 0.3,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: displayWidth(context) * 0.05,
                    ),
                    RoundedButton(
                      btnText: "Submit",
                      btnColor: Colors.orange[700],
                      btnFunction: submitImage,
                      width: double.infinity,
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
    );
  }
}
