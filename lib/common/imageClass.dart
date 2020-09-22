import 'package:flutter/material.dart';

class ImageWidgetPlaceholder extends StatelessWidget {
  const ImageWidgetPlaceholder({
    Key key,
    @required this.image,
    this.placeholder,
    this.width,
    this.height,
  }) : super(key: key);

  final width;
  final height;
  final ImageProvider image;
  final Widget placeholder;
  @override
  Widget build(BuildContext context) {
    return Image(
      width: width,
      height: height,
      image: image,
      fit: BoxFit.fill,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        } else {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: frame != null ? child : placeholder,
          );
        }
      },
    );
  }
}
