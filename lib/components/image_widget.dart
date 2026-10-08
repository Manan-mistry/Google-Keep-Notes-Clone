import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class ImageWidget extends StatefulWidget {
  final String image;

  const ImageWidget({required this.image});

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  double? _imageHeight;
  double? _imageWidth;

  @override
  void initState() {
    super.initState();
    _loadImageDimensions();
  }

  Future<void> _loadImageDimensions() async {
    final imageFile = File(widget.image);
    final decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());

    setState(() {
      _imageWidth = decodedImage.width.toDouble();
      _imageHeight = decodedImage.height.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _imageHeight != null && _imageWidth != null
        ? FittedBox(
      fit: BoxFit.cover,
      child: Image.file(
        File(widget.image),
        width: _imageWidth,
        height: _imageHeight,
      ),
    )
        : CircularProgressIndicator(); // Loading indicator while image dimensions are fetched
  }
}
