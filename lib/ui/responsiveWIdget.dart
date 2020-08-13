import 'package:flutter/material.dart';
import 'package:ibdaa_app/ui/sizeInformation.dart';

class ResponsiveWIdget extends StatelessWidget {
  final AppBar appBar;
  final Widget Function(BuildContext context, SizeInformation constraints)
      builder;
  ResponsiveWIdget({this.builder, this.appBar});
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var orientation = MediaQuery.of(context).orientation;
    SizeInformation information = SizeInformation(height, width, orientation);
    return SafeArea(
        child: Scaffold(
            appBar: appBar,
            body: Builder(builder: (context) {
              return builder(context, information);
            })));
  }
}
