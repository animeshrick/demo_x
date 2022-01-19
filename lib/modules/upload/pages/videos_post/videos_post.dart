import 'dart:io';

import 'package:dualites/modules/upload/getx/gallery_controller.dart';
import 'package:dualites/modules/upload/getx/gallery_state.dart';
import 'package:dualites/shared/controller/category/category_list_controller.dart';
import 'package:dualites/shared/widgets/da_raised_button_widget/da_raised_button_widget.dart';
import 'package:dualites/shared/widgets/image_widget/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share/share.dart';
import 'package:video_editor/utils/controller.dart';
import 'package:video_editor/video_editor.dart';
class VideosPost extends StatefulWidget{
  VideosPostState createState()=>VideosPostState();
}
class VideosPostState extends State<VideosPost>{
  List<String> typeOfVideos=["DUALITE","PILL"];
  String selectedVal="DUALITE";
  List<String> newTags=[];
  File imageFile;
  String categoriesList="";
  List<TagModel> tags=[];
  String category="";
  TextEditingController _tagController=TextEditingController(text: "");
  VideoEditorController videoEditorController1;
  VideoEditorController videoEditorController2;
  final GalleryController galleryController=Get.find();
  bool isFirstVideoExporting=false;
  bool isSecondVideoExporting=false;
  bool canBeLoaded=true;

  void initState(){
    super.initState();
    initializeControllerAndFile();
  }

  initializeControllerAndFile()async{
    File file=await galleryController.selectedAssets[0].file;
    File file2=await galleryController.selectedAssets[1].file;
    videoEditorController1 = VideoEditorController.file(file);
    videoEditorController2=VideoEditorController.file(file2);
    await videoEditorController1.initialize();
    await videoEditorController2.initialize();
    setState(() {
      /*if(videoEditorController1.video.value.duration<=Duration(seconds: 30,minutes: 1,milliseconds: 100000)){
        canBeLoaded=true;
      }*/
    });

  }
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(galleryController.state is PostVideoSuccessState){
        PostVideoSuccessState state= galleryController.state as PostVideoSuccessState;
        //galleryController.createDeepLink(state.video_id);
        //Get.snackbar("Saving..", "Please wait.", backgroundColor: Colors.green,colorText: Colors.white);
      }
      if(galleryController.state is VideoDeepLinkCreationSuccessState){
        VideoDeepLinkCreationSuccessState state =galleryController.state;
        showDialog(context: context,
            barrierDismissible: true,
            builder: (context){
              return AlertDialog(
                title: Center(child: Text("Share Link"),),
                content: Container(
                  height: MediaQuery.of(context).size.height*0.2,
                  width: MediaQuery.of(context).size.width*0.8,
                  child: Center(
                    child: Text(state.deepLinkUrl),
                  ),
                ),
                actions: [
                  OutlineButton(onPressed: ()=>Navigator.pop(context),child: Center(child: Text("Cancel"),),),
                  RaisedButton(onPressed: (){
                    Share.share(state.deepLinkUrl);
                  },child: Center(child: Text("Share"),),)
                ],
              );
            });
      }
      if(galleryController.state is PostVideoErrorState){

        /*Get.snackbar("Error", (galleryController.state as PostVideoErrorState).message,backgroundColor: Colors.red,
        colorText: Colors.white);*/
      }
      return Scaffold(
        key: galleryController.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Upload Videos"),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      galleryController.typeController.text=selectedVal;
                      if(!canBeLoaded && galleryController.resizedFiles.length<2){
                        galleryController.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please export files first")));
                      }
                      else{
                        if(imageFile!=null && imageFile.path.trim()!="")
                          galleryController.postVideoContent(imageFile,categoriesList,context);
                        else
                          galleryController.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please Add a thumbnail Image")));
                      }

                    },
                    child: Text("Post"),
                  ),
                )
              ],
            )
          ],
        ),
        body: videoEditorController1==null && videoEditorController2==null ?Center(child: Text("Loading"),):SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  canBeLoaded ?Container():Column(children:_trimSlider(videoEditorController1, 0)),
                  canBeLoaded ?Container():Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DaRaisedButtonWidget(
                        buttonText: "Ok",
                        callback: isFirstVideoExporting ?null:(){
                          _exportVideo(videoEditorController1, 0);
                        },
                        textColor: Colors.white,
                        disabledButtontext: "Exporting",
                      )
                    ],
                  ),
                  canBeLoaded ?Container():Column(children:_trimSlider(videoEditorController2, 1)),
                  canBeLoaded ?Container():Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DaRaisedButtonWidget(
                        buttonText: "Ok",
                        callback: isSecondVideoExporting ?null:(){
                          _exportVideo(videoEditorController2, 1);
                        },
                        textColor: Colors.white,
                        disabledButtontext: "Exporting",
                      )
                    ],
                  ),
                  Form(
                    key: galleryController.formKey,
                    child: Column(
                      children: [
                        ImageUploadWidget(
                          file:imageFile,
                          callback: (file) {
                            setState(() {
                              imageFile = file;
                            });
                          },
                        ),
                        TextFormField(
                          controller: galleryController.titleController,
                          decoration: InputDecoration(
                              labelText: "Please Select Title"
                          ),
                          validator: (val) {
                            if (val.toString().trim() == "")
                              return "Please Enter Title";
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: galleryController.descriptionController,
                          decoration: InputDecoration(
                              labelText: "Please Select Description"
                          ),
                          validator: (val) {
                            if (val.toString().trim() == "")
                              return "Please Enter Description";
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(flex:2,child: TextFormField(
                              controller: _tagController,
                              decoration: InputDecoration(
                                  labelText: "Please Select Category"
                              ),

                            )),
                            Expanded(child: RaisedButton(onPressed: (){
                              setState(() {
                                newTags.add(_tagController.text);
                                _tagController.text="";
                              });
                            },child: Center(child: Text("Add"),),textColor: Colors.white,color: Colors.blue,))
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          //                   height: MediaQuery.of(context).size.height*0.2,
                          child: Wrap(
                              children:
                              newTags.map((e) {
                                return Padding(
                                    padding:const EdgeInsets.all(5.0),child: Chip(label: Text(e,style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue,));
                              }).toList()

                          ),
                        ),
                        DropdownButton(isExpanded: true,items: typeOfVideos.map((e){
                          return DropdownMenuItem(child: Text(e),value: e,);
                        }).toList(), onChanged: (String val){
                          setState(() {
                            selectedVal=val;
                          });
                        },value: selectedVal,),/*
                        CategorySelection(tags: tags,callback: (List<String> categories){
                          setState(() {
                            categoriesList = categories.toString();
                          });

                        },)*/

                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    );
  }

  Future<void> _exportVideo(VideoEditorController controller,int index) async {
    if(index==1 && isFirstVideoExporting==true){
      galleryController.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("First Video export has to complete first")));

    }else if(index==0 && isSecondVideoExporting==true){
      galleryController.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Second Video export has to complete first")));
    }
    else {
      setState(() {
        if (index == 0) {
          isFirstVideoExporting = true;
        }
        else {
          isSecondVideoExporting = true;
        }
      });
      File file = await controller.exportVideo(
          name: "video_$index"
      );
      setState(() {
        if (index == 0)
          isFirstVideoExporting = false;
        else
          isSecondVideoExporting = false;
      });
      galleryController.resizedFiles[index]=file;
    }
  }

  String formatter(Duration duration) => [
    duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
    duration.inSeconds.remainder(60).toString().padLeft(2, '0')
  ].join(":");
  List<Widget> _trimSlider(VideoEditorController controller,int index) {
    return [
      AnimatedBuilder(
        animation: controller.video,
        builder: (_, __) {
          final duration = controller.video.value.duration.inSeconds;
          final pos = controller.trimPosition * duration;
          final start = controller.minTrim * duration;
          final end = controller.maxTrim * duration;
          return Padding(
            padding: Margin.horizontal(MediaQuery.of(context).size.height / 4),
            child: Row(children: [
              TextDesigned(formatter(Duration(seconds: pos.toInt()))),
              Expanded(child: SizedBox()),
              OpacityTransition(
                visible: controller.isTrimming,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  TextDesigned(formatter(Duration(seconds: start.toInt()))),
                  SizedBox(width: 10),
                  TextDesigned(formatter(Duration(seconds: end.toInt()))),
                ]),
              )
            ]),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.1,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: TrimSlider(
          controller: controller,
          height: MediaQuery.of(context).size.height*0.1,
        ),
      )
    ];
  }
}
class CategorySelection extends StatefulWidget{
  List<TagModel> tags;
  final Function callback;
  CategorySelection({this.tags,this.callback});
  CategorySelectionState createState()=>CategorySelectionState();
}
class CategorySelectionState extends State<CategorySelection>{
  final CategoryListController categoryListController=Get.find();

  @override
  Widget build(BuildContext context) {
    return MultiSelectFormField(
      autovalidate: false,
      chipBackGroundColor: Colors.red,
      chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
      checkBoxActiveColor: Colors.red,
      checkBoxCheckColor: Colors.green,
      dialogShapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      title: Text(
        "Please Select Categories",
        style: TextStyle(fontSize: 16),
      ),
      dataSource: categoryListController.categoryList.map((e){
        return TagModel(display: e.tag,value: e.tag).toJson();
      }).toList(),
      textField: 'display',
      fillColor: Colors.blue,
      valueField: 'value',
      okButtonLabel: 'OK',
      cancelButtonLabel: 'CANCEL',
      hintWidget: Text('Please choose one or more'),
      initialValue: widget.tags,
      onSaved: (value) {
        if (value == null) return;
        setState(() {
          widget.tags = value;
          widget.callback(widget.tags);
        });
      },
    );
  }
}

class TagModel{
  String display,value;
  TagModel({this.value,this.display});
  toJson(){
    return {
      "display":display,
      "value":value
    };
  }
}