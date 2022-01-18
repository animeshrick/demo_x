import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:dualites/modules/landing/landing_page.dart';
import 'package:dualites/shared/controller/video_list_controller.dart';
import 'package:dualites/shared/controller/video_list_provider.dart';
import 'package:dualites/shared/widgets/animate_list/animate_list.dart';
import 'package:dualites/shared/widgets/loading/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SearchPage extends StatelessWidget{
  final VideoListController videoListController=Get
      .put(VideoListController(videoListProvider: VideoListProvider(dio: Dio())));
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Column(

          children: [Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF2D388A),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "Search",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  Expanded(child: SizedBox()),

                ],
              )),
            SearchTextField(
              callback: (val){
                videoListController.getVideosFromSearchQuery(val);
              },
            )      ,
            GetBuilder<VideoListController>(
              builder: (controller){
                return Expanded(
                  child: LoadingOverlay(
                      isLoading: controller.nextLoading,
                      child: AnimationLimiter(
                        child: ListView.builder(
                          //controller: scrollController,
                          //physics: BouncingScrollPhysics(),
                          itemBuilder: (context, int index) {
                            if(index==controller.searchVideos.length-1 && controller.nextLoading){
                              return Center(
                                child: Lottie.asset('assets/lotties/video_loader.json'),
                              );
                            }
                            VideoModel videoModel=controller.searchVideos[index];
                            return AnimateList(index:index,widget:InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LandingPage(id: videoModel.id,)));

                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      videoModel.thumbnail==null ?
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        child: Container(
                                          //padding:const EdgeInsets.all(0.0),
                                          //margin:const EdgeInsets.only(bottom: 5.0),
                                          height: MediaQuery.of(context).size.height * 0.2,
                                          width: MediaQuery.of(context).size.width,
                                          child:Image.asset("assets/images/home_girl.jpg"),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ):Container(
                                        width: MediaQuery.of(context).size.width,
                                        child: Container(
                                          //padding:const EdgeInsets.all(0.0),
                                          //margin:const EdgeInsets.only(bottom: 5.0),
                                          height: MediaQuery.of(context).size.height * 0.2,
                                          width: MediaQuery.of(context).size.width,
                                          child:Image.network(videoModel.thumbnail),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding:const EdgeInsets.symmetric(horizontal:50.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              videoModel.title,
                                              style: TextStyle(
                                                  color: Colors.black,fontFamily:"Montserrat", fontWeight: FontWeight.bold,fontSize: 20.0),
                                            ),
                                            Expanded(child: SizedBox()),
                                            PopupMenuButton(
                                              itemBuilder: (BuildContext context) {
                                                return {'1', '2'}.map((String choice) {
                                                  return PopupMenuItem<String>(
                                                    value: choice,
                                                    child: Text(choice),
                                                  );
                                                }).toList();
                                              },
                                            )
                                          ],
                                        ),
                                      ),

                                      Container(
                                        padding:const EdgeInsets.symmetric(horizontal:50.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 5.0),
                                              child: CircleAvatar(
                                                backgroundImage: AssetImage("assets/images/author_image.jpg"),
                                              ),
                                            ),
                                            Text("Author Name",style: TextStyle(color: Colors.black,fontSize: 12.0),),
                                            Expanded(child: SizedBox()),
                                            Text("242 Views",style: TextStyle(color: Colors.grey,fontSize: 12.0),),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ));
                          },
                          itemCount: controller.searchVideos.length,
                          shrinkWrap: true,
                          //padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                        ),
                      )
                  ),
                );
              },
            ),]
        ),
      ),
    );
  }
}

class SearchTextField extends StatefulWidget{
  Function callback;
  Function changeCallback;
  SearchTextField({this.callback,this.changeCallback});
  SearchTextFieldState createState()=>SearchTextFieldState();
}
class SearchTextFieldState extends State<SearchTextField>{
  String initialVal="";
  @override
  Widget build(BuildContext context) {
    if(widget.callback!=null) {
      return TextFormField(
        initialValue: initialVal,
        onChanged: (val) {
          setState(() {
            initialVal = val;
            if (widget.changeCallback != null)
              widget.changeCallback(initialVal);
          });
        },
        decoration: InputDecoration(
            suffix: IconButton(
              onPressed: () => widget.callback(initialVal),
              icon: Icon(Icons.search),
            )
        ),
      );
    }
    return TextFormField(
      initialValue: initialVal,
      onChanged: (val) {
        setState(() {
          initialVal = val;
          if (widget.changeCallback != null)
            widget.changeCallback(initialVal);
        });
      }
    );
  }
}