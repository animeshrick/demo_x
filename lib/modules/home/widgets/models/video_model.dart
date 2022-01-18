import 'package:video_player/video_player.dart';

class VideoModel{
  int id,category,creator,views,likedCount;
  List<dynamic> liked;
  String title,description,contentOne,contentTwo,type,authorAvatar,authorName,thumbnail,media;
  VideoModel({this.id,this.category,this.creator,this.views,this.title,this.authorAvatar,this.authorName,this.thumbnail,this.description,this.contentOne,this.contentTwo,this.likedCount,
  this.type,this.liked,this.media});

  VideoPlayerController controller;
  VideoPlayerController controller2;
  factory VideoModel.fromMap(Map<String,dynamic> json){
    return new VideoModel(
      liked: json['liked'],
      description: json['description'] as String,
      type: json['type'] as String,
      media: json['media'] as String,
      likedCount: json['liked_count'],
      id: json['id'] as int,
      category: json['category'] as int,
      creator: json['creator'] as int,
      title: json['title'] as String,
      contentOne: json['content_one_url']==null || json['content_one_url']=="" ? json['upload_link_one']:json['content_one_url'],
      contentTwo: json['content_two_url']==null || json['content_two_url']=="" ? json['upload_link_two']:json['content_two_url'],
      views: json['views'] ?? 0,
      authorAvatar: json['author_avatar'],
      authorName: json['author_name'],
      thumbnail: json['thumbnail_url']
    );
  }

  Future<Null> loadController() async {
    controller = VideoPlayerController.network(contentOne);
    await controller.initialize();
    controller.setLooping(true);

    //TODO- Initialize second video controller
  }

}