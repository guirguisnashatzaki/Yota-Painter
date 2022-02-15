import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image/image.dart' as om;
//import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:yotapainter/custom_paint.dart';
import 'Model/drawingarea.dart';
import 'Model/drawingareaprimitives.dart';
import 'Model/photo.dart';


const String photosBoxName="PHOTOSBOXNAME";

class Saving_Page extends StatefulWidget {

  Uint8List pngBytes;
  List<DrawingArea> list;
  double x,y;
  String name;
  Saving_Page({Key? key,required this.pngBytes,required this.list,required this.x,required this.y,required this.name}) : super(key: key);

  @override
  _Saving_PageState createState() => _Saving_PageState();
}

class _Saving_PageState extends State<Saving_Page> {
  late double width,height;
  TextEditingController nameController=TextEditingController();
  late Box<Photo> photosBox;

  List<DrawingAreaPrimitives> ConvertToPrimitive(List<DrawingArea> areas){
    List<DrawingAreaPrimitives> list=[];

    for(int i=0;i<areas.length;i++){
      DrawingAreaPrimitives object=DrawingAreaPrimitives(width: areas[i].areaPaint.strokeWidth, mainDx: areas[i].mainPoint.dx, mainDy: areas[i].mainPoint.dy, secondaryDx: areas[i].secondaryPoint.dx, secondaryDy: areas[i].secondaryPoint.dy, color: areas[i].areaPaint.color.value, Mytype: areas[i].type);
      list.add(object);
    }

    return list;
  }


  Future<bool> _requestPermission(Permission permission)async{
    if(await permission.isGranted){
      return true;
    }else{
      var result = await permission.request();
      if(result==PermissionStatus.granted){
        return true;
      }else{
        return false;
      }
    }
  }




  Future<bool> takePicture(String name,String extension) async {
    Directory directory;
    try{
      if(Platform.isAndroid){
        if(await _requestPermission(Permission.storage)){
          directory=(await getExternalStorageDirectory())!;
          List<String> folders=directory.path.split("/");
          String newPath="";
          for(int i=1;i<folders.length;i++){
            String folder=folders[i];
            if(folder!="Android"){
              newPath+="/"+folder;
            }else{
              break;
            }
          }
          newPath=newPath+"/Yota";
          directory=Directory(newPath);

        }else{
          return false;
        }
      }else{
        if(await _requestPermission(Permission.photos)){
          directory=await getTemporaryDirectory();
        }else{
          return false;
        }
      }
      if(!await directory.exists()){
        await directory.create(recursive: true);
      }
      if(await directory.exists()){

        String data=directory.path;
        if(extension.compareTo("png")==0){
          File file=File(directory.path + "/" + name + ".png");
          await file.writeAsBytes(widget.pngBytes);
        }else if(extension.compareTo("jpg")==0){
          File file=File(directory.path + "/" + name + ".png");
          await file.writeAsBytes(widget.pngBytes);
          final image = om.decodeImage(File(directory.path + "/" + name + ".png").readAsBytesSync())!;
          File(directory.path + "/" + name + ".jpg").writeAsBytesSync(om.encodeJpg(image));
          file.delete();
        }else if(extension.compareTo("pdf")==0){
          File file=File(directory.path + "/" + name + ".png");
          await file.writeAsBytes(widget.pngBytes);
          final image = om.decodeImage(File(directory.path + "/" + name + ".png").readAsBytesSync())!;
          file.delete();
          File(directory.path + "/" + name + ".jpg").writeAsBytesSync(om.encodeJpg(image));
          final imagejpg = pw.MemoryImage(
            File(directory.path + "/" + name + ".jpg").readAsBytesSync(),
          );
          //File(directory.path + "/" + name + ".jpg").delete();
          final pdf = pw.Document();
          pdf.addPage(pw.Page(build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(imagejpg),
            ); // Center
          }));
          final filepdf = File(directory.path + "/" + name + ".pdf");
          await filepdf.writeAsBytes(await pdf.save());
        }



        //saving
        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('ph', data);
        List<DrawingAreaPrimitives> list=ConvertToPrimitive(widget.list);

        final Photo photo=Photo(list: list,path: directory.path + "/" + name + ".png",x: widget.x,y: widget.y);

        photosBox.put(name, photo);



        Navigator.pop(context);
      }
    }catch(e){
      final snackBar = SnackBar(
        content: const Text('Save failed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return false;
  }

  @override
  void dispose() {
    nameController.dispose();
    // TODO: implement dispose
    super.dispose();
  }


  @override
  void initState() {
    photosBox=Hive.box<Photo>(photosBoxName);
    nameController.text=widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Colors.grey,
                    width: 5
                ),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(1, 1)
                  )
                ]
            ),
            margin: EdgeInsets.fromLTRB(width*0.1, height*0.1,width*0.1, height*0.05),
            child: Column(
              children: [
                Container(margin: const EdgeInsets.all(5),child: Image.memory(widget.pngBytes)),
                Material(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    child: TextFormField(
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: nameController,
                      //textInputAction: TextInputAction.next,
                      //keyboardType: TextInputType.phone,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                      decoration: const InputDecoration(
                          labelText: "File name *"
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=> CustomPaintPage(list: widget.list,numberofsquares_y:widget.y ,numberofsquares_x: widget.x,name: "")));}, child: const Text("Discard",style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)), ),
                    const SizedBox(width: 15,),
                    ElevatedButton(onPressed: ()async{
                        if(nameController.text.isEmpty){
                          final snackBar = SnackBar(
                            content: const Text('Put a name for the image'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {},
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }else{
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
                                    title: const Text('Saving way'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          //Divider(color: Colors.grey,thickness: 1,),
                                          ListTile(
                                            title: const Text("PNG"),
                                            onTap: () async {
                                              await takePicture(nameController.text,"png");
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=> CustomPaintPage(list: widget.list,numberofsquares_y:widget.y ,numberofsquares_x: widget.x,name: "")));
                                            },
                                          ),
                                          const Divider(color: Colors.grey,thickness: 1,),
                                          ListTile(
                                            title: const Text("JPG"),
                                            onTap: ()async{
                                              await takePicture(nameController.text,"jpg");
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=> CustomPaintPage(list: widget.list,numberofsquares_y:widget.y ,numberofsquares_x: widget.x,name: "")));
                                            },
                                          ),
                                          const Divider(color: Colors.grey,thickness: 1,),
                                          ListTile(
                                            title: const Text("PDF"),
                                            onTap: ()async{
                                              await takePicture(nameController.text,"pdf");
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=> CustomPaintPage(list: widget.list,numberofsquares_y:widget.y ,numberofsquares_x: widget.x,name: "")));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      CloseButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  )
                          );
                           //await takePicture(nameController.text);
                        }
                      }, child: const Text("Save",style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)), ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
