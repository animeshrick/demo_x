class CategoryModel{
  String tag;
  CategoryModel({this.tag});
  factory CategoryModel.fromMap(Map<String,dynamic> json){
    return new CategoryModel(
      tag: json['tag'] as String
    );
  }
}

