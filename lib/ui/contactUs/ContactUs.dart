import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  String mobile = '';
  String name = '';
  bool authState = false;

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _mobileController.addListener(_updateMobile);
    _nameController.addListener(_updateName);
    super.initState();
  }

  @override
  dispose() {
    _mobileController.removeListener(_updateMobile);
    _mobileController.dispose();
    _nameController.removeListener(_updateName());
    _nameController.dispose();
    super.dispose();
  }

  _updateMobile() => setState(() => mobile = _mobileController.text);
  _updateName() => setState(() => name = _nameController.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                controller: _nameController,
                onChanged: (String name) {
                  setState(() {
                    name = name;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.0)),
                    prefixIcon: Icon(Icons.lock),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
                    labelText: 'Name'),
                controller: _nameController,
                onChanged: (String name) {
                  setState(() {
                    name = name;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'mobile',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
                controller: _mobileController,
                onChanged: (String mobile) {
                  setState(() {
                    mobile = mobile;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
