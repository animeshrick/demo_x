import 'dart:io';
import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:dualites/modules/upload/getx/gallery_provider.dart';
import 'package:dualites/modules/upload/getx/gallery_state.dart';
import 'package:dualites/modules/upload/pages/videos_post/videos_post.dart';
import 'package:dualites/modules/widgets/widgets.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';

class GalleryController extends GetxController {
  List<AssetEntity> galleryAssets = [];
  List<AssetEntity> selectedAssets = [];
  Map<int, File> resizedFiles = {};
  Rx<File> selectedAssetEntity = File("").obs;
  String errorMessage;
  bool isLoading = true;
  GalleryProvider galleryProvider;

  VideoPlayerController _controller;

  VideoPlayerController get controller => _controller;

  set controller(VideoPlayerController value) {
    _controller = value;
  }

  GalleryController(this.galleryProvider);

  final _postVideoStream = GalleryState().obs;

  GalleryState get state => _postVideoStream.value;
  TextEditingController titleController = TextEditingController(text: "");
  TextEditingController descriptionController = TextEditingController(text: "");
  TextEditingController typeController = TextEditingController(text: "");
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<String> createDeepLink(int videoId) async {
    _postVideoStream.value = VideoDeepLinkCreationErrorState();
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://dualite.page.link',
        link: Uri.parse('https://dualite.page.link/video?id=$videoId'),
        androidParameters: AndroidParameters(
          packageName: 'com.example.dualites',
        ),
        iosParameters: IosParameters(bundleId: ""),
        // NOT ALL ARE REQUIRED ===== HERE AS AN EXAMPLE =====
        googleAnalyticsParameters: GoogleAnalyticsParameters(
            source: 'social_network',
            campaign: "social",
            medium: "social network"),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Enroll As An Affiliate',
          description: 'And Earn cash',
        ),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
            shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
        navigationInfoParameters:
        NavigationInfoParameters(forcedRedirectEnabled: false));

    final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
    return dynamicUrl.shortUrl.toString();
    /*_postVideoStream.value =
        VideoDeepLinkCreationSuccessState(deepLinkUrl: dynamicUrl.toString());
    Get.snackbar("Success", "Deeplink is Created",
        backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);*/
  }

  @override
  void onInit() async {
    _postVideoStream.value = GalleryState();
    galleryAssets = await galleryProvider.loadGalleryAssets();
    if (galleryAssets.isNotEmpty) {
      galleryAssets.first.file.then((value) {
        selectedAssetEntity.value = value;
      });
    } else {
      errorMessage = "No Videos Found";
    }
    isLoading = false;
    update();
    super.onInit();
  }

  updateSelectedAssetEntity(AssetEntity assetEntity) {
    assetEntity.file.then((value) {
      selectedAssetEntity.value = value;
    });
  }

  initVideo(File file) async {
    _controller = VideoPlayerController.file(file)
    // Play the video again when it ends
      ..setLooping(true)
    // initialize the controller and notify UI when done
      ..initialize().then((_) {});
  }

  addSelectedAssetEntity(AssetEntity assetEntity, BuildContext context) {
    assetEntity.file.then((value) {
      if (selectedAssets.contains(assetEntity))
        selectedAssets.remove(assetEntity);
      else if (selectedAssets.length < 2) {
        if (selectedAssets.isNotEmpty &&
            selectedAssets[0].videoDuration == assetEntity.videoDuration) {
          Get.snackbar("Error", "Duration For Both videos has to be same",
              backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
        } else {
          selectedAssets.add(assetEntity);
        }
        if (selectedAssets.length == 2) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => VideosPost()));
        }
      }
    });
  }

  postVideoContent(File thumbnailImage, String tags,
      BuildContext context) async {
    if (formKey.currentState.validate()) {
      _postVideoStream.value = PostVideoLoadingState();
      Get.snackbar("Saving..", "Please wait.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
      List<File> files = [];
      if (resizedFiles.values.length == 2) {
        files = resizedFiles.values.toList();
      } else {
        for (AssetEntity entity in selectedAssets) {
          File file = await entity.file;
          files.add(file);
        }
        Map<bool, String> mediaId = await galleryProvider.postThumbnailFile(
            "https://dualite.xyz/api/v1/uploads/", thumbnailImage);
        if (mediaId.containsKey(true)) {
          dynamic response = await galleryProvider.postVideoContent(
              "https://dualite.xyz/api/v1/videos/",
              titleController.text,
              descriptionController.text,
              typeController.text,
              tags,
              mediaId[true]);
          if (response is VideoModel) {
            String firstUrl = (response as VideoModel).contentOne;
            String secondUrl = (response as VideoModel).contentTwo;
            if (response is VideoModel) {
              var count = 0;
              for (var i = 0; i < 2; i++) {
                dynamic fileUploadResponse = await galleryProvider
                    .postVideoFiles(
                    i == 0 ? firstUrl : secondUrl, files[i]);
                if (fileUploadResponse is String) {
                  Get.snackbar("Error", (fileUploadResponse),
                      backgroundColor: Colors.red, colorText: Colors.white);
                  _postVideoStream.value =
                      PostVideoErrorState(message: fileUploadResponse);
                  break;
                } else
                  count++;
              }
              if (count == 2) {
                Get.snackbar(
                    "Success", "Your Video is Uploaded.. Creating Deeplink",
                    backgroundColor: Colors.green,
                    snackPosition: SnackPosition.BOTTOM);
                VideoModel videoModel = response;
                String deepLink = await createDeepLink(videoModel.id);
                Get.defaultDialog(
                    title: "Share Link",
                    content: Container(
                      height: Get.height * 0.3,
                      width: Get.width * 0.8,
                      child: Center(
                        child: Text(deepLink),
                      ),
                    ),
                    actions: [
                      OutlineButton(onPressed: () => Navigator.pop(context),
                        child: Center(child: Text("Cancel"),),),
                      RaisedButton(onPressed: () {
                        Share.share(deepLink);
                      }, child: Center(child: Text("Share"),),)
                    ]
                );
              }
            }
          } else {
            Get.snackbar("Error", (response),
                backgroundColor: Colors.red, colorText: Colors.white);
            _postVideoStream.value = PostVideoErrorState(message: response);
          }
        } else {
          Get.snackbar("Error", (mediaId[false]),
              backgroundColor: Colors.red, colorText: Colors.white);
          _postVideoStream.value = PostVideoErrorState(message: mediaId[false]);
        }
      }
    }
  }
}