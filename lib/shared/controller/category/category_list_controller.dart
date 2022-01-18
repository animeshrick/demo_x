import 'package:dualites/modules/home/widgets/models/category_model.dart';
import 'package:dualites/shared/controller/category/category_list_provider.dart';
import 'package:get/get.dart';

class CategoryListController extends GetxController {
  List<CategoryModel> categoryList = [];
  bool isLoading = true;

  @override
  void onInit() {
    CategoryListProvider().getCategoriesList(
      onSuccess: (category) {
        categoryList.addAll(category.results);
        isLoading = false;
        update();
      },
      onError: (error) {
        isLoading = false;
        update();
        print("Error");
      },
    );
    super.onInit();
  }
}
