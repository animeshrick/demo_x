import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class VideoLoadState extends Equatable {
  @override
  List<Object> get props => [];
}

class VideoInfoLoading extends VideoLoadState {}

class VideoInfoLoaded extends VideoLoadState {
  final VideoModel videoInfo;

  VideoInfoLoaded({@required this.videoInfo});

  @override
  List<Object> get props => [];
}

class VideosLoadedForUserId extends VideoLoadState {
  final List<VideoModel> videosList;

  VideosLoadedForUserId({@required this.videosList});

  @override
  List<Object> get props => [];
}

class VideoLikedState extends VideoLoadState {
  bool isLiked;
  VideoLikedState({this.isLiked});
  @override
  List<Object> get props => [];
}

class VideoDeletedInProgressState extends VideoLoadState {
  VideoDeletedInProgressState();
  @override
  List<Object> get props => [];
}
class VideoDeletedResponseState extends VideoLoadState {
  VideoDeletedResponseState();
  @override
  List<Object> get props => [];
}

class VideoInfoLoadingError extends VideoLoadState {
  final String error;

  VideoInfoLoadingError({@required this.error});

  @override
  List<Object> get props => [error];
}