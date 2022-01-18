import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:dualites/modules/reels/getx/reels_list_provider.dart';
import 'package:dualites/modules/reels/getx/state/reel_load_state.dart';
import 'package:dualites/modules/reels/models/video_controller_model.dart';
import 'package:dualites/shared/controller/video_list_provider.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ReelsListController extends GetxController{
  RxList<VideoModel> videosList = RxList<VideoModel>();
  RxList<VideoControllerModel> videosControllers = RxList<VideoControllerModel>();
  bool isLoading = true;
  String errorMessage;
  int currentIndexPlaying=0;
  String nextUrl='https://dualite.xyz/api/v1/videos';
  ReelsListProvider reelsListProvider;
  ReelsListController({this.reelsListProvider});
  final _reelsStateStream = ReelsLoadState().obs;
  VideoModel videoModelToBePlayed;
  ReelsLoadState get state => _reelsStateStream.value;
  Rx<VideoPlayerController> videoPlayerController=Rx<VideoPlayerController>();
  initializeState(){
    _reelsStateStream.value=ReelsLoadState();
  }
  @override
  void onInit() {
    _getNextVideosList();
    super.onInit();
  }

  _getNextVideosList(){
    isLoading=true;
    VideoListProvider().getVideosList(
      nextUrl,
      onSuccess: (posts)async {
        videosList.addAll(posts.results);
        nextUrl=posts.next;
        isLoading=false;
        if(posts.results.isEmpty){
          //_reelsStateStream.value=ReelsLoaded(isReelsLoaded: true);
          videoModelToBePlayed=null;
          update();
        }
        else {
          //_reelsStateStream.value=ReelsLoaded(isReelsLoaded: true);
          videoModelToBePlayed= posts.results[currentIndexPlaying++];
          videosList.value.addAll(posts.results);
          isLoading=false;
          /*for(VideoModel model in posts.results) {
            VideoPlayerController controller1 = model.contentOne == null ?
            VideoPlayerController.asset("assets/vod.mp4") :
            VideoPlayerController.network("https://d10jxtk2y1dsq0.cloudfront.net/dualite_1.m3u8");
            await controller1.initialize();
            controller1.play();
            controller1.setLooping(true);
            VideoPlayerController controller2 = model.contentTwo == null ?
            VideoPlayerController.asset("assets/vod.mp4") :
            VideoPlayerController.network("https://d10jxtk2y1dsq0.cloudfront.net/dualite_2.m3u8");
            controller2.setVolume(0.0);
            await controller2.initialize();
            videosControllers.add(VideoControllerModel(
                  active: 1,
                  controller1: controller1,
                  controller2: controller2
              ));


          }*/
          update();
        }

      },
      onError: (error) {
        _reelsStateStream.value=ReelInfoLoadingError(error: error);
        errorMessage=error.toString();
        isLoading=false;
        update();
      },
    );
  }

  playNextVideo(int index){
    if(videosList.length-index>1 && videosList.length-index<3){
      videoModelToBePlayed = videosList[index];
      currentIndexPlaying=index;
      //update();
      isLoading=true;
      update();
      _getNextVideosList();
    }
    else{
      videoModelToBePlayed = videosList[index];
      currentIndexPlaying=index;
      update();
    }
  }
  onClose(){
    videoPlayerController.value=null;
  }
}