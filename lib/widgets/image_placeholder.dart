import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePlaceholder {
  static Future<dynamic> addPlaceholder(String typeDropdownValue) async {
    Random random = new Random();
    int randomNumber = random.nextInt(4);
    randomNumber += 1;
    dynamic placeholder;
    if (typeDropdownValue == 'Parties') {
      placeholder = 'placeholderparty' + randomNumber.toString() + '.jpg';
    } else if (typeDropdownValue == 'Bars') {
      placeholder = 'placeholderbar' + randomNumber.toString() + '.jpg';
    } else if (typeDropdownValue == 'Food/Drink') {
      placeholder = 'placeholderfood' + randomNumber.toString() + '.jpg';
    } else {
      placeholder = 'random.jpg';
    }

    return Image.asset(placeholder) as File;
  }
}
