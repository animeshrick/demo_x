import 'package:dualites/models/user_model.dart';

class UserProfileModel{
  int id,followingCount,followersCount,user,videosCount;
  String username,email,name,avatar,bio,
  updated,coverOne,coverTwo;
  bool isCreator;
  List<dynamic> videos,followers,following;
  UserProfileModel({this.id,this.user,this.username,this.email,this.videos,this.videosCount,this.followingCount,
  this.followers,this.following,this.followersCount,this.name,this.avatar,this.bio,this.isCreator,this.coverOne,this.coverTwo,this.updated});

  factory UserProfileModel.fromMap(Map<String,dynamic> json){
    return new UserProfileModel(
      email: json['email'] as String,
      id: json['id'] as int,
      name: json['name'] ?? "Unnamed",
      avatar: json['avatar'],
      bio: json['bio'],
      coverOne: json['cover_one'],
      coverTwo: json['cover_two'],
      //followers: json['followers'],
      followersCount: json['followers_count'] as int,
        followingCount: json['following_count'] as int,
      isCreator: json['is_creator'] as bool,
      updated: json['updated'],
      user: json['user'],
      username: json['username'],
      videos: json['videos'] ?? [],
      videosCount: json['videos_count'],
      following: json['following'] ?? []
    );
  }

}