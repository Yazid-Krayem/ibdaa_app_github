import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ibdaa_app/models/api.dart';
import 'package:link/link.dart';
import 'package:cooky/cooky.dart' as cookie;

import '../style.dart';

class WebView extends StatefulWidget {
  const WebView(
      {Key key,
      @required this.tripleUrl,
      @required this.unviersitiesName,
      @required this.tripleDescription,
      @required this.snapshot})
      : super(key: key);

  final List tripleUrl;
  final List unviersitiesName;
  final List tripleDescription;
  final snapshot;

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  String mobile = '';
  String name = '';
  String message = '';

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    _mobileController.addListener(_updateMobile);
    _nameController.addListener(_updateName);
    _messageController.addListener(_message);
    super.initState();
  }

  @override
  dispose() {
    _mobileController.removeListener(_updateMobile);
    _mobileController.dispose();
    _nameController.removeListener(_updateName());
    _nameController.dispose();
    _messageController.removeListener(_message());
    _messageController.dispose();
    super.dispose();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(' تقييمك ارسل بنجاح',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.lightBlue,
              )),
        );
      },
    );
  }

  _restState() {
    setState(() {
      name = '';
      mobile = '';
      message = '';
      _nameController.text = '';
      _mobileController.text = '';
      _messageController.text = '';
    });

    _nameController.clear();
    _mobileController.clear();
    _messageController.clear();
  }

  _updateMobile() => setState(() => mobile = _mobileController.text);
  _updateName() => setState(() => name = _nameController.text);
  _message() => setState(() => message = _messageController.text);

  _addFeedback() async {
    var deviceId = cookie.get('id');
    await API.feedBackAdd(deviceId, name, mobile, message).then((response) {
      var result = jsonDecode(response.body);

      if (result['success']) {
        _restState();

        // _showDialog();

        // print('ok');
      } else {
        // print('error');
      }
    });
  }

  Color labelStyle = Colors.lightBlue[200];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    widget.tripleDescription.sort();
    widget.unviersitiesName.sort((a, b) => a.length.compareTo(b.length));
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            // triple university container
            Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width / 3.5,
                decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: new BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.lightBlue, width: 8)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(shrinkWrap: true, children: [
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        'المجالات الدراسية /المهن الملائمة',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    for (var item in widget.unviersitiesName)
                      ListTile(
                          title: Text(
                        '$item\n',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ))
                  ]),
                )),

            Center(
              child: Icon(
                Icons.arrow_back,
                size: 60,
                color: Colors.lightBlue,
              ),
            ),

            //triple_name
            Container(
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width / 3.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.lightBlue, width: 8)),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        'أنماط الميول المهنية',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Image.network(
                      '${widget.snapshot.data.tripleImage}',
                      height: 220,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            for (var detail in widget.tripleDescription)
                              Text(
                                detail,
                                strutStyle: StrutStyle(
                                  fontSize: 18.0,
                                  height: 1,
                                ),
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  color: Colors.lightBlue,
                                ),
                              )
                          ],
                        ))
                  ],
                )),
            Center(
              child: Icon(
                Icons.arrow_back,
                size: 60,
                color: Colors.lightBlue,
              ),
            ),

            // triple url
            Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width / 3.5,
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: new BorderRadius.circular(25.0),
                  border: Border.all(color: Colors.lightBlue, width: 8)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'مقالات تعريفية',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    for (var items in widget.tripleUrl)
                      if (items.contains('لا'))
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: "$items\n\n\n",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              )
                            ]))
                      else
                        Link(
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                  text: "$items\n\n\n",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                )
                              ])),

                          url: items,
                          // onError: _showErrorSnackBar,
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width / 3.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  'اقتراحاتك قد تفيدنا في تحسين النتيجة',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 50,
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          autofocus: true,
                          // textDirection: TextDirection.rtl,
                          keyboardType: TextInputType.number,
                          enabled: true,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            prefixIcon: Icon(
                              Icons.topic,
                              color: Colors.lightBlue,
                            ),
                            labelText: 'الاسم',
                            hintText: 'اكتب اسمك',
                            hintStyle: TextStyle(color: Colors.grey[350]),
                            labelStyle: TextStyle(color: labelStyle),
                            enabled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.lightBlue, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.lightBlue, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                          ),
                          controller: _nameController,
                          onChanged: (String name) {
                            setState(() {
                              name = name;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 50,
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          enabled: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mobile_friendly,
                                color: Colors.lightBlue),
                            labelText: ' رقم الهاتف او الايميل',
                            hintText: 'اكتب رقم هاتفك او الايميل',
                            hintStyle: TextStyle(color: Colors.grey[350]),
                            // helperText: 'helper',
                            labelStyle: TextStyle(color: labelStyle),
                            enabled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.lightBlue, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.lightBlue, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                          ),
                          controller: _mobileController,
                          onChanged: (String mobile) {
                            setState(() {
                              mobile = mobile;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          cursorColor: Colors.lightBlue,
                          maxLines: 4,
                          enabled: true,
                          decoration: InputDecoration(
                            prefixIcon:
                                Icon(Icons.message, color: Colors.lightBlue),
                            labelText: 'رسالة',
                            hintText: 'اكتب رسالتك',
                            hintStyle: TextStyle(color: Colors.grey[350]),
                            // helperText: 'helper',
                            labelStyle: TextStyle(color: labelStyle),
                            enabled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.lightBlue, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.lightBlue, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                          ),
                          controller: _messageController,
                          onChanged: (String message) {
                            setState(() {
                              message = message;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton.icon(
                        shape: buttonStyle,
                        textColor: Colors.white,
                        color: Colors.lightBlue,
                        onPressed: () async {
                          if (name == '' && mobile == '' && message == '') {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('يجب تعبئة الحقول '),
                              backgroundColor: Colors.red,
                            ));
                          } else {
                            await _addFeedback();
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(' تقييمك ارسل بنجاح'),
                              backgroundColor: Colors.lightBlue,
                            ));
                          }
                        },
                        label: Text('تقييم'),
                        icon: Icon(Icons.feedback),
                      ),
                    ],
                  ))
            ],
          ),
        )
      ]),
    );
  }
}
