import 'package:dualites/shared/widgets/da_raised_button_widget/da_raised_button_widget.dart';
import 'package:dualites/shared/widgets/media_select_widget/media_select_widget.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageUploadWidget extends StatefulWidget {
  Function callback;
  int numOfImages;
  File file;
  ImageUploadWidget({this.file,this.numOfImages = 1, this.callback});
  ImageUploadWidgetState createState() => ImageUploadWidgetState();
}

class ImageUploadWidgetState extends State<ImageUploadWidget> {
  Widget build(BuildContext context) {
    //_initializeExistingProductImages();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        //border: Border.all(color: Colors.grey.shade500),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: ImagesWidget2(image: widget.file,callback: (File file) {
          widget.callback(file);
        }),
      ),
    );
  }
}

class ImagesWidget2 extends StatelessWidget {
  Function callback;
  final File image;
  final String title;
  ImagesWidget2({this.image,this.callback, this.title = "Upload/Change Pic"});
  File imageFiles;
  Widget build(BuildContext context) {
    return
        Container(
            margin: const EdgeInsets.all(5.0),
            width: MediaQuery.of(context).size.width,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.grey.shade200),
                child: image!=null ?Center(
                  child: Image.file(image,width: MediaQuery.of(context).size.width*0.8,height:150),
                ):Center(
                  child: IconButton(
                      icon:
                          Icon(Icons.add_a_photo, color: Colors.grey.shade600),
                      onPressed: () => updatePicture(context)),
                )));
  }

  updatePicture(BuildContext context) async {
    bool selectedMediaVal = await showDialog(
        context: context,
        builder: (context) {
          return MediaSelectWidget(
            callback: (int selectedMediaVal) {
              Navigator.pop(context, selectedMediaVal == 0);
            },
            mediaText1: "Gallery",
            mediaText2: "Camera",
          );
        });
    var response = await pickImageFromGallery(
        selectedMediaVal ? ImageSource.gallery : ImageSource.camera);
    if (response is File) {
      imageFiles = response;
      callback(new File(imageFiles.path));
    }
  }

  Future<dynamic> pickImageFromGallery(ImageSource source,
      {bool isImage = true}) async {
    File filesFetched;
    if (isImage)
      filesFetched =
          await ImagePicker.pickImage(source: source, imageQuality: 30);
    if (filesFetched == null)
      return Future.value("");
    else
      return Future.value(filesFetched);
  }
}
