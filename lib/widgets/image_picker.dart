import 'package:MOOV/utils/themes_styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImagePick extends StatefulWidget {
  @override
  _ImagePickState createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  File imageFile;
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      imageFile = selected;
    });
  }

  void _clear() {
    setState(() => imageFile = null);
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'MOOV Cropper',
          toolbarColor: TextThemes.ndBlue,
          toolbarWidgetColor: Colors.white,
        ));

    setState(() {
      imageFile = cropped ?? imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              IconButton(
                icon: Icon(Icons.photo_library),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        ),
        body: ListView(
          children: <Widget>[
            if (imageFile != null) ...[
              Image.file(imageFile),
              Row(children: <Widget>[
                FlatButton(onPressed: _cropImage, child: Icon(Icons.crop)),
                FlatButton(onPressed: _clear, child: Icon(Icons.refresh)),
              ]),
              Uploader(file: imageFile)
            ]
          ],
        ));
  }
}

class Uploader extends StatefulWidget {
  final File file;
  Uploader({Key key, this.file}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://moov4-4d3c4.appspot.com');

  StorageUploadTask _uploadTask;

  void _startUpload() {
    String filePath = 'images/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(children: <Widget>[
              if (_uploadTask.isInProgress)
                LinearProgressIndicator(value: progressPercent),
              Text('${(progressPercent * 100).toStringAsFixed(2)} % ')
            ]);
          });
    } else {
      return FlatButton.icon(
          onPressed: _startUpload,
          icon: Icon(Icons.check),
          label: Text('Done'));
    }
  }
}
