import 'package:dualites/modules/home/pages/category_videos_list/category_videos_list.dart';
import 'package:dualites/modules/home/widgets/models/category_model.dart';
import 'package:dualites/shared/controller/category/category_list_controller.dart';
import 'package:dualites/shared/widgets/animate_list/animate_list.dart';
import 'package:dualites/shared/widgets/loading/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class CategoryListWidget extends StatelessWidget{
  final ScrollController scrollController;
  CategoryListWidget({this.scrollController});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<CategoryListController>(
            init: CategoryListController(),
            builder: (CategoryListController categoryController){
              return LoadingOverlay(
                isLoading: categoryController.isLoading,
                child: AnimationLimiter(
                  child: ListView.builder(itemBuilder: (context, int index){
                    CategoryModel categoryModel=categoryController.categoryList[index];
                    return AnimateList(
                      index: index,
                      widget: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CategoryVideosList(tagName: categoryModel.tag.toString(),
                                        scrollController: scrollController,
                                      )));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 5.0),
                          child: Chip(label: Text(categoryModel.tag,style: TextStyle(color: Colors.grey.shade600,fontWeight: FontWeight.bold),),
                              backgroundColor: Colors.grey.shade200,padding: const EdgeInsets.all(8.0)),
                        ),
                      ),
                    );
                  },scrollDirection: Axis.horizontal,itemCount: categoryController.categoryList.length,
                    physics: BouncingScrollPhysics(),),
                )
              );
            }
          ),
        ),

    );
  }
}