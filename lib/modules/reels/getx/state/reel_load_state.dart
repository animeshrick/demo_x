import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ReelsLoadState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReelsInfoLoading extends ReelsLoadState {}

class ReelsInfoLoaded extends ReelsLoadState {
  final VideoModel videoInfo;

  ReelsInfoLoaded({@required this.videoInfo});

  @override
  List<Object> get props => [];
}


class ReelsLoaded extends ReelsLoadState {
  final bool isReelsLoaded;

  ReelsLoaded({@required this.isReelsLoaded});

  @override
  List<Object> get props => [];
}


class ReelLikedState extends ReelsLoadState {
  bool isLiked;
  ReelLikedState({this.isLiked});
  @override
  List<Object> get props => [];
}

class ReelInfoLoadingError extends ReelsLoadState {
  final String error;

  ReelInfoLoadingError({@required this.error});

  @override
  List<Object> get props => [error];
}