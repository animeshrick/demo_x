import 'package:dualites/modules/home/widgets/models/category_list.dart';
import 'package:dualites/modules/home/widgets/models/category_model.dart';
import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:dualites/shared/library/api_request.dart';

class CategoryListProvider {
  void getCategoriesList({
    Function() beforeSend,
    Function(CategoryList posts) onSuccess,
    Function(dynamic error) onError,
  }) {
    ApiRequest(url: 'https://dualite.xyz/api/v1/tags/', data: null).get(
      beforeSend: () => {if (beforeSend != null) beforeSend()},
      onSuccess: (data) {
        onSuccess(CategoryList.fromMap(Map.from(data)));
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }
}