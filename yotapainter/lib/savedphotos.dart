import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'Model/drawingarea.dart';
import 'Model/drawingareaprimitives.dart';
import 'Model/photo.dart';
import 'custom_paint.dart';



const String photosBoxName="PHOTOSBOXNAME";

class SavedPhotosPage extends StatelessWidget {
  late double width,height;


  SavedPhotosPage({Key? key}) : super(key: key);

  Future<List<String>> getPhotos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //List<String>? photos=prefs.getStringList("data");
    //List<String> photos2=photos!;
    String? path=prefs.getString("ph");
    final Directory directory =Directory(path!);
    List<FileSystemEntity> photos=directory.listSync();
    List<String> photos2=[];
    for(int i=0;i<photos.length;i++){
          if(p.extension(photos[i].path)==".pdf"){

          }else {
            photos2.add(photos[i].path);
      }
    }
    //filesL = await FilesInDirectory().getFilesFromDir();
    return photos2;
  }



  @override
  Widget build(BuildContext context) {

    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(138, 35, 135, 1),
              Color.fromRGBO(233, 64, 87, 1),
              Color.fromRGBO(242, 113, 33, 1),
            ],
          )
      ),
      child: Container(
        //width: width,
        //height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(1, 1)
              )
            ]
        ),
        margin: EdgeInsets.fromLTRB(width*0.1, height*0.1,width*0.1, height*0.05),
        child: FutureBuilder<List<String>>(
          future: getPhotos(),
          builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              default:
                if (snapshot.hasError) {
                  return const Text(/*'Error: ${snapshot.error}'*/"Nothing Found",style: TextStyle(fontSize: 25,color: Colors.black,decoration: TextDecoration.none),);
                } else {
                  return ListView(
                    children: List<card>.generate(snapshot.data!.length, (index) => card(path: snapshot.data![index],)),
                  );
                  //return Text(/*'Error: ${snapshot.error}'*/"Nothing Found",style: TextStyle(fontSize: 25,color: Colors.black,decoration: TextDecoration.none),);
                }
            }
          },
        )
      ),
    );
  }
}


class card extends StatelessWidget {

  String path;
  late Box<Photo> photosBox;
  late Photo photo;
  late List<DrawingArea> list;
  card({Key? key,required this.path}) : super(key: key);

  getdata(String name){
    photo=photosBox.get(name,defaultValue: Photo(y: 3,x: 3,path: "",list: []))!;
    list=ConvertToArea(photo.list);
  }

  List<DrawingArea> ConvertToArea(List<DrawingAreaPrimitives> primitives){
    List<DrawingArea> list=[];

    for(int i=0;i<primitives.length;i++){
      DrawingArea? object=DrawingArea(
          mainPoint: Offset(primitives[i].mainDx,primitives[i].mainDy),
          areaPaint:
          Paint()
            ..strokeCap=StrokeCap.round
            ..isAntiAlias=true
            ..color=Color(primitives[i].color)
            ..strokeWidth=primitives[i].width
            ..style=PaintingStyle.stroke
          ,
          secondaryPoint: Offset(primitives[i].secondaryDx,primitives[i].secondaryDy),
          type: primitives[i].Mytype);

      list.add(object);
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    photosBox=Hive.box<Photo>(photosBoxName);
    return Material(
      child: InkWell(
        onTap: (){
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('do want to edit?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    String name=(path.split("/"))[5].split(".")[0];
                    getdata(name);
                    Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> CustomPaintPage(numberofsquares_y: photo.y, numberofsquares_x: photo.x,list: list, name: name,)));
                  } ,
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
          },
        child: Card(
          child: Hero(
            tag: (path.split("/")).toString().split(".")[0],
            child:Material(
              child: GridTile(
                child: Image.file(File(path)),
              ),
            )
          ),
        ),
      ),
    );
  }
}
