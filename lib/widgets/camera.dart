import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomCamera {
  static Future<dynamic> openCamera({bool getBase64 = true}) async {
    final image =
        File((await ImagePicker().getImage(source: ImageSource.camera)).path);

    if (getBase64 == false) {
      List<int> base64Byte = image.readAsBytesSync();
      String base64Encoded = base64Encode(base64Byte);

      final imageBase64 = base64.decode(base64Encoded.toString());

      print('base64 -> $imageBase64');

      return imageBase64;
    }

    return image;
  }

  static Future<dynamic> openGallery({bool getBase64 = true}) async {
    // ignore: deprecated_member_use
    final image =
        File((await ImagePicker().getImage(source: ImageSource.gallery)).path);

    if (getBase64 == false) {
      List<int> base64Byte = image.readAsBytesSync();
      String base64Encoded = base64Encode(base64Byte);

      final imageBase64 = base64.decode(base64Encoded.toString());

      print('base64 -> $imageBase64');

      return imageBase64;
    }

    return image;
  }
}
