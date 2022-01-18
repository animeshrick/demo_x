
import 'dart:typed_data';
import 'package:dualites/modules/upload/getx/gallery_controller.dart';
import 'package:dualites/modules/upload/pages/videos_post/videos_post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetThumbnail extends StatelessWidget {
  AssetThumbnail({
    Key key,
    @required this.asset,
  }) : super(key: key);

  final AssetEntity asset;
  final GalleryController galleryController=Get.find();
  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List>(
      future: asset.thumbData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null) return CircularProgressIndicator();
        // If there's data, display it as an image
        return ThumbnailWidget(
          asset: asset,
          bytes: bytes
        );
      },
    );
  }
}

class ThumbnailWidget extends StatefulWidget{
  final AssetEntity asset;
  final Uint8List bytes;
  ThumbnailWidget({this.asset,this.bytes});
  ThumbnailWidgetState createState()=>ThumbnailWidgetState();
}
class ThumbnailWidgetState extends State<ThumbnailWidget>{
  final GalleryController galleryController=Get.find();
  bool isBorderNeeded=false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: (){
        setState(() {

        if (galleryController.selectedAssets.contains(widget.asset)) {
          galleryController.selectedAssets.remove(widget.asset);
          isBorderNeeded=false;
        }
        else if (galleryController.selectedAssets.length < 2) {
          /*if (galleryController.selectedAssets.isNotEmpty &&
              galleryController.selectedAssets[0].videoDuration != widget.asset.videoDuration) {
            Get.snackbar("Error", "Duration For Both videos has to be same",
                backgroundColor: Colors.red);
          } else {
            galleryController.selectedAssets.add(widget.asset);
            isBorderNeeded=true;
          }*/
          galleryController.selectedAssets.add(widget.asset);
          isBorderNeeded=true;
          if (galleryController.selectedAssets.length == 2) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => VideosPost()));
          }
        }

        });

      },
      onTap: () {
        galleryController.updateSelectedAssetEntity(widget.asset);

      },
      child: Stack(
        children: [
          // Wrap the image in a Positioned.fill to fill the space
          Positioned.fill(
            child: Container(decoration:BoxDecoration(
              border: isBorderNeeded? Border.all(color: Colors.blue):null,
              borderRadius: isBorderNeeded ?BorderRadius.circular(5.0):null
            ),child: Image.memory(widget.bytes, fit: BoxFit.cover)),
          )
        ],
      ),
    );
  }
}
