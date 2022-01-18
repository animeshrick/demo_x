import 'package:dualites/modules/home/widgets/models/category_model.dart';
import 'package:dualites/modules/home/widgets/models/video_model.dart';

class VideosList{
  int count;
  String next;
  List<VideoModel> results;
  VideosList({this.next,this.count,this.results});
  factory VideosList.fromMap(Map<String,dynamic> json){
    return new VideosList(
      next: json['next'] as String,
        count: json['count'] as int,
        results: json['results']==null ? []:(json['results'] as List)
        ?.map((e) => e == null ? null : VideoModel.fromMap(Map.from(e)))
        ?.toList()
    );
  }
}