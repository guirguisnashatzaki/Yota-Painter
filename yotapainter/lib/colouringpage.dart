import 'dart:typed_data';
import 'package:floodfill_image/floodfill_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:yotapainter/colouringtany.dart';

import 'dart:ui' as ui;
import 'package:yotapainter/saving.dart';

import 'Model/drawingarea.dart';

class MyColouringPage extends StatefulWidget {
  Uint8List pngBytes;
  List<DrawingArea> list;
  double x,y;
  String name;
   MyColouringPage({Key? key,required this.pngBytes,required this.list,required this.y,required this.x,required this.name}) : super(key: key);

  @override
  _MyColouringPageState createState() => _MyColouringPageState();
}

class _MyColouringPageState extends State<MyColouringPage> {

  void pickColor(){
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: const Text('Color Chooser'),
              content: SingleChildScrollView(
                child: BlockPicker(
                    pickerColor: selectedcolor,
                    onColorChanged: (color){
                      setState(() {
                        selectedcolor=color;
                      });
                    }
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
  }

  Future<bool> takePicture() async {
    RenderRepaintBoundary? boundary = genKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> Saving_Page(pngBytes: pngBytes,list: widget.list,y:widget.y ,x: widget.x,name: widget.name,)));
    return false;
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Remember when you move backward all your colouring will be erased do want to continue?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(false);
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=> CustomPaintPage(list: widget.list,numberofsquares_y:widget.y ,numberofsquares_x: widget.x,name: "")));
              },
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }


  Color selectedcolor = Colors.green,buttonBackGround=Colors.white,buttonText=Colors.black;
  final GlobalKey genKey = GlobalKey();
  late double width,height;

  @override
  Widget build(BuildContext context)  {
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InteractiveViewer(
                        minScale: 1,
                        maxScale: 20,
                        child: RepaintBoundary(
                          key: genKey,
                          child: FloodFillImage(
                            imageProvider: MemoryImage(widget.pngBytes),
                            fillColor: selectedcolor,
                            avoidColor: const [Colors.transparent, Colors.black],
                            tolerance: 10,
                          ),
                        ),
                      ),
                      Container(
                        height: height*0.1,
                        decoration: const BoxDecoration(
                          color: Colors.white
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(onPressed: (){pickColor();}, icon: Icon(Icons.color_lens,color: selectedcolor,)),
                            TextButton(style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(buttonBackGround)
                            ),
                                onPressed:(){setState(() {
                                  if(selectedcolor==Colors.white){
                                    pickColor();
                                    buttonBackGround=Colors.white;
                                    buttonText=Colors.black;
                                  }else{
                                    selectedcolor=Colors.white;
                                    buttonBackGround=Colors.black;
                                    buttonText=Colors.white;
                                  }

                            });},child: Text("White",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: buttonText),)),
                            IconButton(onPressed: ()async{
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Are you sure?'),
                                  content: const Text('Remember when you go to save all your colouring will be erased do want to continue?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: ()async{Navigator.of(context).pop();await takePicture();} ,
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                ),
                              );


                              }, icon: Icon(Icons.check,color: selectedcolor,)),
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
}
