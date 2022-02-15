import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yotapainter/getdata.dart';
import 'package:yotapainter/manual.dart';


import 'package:yotapainter/savedphotos.dart';

import 'Model/drawingarea.dart';
import 'Model/drawingareaprimitives.dart';
import 'Model/photo.dart';


const String photosBoxName="PHOTOSBOXNAME";

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final document=await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(DrawingAreaPrimitivesAdapter());
  Hive.registerAdapter(PhotoAdapter());
  await Hive.openBox<Photo>(photosBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yota Painter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home:  const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Box<Photo> photosBox;
  late Photo photo;
  late List<DrawingArea> list;
  getdata(){
    photo=photosBox.get("first try",defaultValue: Photo(y: 3,x: 3,path: "",list: []))!;
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
  //getdata();
    return Scaffold(
      body:Container(
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
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){

                Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> const GetData()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey,
                    width: 4.0
                  )
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(20),
                child:const Text("Custom Painter",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ),
            ),
            /*InkWell(
              onTap: (){
                //Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> const Paint_Page()));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.grey,
                        width: 4.0
                    )
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(20),
                child:const Text("Paint",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ),
            ),*/
            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>  SavedPhotosPage()));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.grey,
                        width: 4.0
                    )
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(20),
                child:const Text("Saved photos",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> ManualPage()));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.grey,
                        width: 4.0
                    )
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(20),
                child:const Text("Manual",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ),
            ),
          ],
        ),



      )
    );
  }

  @override
  void initState() {
    photosBox=Hive.box<Photo>(photosBoxName);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }
}
