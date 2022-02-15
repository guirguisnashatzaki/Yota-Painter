import 'dart:ui';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';


class Paint_Page extends StatefulWidget {
  const Paint_Page({Key? key}) : super(key: key);

  @override
  _Paint_PageState createState() => _Paint_PageState();
}

class _Paint_PageState extends State<Paint_Page> {

  List points=[];
  late double width,height;
  late Color selectedcolor;
  late double strokewidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedcolor=Colors.black;
    strokewidth=2.0;
  }


  void pickcolor(){
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
             title: Text('Color Chooser'),
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

  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
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
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                //alignment: Alignment.center,
                width: width*0.80,
                height: height*0.80,
                decoration:BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  //color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 5.0,
                      spreadRadius: 1.0
                    )
                  ]
                ),
                child: GestureDetector(
                  onPanDown:(details){
                    setState(() {
                      points.add(DrawingArea(
                        point: details.localPosition,
                        areapaint: Paint()
                          ..strokeCap=StrokeCap.round
                          ..isAntiAlias=true
                          ..color=selectedcolor
                          ..strokeWidth=strokewidth
                      ));
                    });
                  },
                  onPanEnd:(details){
                    setState(() {
                      points.add(null);
                    });
                  },
                  onPanUpdate:(details){
                    setState(() {
                      points.add(DrawingArea(
                          point: details.localPosition,
                          areapaint: Paint()
                            ..strokeCap=StrokeCap.round
                            ..isAntiAlias=true
                            ..color=selectedcolor
                            ..strokeWidth=strokewidth
                      ));
                    });
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: CustomPaint(
                      painter: MyCustomPainter(points: points,selectedcolor: selectedcolor,strokewidth: strokewidth),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Material(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Container(
                  width: width*0.80,
                  height: height*0.07,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Row(
                    children: [
                      IconButton(onPressed: (){pickcolor();}, icon: Icon(Icons.color_lens,color: selectedcolor,)),
                      Expanded(child:Slider(
                        min:1.0,
                          max:10.0,
                          activeColor: selectedcolor,
                          value: strokewidth,
                          onChanged: (value){
                          setState(() {
                            strokewidth=value;
                          });
                          }
                      )
                      ),
                      IconButton(onPressed: (){
                        setState(() {
                          points.clear();
                        });
                      }, icon: const Icon(Icons.layers_clear)),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class DrawingArea{
  Offset point;
  Paint areapaint;

  DrawingArea({required this.point,required this.areapaint});
}

class MyCustomPainter extends CustomPainter{

  List points=[];
  Color selectedcolor;
  double strokewidth;
  MyCustomPainter({required this.points,required this.strokewidth,required this.selectedcolor});

  @override
  void paint(Canvas canvas, Size size) {
    // background
    Paint background=Paint()..color=Colors.white;
    Rect rect=Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);

    //painting
    /*Paint paint=Paint();
    paint.color=selectedcolor;
    paint.strokeWidth=strokewidth;
    paint.isAntiAlias=true;
    paint.strokeCap=StrokeCap.round;
*/
    for(int x=0;x<points.length;x++){
      if(points[x]!=null && points[x+1]!=null){
        Paint paint=points[x].areapaint;
        canvas.drawLine(points[x].point, points[x+1].point, paint);
      }else if(points[x]!=null && points[x+1]==null){
        Paint paint=points[x].areapaint;
        canvas.drawPoints(PointMode.points, [points[x].point], paint);
      }
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}

