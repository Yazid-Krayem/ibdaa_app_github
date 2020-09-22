import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibdaa_app/models/api.dart';
import 'package:link/link.dart';
import 'package:cooky/cooky.dart' as cookie;

import '../style.dart';

class MobileView extends StatefulWidget {
  const MobileView(
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
  _MobileViewState createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  String mobile = '';
  String name = '';
  String message = '';
  bool authState = false;

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

  _updateMobile() => setState(() => mobile = _mobileController.text);
  _updateName() => setState(() => name = _nameController.text);
  _message() => setState(() => message = _messageController.text);

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

  _addFeedback() async {
    var deviceId = cookie.get('id');
    await API.feedBackAdd(deviceId, name, mobile, message).then((response) {
      var result = jsonDecode(response.body);

      if (result['success']) {
        _restState();
        // print('ok');
      } else {
        // print('error');
      }
    });
  }

  Color onTapField = Colors.lightBlue[200];

  Color labelStyle = Colors.lightBlue[200];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    widget.tripleDescription.sort();
    widget.unviersitiesName.sort((a, b) => a.length.compareTo(b.length));

    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Wrap(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              // triple university container
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  // width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: new BorderRadius.circular(25.0),
                      border: Border.all(color: Colors.lightBlue, width: 8)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                          'المجالات الدراسية /المهن الملائمة',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      for (var item in widget.unviersitiesName)
                        Text(
                          '$item\n',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        )
                    ]),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),
              //triple_name

              Container(
                padding: EdgeInsets.all(20),
                // width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.white, width: 8)),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        'أنماط الميول المهنية',
                        strutStyle: StrutStyle(
                          fontSize: 18.0,
                          height: 1,
                        ),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 150,
                      child: Image.network(
                        '${widget.snapshot.data.tripleImage}',
                        // height: 120,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        for (var detail in widget.tripleDescription)
                          RichText(
                              strutStyle: StrutStyle(
                                fontSize: 12.0,
                                height: 1,
                              ),
                              textDirection: TextDirection.rtl,
                              text: TextSpan(
                                text: detail,
                                style: TextStyle(
                                  color: Colors.lightBlue,
                                ),
                              ))
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),

              // triple url
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: EdgeInsets.all(20),
                  // width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: new BorderRadius.circular(25.0),
                      border: Border.all(color: Colors.lightBlue, width: 8)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                        height: 10,
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
              SizedBox(
                height: 10,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.all(20),
                  // width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'اقتراحاتك قد تفيدنا في تحسين النتيجة',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                // width: MediaQuery.of(context).size.width / 2,
                                height: 50,
                                child: TextFormField(
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  keyboardType: TextInputType.number,
                                  enabled: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.topic,
                                        color: Colors.lightBlue),
                                    labelText: 'الاسم',
                                    hintText: 'اكتب اسمك',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[350]),
                                    labelStyle: TextStyle(color: labelStyle),
                                    enabled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.lightBlue, width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.lightBlue, width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
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
                                // width: MediaQuery.of(context).size.width / 2,
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
                                    hintStyle:
                                        TextStyle(color: Colors.grey[350]),
                                    // helperText: 'helper',
                                    labelStyle: TextStyle(color: labelStyle),
                                    enabled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.lightBlue, width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.lightBlue, width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
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
                                // width: MediaQuery.of(context).size.width / 2,
                                child: TextFormField(
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  strutStyle: StrutStyle(
                                    fontSize: 12.0,
                                    height: 1,
                                  ),
                                  maxLines: 4,
                                  enabled: true,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.message, color: onTapField),
                                    labelText: 'رسالة',
                                    hintText: 'اكتب رسالتك',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[350]),
                                    // helperText: 'helper',
                                    labelStyle: TextStyle(color: labelStyle),
                                    enabled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.lightBlue, width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.lightBlue, width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
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
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: RaisedButton.icon(
                                  shape: buttonStyle,
                                  textColor: Colors.white,
                                  color: Colors.lightBlue,
                                  onPressed: () async {
                                    if (name == '' &&
                                        mobile == '' &&
                                        message == '') {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('يجب تعبئة الحقول '),
                                        backgroundColor: Colors.red,
                                      ));
                                    } else {
                                      await _addFeedback();
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(' تقييمك ارسل بنجاح'),
                                        backgroundColor: Colors.lightBlue,
                                      ));
                                    }
                                  },
                                  label: Text('تقييم'),
                                  icon: Icon(Icons.feedback),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
