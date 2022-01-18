import 'package:dualites/modules/home/widgets/models/category_model.dart';

class CategoryList{
  int count;
  List<CategoryModel> results;
  CategoryList({this.count,this.results});
  factory CategoryList.fromMap(Map<String,dynamic> json){
    return new CategoryList(
      count: json['count'] as int,
      results: json['results']==null ? []:(json['results'] as List)
        ?.map((e) => e == null ? null : CategoryModel.fromMap(Map.from(e)))
        ?.toList()
    );
  }
}