import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:yotapainter/saving.dart';

import 'Model/drawingarea.dart';
import 'Painters/antiarcpainter.dart';
import 'Painters/arcpainter.dart';
import 'Painters/dotpainter.dart';
import 'Painters/linepainter.dart';
import 'Painters/pluspainter.dart';
import 'Painters/yotacustompainter.dart';
import 'colouringpage.dart';
import 'notifier.dart';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'dart:async';




class CustomPaintPage extends StatefulWidget {
  final double numberofsquares_x,numberofsquares_y;
  List<DrawingArea> list;
  String name;
  CustomPaintPage({Key? key,required this.numberofsquares_y,required this.numberofsquares_x,required this.list,required this.name}) : super(key: key);

  @override
  _CustomPaintPageState createState() => _CustomPaintPageState();
}

class _CustomPaintPageState extends State<CustomPaintPage> {


  late double width,height,strokewidth;
  late Color selectedcolor;
  List<Offset> startPoints=[],endPoints=[],centers=[],intersections=[],colourPoints=[];
  List<double> centers_x=[],centers_y=[];
  late double square_side_length_global,globalRadius;
  final panAndZoom=PanAndZoomNotifier();
  final pointNotifier=PointNotifier();
  final zoomNotifier=ZoomNotifier();
  final customPaintNotifier=CustomPaintNotifier();
  final colouringNotifier=ColouringNotifier();
  final selectingPointsNotifier=SelectingPointsNotifier();
  final colorNotifier=ColorNotifier();
  final drawingNotifier=DrawingNotifier();
  late Offset divideXStart,divideYStart,divideXEnd,divideYEnd;
  bool controlDrawing=true;
  String lineOrArc="";
  final TransformationController _transformationController =
  TransformationController();
  final GlobalKey genKey = GlobalKey();
  LineOrArc ob=LineOrArc();


  @override
  void dispose() {
    panAndZoom.dispose();
    pointNotifier.dispose();
    zoomNotifier.dispose();
    customPaintNotifier.dispose();
    colouringNotifier.dispose();
    selectingPointsNotifier.dispose();
    drawingNotifier.dispose();
    super.dispose();
  }

  PaintGridView(double numberofsquaresX,double numberofsquaresY,double width,double height){
    double squareSideLength1,squareSideLength2,squareSideLength;
    double selectedDividend=0;
    double selectedDivisor=1;
    if(numberofsquaresX>numberofsquaresY){
      selectedDivisor=numberofsquaresX;
    }else if(numberofsquaresY>=numberofsquaresX){
      selectedDivisor=numberofsquaresY;
    }

    if(width>height){
      selectedDividend=height;
    }else if(height>=width){
      selectedDividend=width;
    }

    squareSideLength1=selectedDividend/selectedDivisor;

    if(numberofsquaresX>numberofsquaresY){
      selectedDivisor=numberofsquaresY;
    }else if(numberofsquaresY>=numberofsquaresX){
      selectedDivisor=numberofsquaresX;
    }

    if(width>height){
      selectedDivisor=width;
    }else if(height>=width){
      selectedDivisor=height;
    }
    squareSideLength2=selectedDividend/selectedDivisor;

    squareSideLength=(squareSideLength1+squareSideLength2)/2;
    //print(square_side_length.toString()+"================================");
    square_side_length_global=squareSideLength;

    double xpoint=0,widthLocal=width;
    while(widthLocal>squareSideLength){
      xpoint=xpoint+squareSideLength;
      startPoints.add(Offset(xpoint, 0));
      endPoints.add(Offset(xpoint, height));
      widthLocal=widthLocal-squareSideLength;
    }

    double ypoint=0,heightLocal=height;
    while(heightLocal>squareSideLength){
      ypoint=ypoint+squareSideLength;
      startPoints.add(Offset(0,ypoint));
      endPoints.add(Offset(width,ypoint));
      heightLocal=heightLocal-squareSideLength;
    }

  }

  Centers(List<Offset> xPoints,double squareSideLength){
    centers_x.add(squareSideLength/2);
    centers_y.add(squareSideLength/2);
    for(int i=0;i<xPoints.length;i++){
      if(xPoints[i].dy==0){
        centers_x.add(xPoints[i].dx+squareSideLength/2);
      }

      if(xPoints[i].dx==0){
        centers_y.add(xPoints[i].dy+squareSideLength/2);
      }
    }

    for(int j=0;j<centers_x.length;j++){
      for(int k=0;k<centers_y.length;k++){
        centers.add(Offset(centers_x[j],centers_y[k]));
        customPaintNotifier.addPointToBeSelected(Offset(centers_x[j],centers_y[k]));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    //selectedcolor=Colors.black;
    customPaintNotifier.addall(widget.list);
  }

  /*void pickColor(){
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: const Text('Color Chooser'),
              content: SingleChildScrollView(
                child: BlockPicker(
                    pickerColor: selectedcolor,
                    onColorChanged: (color){
                      customPaintNotifier.changeColor(color);
                      colorNotifier.changeColor(color);
                      selectingPointsNotifier.changeColor(color);
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
  }*/

  Intersections(List<Offset> startPoints){
    List<Offset> startPointsX=[],startPointsY=[];
    for(int i=0;i<startPoints.length;i++){
      if(startPoints[i].dy==0){
        startPointsX.add(startPoints[i]);
      }
      if(startPoints[i].dx==0){
        startPointsY.add(startPoints[i]);
      }
    }

    for(int j=0;j<startPointsX.length;j++){
      for(int k=0;k<startPointsY.length;k++){
        intersections.add(Offset(startPointsX[j].dx,startPointsY[k].dy));
        customPaintNotifier.addPointToBeSelected(Offset(startPointsX[j].dx,startPointsY[k].dy));
      }
    }

  }

  Offset closestPoint(Offset tappedPoint,List<Offset> points){
    List<double> distances=[];
    for(int i=0;i<points.length;i++){
      distances.add(sqrt(pow(tappedPoint.dx-points[i].dx,2)+pow(tappedPoint.dy-points[i].dy,2)));
    }

    double min=99999999999999991611392;

    for(int j=0;j<distances.length;j++){
      if(distances[j]<min){
        min=distances[j];
      }
    }

    return points[distances.indexOf(min)];
  }

  /*radius(double sideLength){
    double radius=sideLength/2;
    globalRadius=radius*sqrt(2);
  }*/

  Future<Uint8List> getImage() async{
    final _snapshot = await _loadSnapshot();

    final _imageByteData =
    await _snapshot.toByteData(format: ui.ImageByteFormat.png);

    final _imageBuffer = _imageByteData!.buffer;

    final _uint8List = _imageBuffer.asUint8List();


    _snapshot.dispose();

    return _uint8List;
  }

  Future<ui.Image> _loadSnapshot() async {
    final RenderRepaintBoundary _repaintBoundary =
    genKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final _snapshot = await _repaintBoundary.toImage();

    return _snapshot;
  }

  Future<bool> takePicture() async {
    RenderRepaintBoundary? boundary = genKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> MyColouringPage(pngBytes: pngBytes,list: customPaintNotifier.points,x:widget.numberofsquares_x ,y:widget.numberofsquares_y ,name: widget.name,)));
    return false;
  }

  Future<bool> takePictureExport() async {
    RenderRepaintBoundary? boundary = genKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> Saving_Page(pngBytes: pngBytes,list: customPaintNotifier.points,x:widget.numberofsquares_x ,y:widget.numberofsquares_y ,name: widget.name,)));
    return false;
  }

  divideTheCanvas(){
    double newwidth=width/2;
    double newheight=height*0.8/2;
    divideXStart=closestPoint(Offset(newwidth,0), startPoints);
    divideYStart=closestPoint(Offset(0,newheight), startPoints);
    divideXEnd=Offset(divideXStart.dx,height*0.8);
    divideYEnd=Offset(width,divideYStart.dy);
  }
  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    PaintGridView(widget.numberofsquares_x, widget.numberofsquares_y, width, height*0.80);
    Centers(startPoints,square_side_length_global);
    Intersections(startPoints);
    //radius(square_side_length_global);
    strokewidth=square_side_length_global*0.05;
    divideTheCanvas();
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
            children: [
              Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width,
                          height: height*0.80,
                          child:GestureDetector(
                              onTapDown:(details) async {
                                if(selectingPointsNotifier.selectingPoints==true){
                                  if(colouringNotifier.colouring){

                                  }else{
                                    Offset childWasTappedAt=_transformationController.toScene(details.localPosition);
                                    Offset checkedOffset=closestPoint(childWasTappedAt, customPaintNotifier.pointsToBeSelected);
                                    if(controlDrawing==true){
                                      customPaintNotifier.makePointChecked(checkedOffset);
                                      controlDrawing=false;
                                    }
                                    else{
                                      Offset temp=Offset(customPaintNotifier.checkedPoint!.dx, customPaintNotifier.checkedPoint!.dy);
                                      customPaintNotifier.addPoint(DrawingArea(
                                        mainPoint: checkedOffset,
                                        areaPaint:Paint()
                                          ..strokeCap=StrokeCap.round
                                          ..isAntiAlias=true
                                          ..color=customPaintNotifier.color
                                          ..strokeWidth=strokewidth
                                          ..style=PaintingStyle.stroke
                                        ,
                                        secondaryPoint: temp/*customPaintNotifier.pointsToBeSelected[customPaintNotifier.indexOfPoints]*/,
                                        type: lineOrArc,
                                        //radius: 300,
                                        //colours: []
                                      )
                                      );
                                      //customPaintNotifier.setSelectingPointsToFalse();
                                      //customPaintNotifier.setCentersToFalse();
                                      customPaintNotifier.makePointNull();
                                      //selectingPointsNotifier.setSelectingPointsToFalse();
                                      //customPaintNotifier.setIntersectionsToFalse();
                                      controlDrawing=true;
                                    }
                                  }

                                }
                              },
                              child:AnimatedBuilder(
                                animation: panAndZoom,
                                builder: (BuildContext context, Widget? child) {
                                  return RepaintBoundary(
                                    key: genKey,
                                    child: InteractiveViewer(
                                        minScale: 1,
                                        maxScale: 25,
                                        panEnabled:panAndZoom.panning,
                                        scaleEnabled: panAndZoom.zooming,
                                        transformationController: _transformationController,
                                        child: AnimatedBuilder(
                                          animation: customPaintNotifier,
                                          builder: (BuildContext context, Widget? child) {
                                            return RepaintBoundary(
                                              child: CustomPaint(
                                                painter: MyCustomPainter(points: customPaintNotifier.points,grid: customPaintNotifier.grid,numberOfSquaresX: widget.numberofsquares_x,numberOfSquaresY: widget.numberofsquares_y,startPoints: startPoints,endPoints: endPoints,centersList: centers,centers: customPaintNotifier.centers,colouring: customPaintNotifier.colouring,selectingPoints: customPaintNotifier.selectingPoints,selecting: customPaintNotifier.pointsToBeSelected[customPaintNotifier.indexOfPoints],checked: customPaintNotifier.checkedPoint,intersectionList: intersections,intersections: customPaintNotifier.intersections,radius: square_side_length_global/2,divideXStart: divideXStart,divideYStart: divideYStart,divideXEnd: divideXEnd,divideYEnd: divideYEnd),
                                              ),
                                            );
                                          },
                                        )
                                    ),
                                  );
                                },
                              )
                          ),
                        ),
                        Material(
                          //borderRadius: const BorderRadius.all(Radius.circular(20)),
                            child: Container(
                                width: width,
                                height: height*0.2,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child:AnimatedBuilder(
                                    animation: selectingPointsNotifier,
                                    builder: (BuildContext context, Widget? child) {
                                      return
                                        selectingPointsNotifier.selectingPoints?Column(
                                          children: [
                                            const SizedBox(height: 5,),
                                            AnimatedBuilder(
                                              animation: drawingNotifier,
                                              builder: (BuildContext context, Widget? child) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    InkWell(
                                                      onTap: (){
                                                        selectingPointsNotifier.setSelectingPointsToTrue();
                                                        customPaintNotifier.setSelectingPointsToTrue();
                                                        customPaintNotifier.setCentersToTrue();
                                                        customPaintNotifier.setIntersectionsToTrue();
                                                        lineOrArc="Line";
                                                        drawingNotifier.setLineToTrue();
                                                        /*final snackBar = SnackBar(
                                              content: const Text('Line is displayed'),
                                              action: SnackBarAction(
                                                label: 'Undo',
                                                onPressed: () {},
                                              ),
                                            );
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
                                                      },
                                                      child: Container(
                                                          alignment: Alignment.center,
                                                          width: 30,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                  color: Colors.black
                                                              )
                                                          ),
                                                          child: CustomPaint(
                                                            painter: LinePainter(selected: drawingNotifier.line),
                                                          )
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: (){
                                                        selectingPointsNotifier.setSelectingPointsToTrue();
                                                        customPaintNotifier.setSelectingPointsToTrue();
                                                        customPaintNotifier.setCentersToTrue();
                                                        customPaintNotifier.setIntersectionsToTrue();
                                                        lineOrArc="Upper curve";
                                                        drawingNotifier.setArcToTrue();
                                                        /*final snackBar = SnackBar(
                                              content: const Text('Upper curve is displayed'),
                                              action: SnackBarAction(
                                                label: 'Undo',
                                                onPressed: () {},
                                              ),
                                            );
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
                                                      },
                                                      child: Container(
                                                          alignment: Alignment.center,
                                                          width: 30,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                  color: Colors.black
                                                              )
                                                          ),
                                                          child: CustomPaint(
                                                            painter: ArcPainter(selected: drawingNotifier.arc),
                                                          )
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: (){
                                                        selectingPointsNotifier.setSelectingPointsToTrue();
                                                        customPaintNotifier.setSelectingPointsToTrue();
                                                        customPaintNotifier.setCentersToTrue();
                                                        customPaintNotifier.setIntersectionsToTrue();
                                                        lineOrArc="Lower curve";
                                                        drawingNotifier.setAntiArcToTrue();
                                                        /*final snackBar = SnackBar(
                                              content: const Text('Lower curve is displayed'),
                                              action: SnackBarAction(
                                                label: 'Undo',
                                                onPressed: () {},
                                              ),
                                            );
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
                                                      },
                                                      child: Container(
                                                          alignment: Alignment.center,
                                                          width: 30,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                  color: Colors.black
                                                              )
                                                          ),
                                                          child: CustomPaint(
                                                            painter: AntiArcPainter(selected: drawingNotifier.antiArc),
                                                          )
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 5,),
                                            const Text("Selecting Point",style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 40),),
                                            const SizedBox(height: 5,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(onPressed: (){selectingPointsNotifier.setSelectingPointsToFalse();customPaintNotifier.setSelectingPointsToFalse();customPaintNotifier.setCentersToFalse();customPaintNotifier.setIntersectionsToFalse();customPaintNotifier.setColouringToFalse();colouringNotifier.setColouringToFalse();drawingNotifier.setAllToFalse();customPaintNotifier.makePointCheckedNull();}, child: const Text("Back",style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)), ),
                                                ElevatedButton(onPressed: (){customPaintNotifier.undo();}, child: const Text("Undo",style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)), ),
                                              ],
                                            ),
                                            /*Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(onPressed: (){
                                      if(customPaintNotifier.indexOfPoints!=0){
                                        customPaintNotifier.decrement();
                                      }
                                    }, icon: const Icon(Icons.arrow_back,color: Colors.black,),iconSize: 50,),
                                      Expanded(child:Slider(
                                      min:1.0,
                                      max:10.0,
                                      activeColor: selectingPointsNotifier.color,
                                      value: selectingPointsNotifier.strokeWidth,
                                      onChanged: (value){
                                        selectingPointsNotifier.changeStrokeWidth(value);
                                      }
                                      )),
                                    IconButton(onPressed: (){
                                      if(customPaintNotifier.indexOfPoints!=customPaintNotifier.pointsToBeSelected.length-1){
                                        customPaintNotifier.increment();
                                      }
                                    }, icon: const Icon(Icons.arrow_forward,color: Colors.black,),iconSize: 50,),
                                  ],
                                ),
                                //const SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(onPressed: (){selectingPointsNotifier.setSelectingPointsToFalse();customPaintNotifier.setSelectingPointsToFalse();customPaintNotifier.setCentersToFalse();}, child: const Text("Back",style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)), ),
                                    const SizedBox(width: 5,),
                                    ElevatedButton(onPressed: (){
                                      if(controlDrawing==true){
                                        customPaintNotifier.makePointChecked(customPaintNotifier.pointsToBeSelected[customPaintNotifier.indexOfPoints]);
                                        controlDrawing=false;
                                      }
                                      else{
                                        Offset temp=Offset(customPaintNotifier.checkedPoint!.dx, customPaintNotifier.checkedPoint!.dy);
                                        customPaintNotifier.addPoint(DrawingArea(
                                            mainPoint: temp,
                                            areaPaint:Paint()
                                              ..strokeCap=StrokeCap.round
                                              ..isAntiAlias=true
                                              ..color=customPaintNotifier.color
                                              ..strokeWidth=selectingPointsNotifier.strokeWidth
                                              ..style=PaintingStyle.stroke
                                            ,
                                            secondaryPoint: customPaintNotifier.pointsToBeSelected[customPaintNotifier.indexOfPoints],
                                            type: lineOrArc,
                                        radius: 300)
                                        );
                                        customPaintNotifier.setSelectingPointsToFalse();
                                        customPaintNotifier.setCentersToFalse();
                                        customPaintNotifier.makePointNull();
                                        selectingPointsNotifier.setSelectingPointsToFalse();
                                        controlDrawing=true;
                                      }
                                    }, child: const Text("Next",style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)), ),
                                  ],
                                ),*/
                                          ],
                                        ):Column(
                                          children: [
                                            const SizedBox(height: 5,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    // Removing or displaying centers
                                                    if(customPaintNotifier.centers==true){
                                                      customPaintNotifier.setCentersToFalse();
                                                      final snackBar = SnackBar(
                                                        content: const Text("Centers are removed"),
                                                        action: SnackBarAction(
                                                          label: 'Undo',
                                                          onPressed: () {},
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                    }else if(customPaintNotifier.centers==false){
                                                      customPaintNotifier.setCentersToTrue();
                                                      final snackBar = SnackBar(
                                                        content: const Text("Centers are displayed"),
                                                        action: SnackBarAction(
                                                          label: 'Undo',
                                                          onPressed: () {},
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                    }
                                                  },
                                                  child: Container(
                                                      alignment: Alignment.center,
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                              color: Colors.black
                                                          )
                                                      ),
                                                      child: CustomPaint(
                                                        painter: DotPainter(),
                                                      )
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    //pointNotifier.setPointToTrue();
                                                    if(customPaintNotifier.intersections==true){
                                                      customPaintNotifier.setIntersectionsToFalse();
                                                    }else if(customPaintNotifier.intersections==false){
                                                      customPaintNotifier.setIntersectionsToTrue();
                                                    }
                                                    /*final snackBar = SnackBar(
                                          content: const Text('Place the point on the canvas'),
                                          action: SnackBarAction(
                                            label: 'Undo',
                                            onPressed: () {},
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
                                                  },
                                                  child: Container(
                                                      alignment: Alignment.center,
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                              color: Colors.black
                                                          )
                                                      ),
                                                      child: CustomPaint(
                                                        painter: PlusPainter(),
                                                      )
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    selectingPointsNotifier.setSelectingPointsToTrue();
                                                    customPaintNotifier.setSelectingPointsToTrue();
                                                    customPaintNotifier.setCentersToTrue();
                                                    customPaintNotifier.setIntersectionsToTrue();
                                                    lineOrArc="Line";
                                                    drawingNotifier.setLineToTrue();
                                                    /*final snackBar = SnackBar(
                                          content: const Text('Line is displayed'),
                                          action: SnackBarAction(
                                            label: 'Undo',
                                            onPressed: () {},
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
                                                  },
                                                  child: Container(
                                                      alignment: Alignment.center,
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                              color: Colors.black
                                                          )
                                                      ),
                                                      child: CustomPaint(
                                                        painter: LinePainter(selected: false),
                                                      )
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    selectingPointsNotifier.setSelectingPointsToTrue();
                                                    customPaintNotifier.setSelectingPointsToTrue();
                                                    customPaintNotifier.setCentersToTrue();
                                                    customPaintNotifier.setIntersectionsToTrue();
                                                    lineOrArc="Upper curve";
                                                    drawingNotifier.setArcToTrue();
                                                    /*final snackBar = SnackBar(
                                          content: const Text('Upper curve is displayed'),
                                          action: SnackBarAction(
                                            label: 'Undo',
                                            onPressed: () {},
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
                                                  },
                                                  child: Container(
                                                      alignment: Alignment.center,
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                              color: Colors.black
                                                          )
                                                      ),
                                                      child: CustomPaint(
                                                        painter: ArcPainter(selected: false),
                                                      )
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    selectingPointsNotifier.setSelectingPointsToTrue();
                                                    customPaintNotifier.setSelectingPointsToTrue();
                                                    customPaintNotifier.setCentersToTrue();
                                                    customPaintNotifier.setIntersectionsToTrue();
                                                    lineOrArc="Lower curve";
                                                    drawingNotifier.setAntiArcToTrue();
                                                    /*final snackBar = SnackBar(
                                          content: const Text('Lower curve is displayed'),
                                          action: SnackBarAction(
                                            label: 'Undo',
                                            onPressed: () {},
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
                                                  },
                                                  child: Container(
                                                      alignment: Alignment.center,
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                              color: Colors.black
                                                          )
                                                      ),
                                                      child: CustomPaint(
                                                        painter: AntiArcPainter(selected: false),
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                InkWell(
                                                  onTap: (){

                                                    if(customPaintNotifier.grid==true){
                                                      customPaintNotifier.setGridToFalse();
                                                      /*final snackBar = SnackBar(
                                            content: const Text('Grid removed'),
                                            action: SnackBarAction(
                                              label: 'Undo',
                                              onPressed: () {},
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
                                                    }else if(customPaintNotifier.grid==false){
                                                      customPaintNotifier.setGridToTrue();
                                                      /*final snackBar = SnackBar(
                                            content: const Text('Grid displayed'),
                                            action: SnackBarAction(
                                              label: 'Undo',
                                              onPressed: () {},
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
                                                    }

                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(20),
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 2
                                                      ),
                                                    ),
                                                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                    alignment: Alignment.center,
                                                    child: const Text("Grid",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    /*AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.INFO_REVERSED,
                                          buttonsBorderRadius: const BorderRadius.all(Radius.circular(2)),
                                          headerAnimationLoop: false,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Confirmation',
                                          desc: 'Are you sure you want to undo this move?',
                                          showCloseIcon: true,
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            customPaintNotifier.undo();
                                          },
                                        ).show();*/
                                                    customPaintNotifier.undo();
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(20),
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 2
                                                      ),
                                                    ),
                                                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                    alignment: Alignment.center,
                                                    child: const Text("Undo",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    AwesomeDialog(
                                                      context: context,
                                                      dialogType: DialogType.INFO_REVERSED,
                                                      buttonsBorderRadius: const BorderRadius.all(Radius.circular(2)),
                                                      headerAnimationLoop: false,
                                                      animType: AnimType.BOTTOMSLIDE,
                                                      title: 'Confirmation',
                                                      desc: 'Are you sure you want to clear all the canvas?',
                                                      showCloseIcon: true,
                                                      btnCancelOnPress: () {},
                                                      btnOkOnPress: () {
                                                        customPaintNotifier.clear();
                                                      },
                                                    ).show();
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(20),
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 2
                                                      ),
                                                    ),
                                                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                    alignment: Alignment.center,
                                                    child: const Text("Clear",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: ()async{
                                                    await takePictureExport();
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(20),
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 2
                                                      ),
                                                    ),
                                                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                    alignment: Alignment.center,
                                                    child: const Text("Export",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                InkWell(
                                                    onTap: (){
                                                      if(panAndZoom.panning==true){
                                                        panAndZoom.setPanToFalse();
                                                        final snackBar = SnackBar(
                                                          content: const Text('Panning deactivated'),
                                                          action: SnackBarAction(
                                                            label: 'Undo',
                                                            onPressed: () {},
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      }else if(panAndZoom.panning==false){
                                                        panAndZoom.setPanToTrue();
                                                        final snackBar = SnackBar(
                                                          content: const Text('Panning activated'),
                                                          action: SnackBarAction(
                                                            label: 'Undo',
                                                            onPressed: () {},
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      }

                                                    },
                                                    child:AnimatedBuilder(
                                                      animation: panAndZoom, builder: (BuildContext context, Widget? child) {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          color:panAndZoom.panning?Colors.black:Colors.white,
                                                          borderRadius: BorderRadius.circular(20),
                                                          border: Border.all(
                                                              color: Colors.black,
                                                              width: 2
                                                          ),
                                                        ),
                                                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                        alignment: Alignment.center,
                                                        child: Text("Panning",style: TextStyle(color: panAndZoom.panning?Colors.white:Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                                                      );
                                                    },
                                                    )


                                                ),
                                                InkWell(
                                                    onTap: (){
                                                      if(panAndZoom.zooming==true){
                                                        panAndZoom.setZoomToFalse();
                                                        zoomNotifier.setZoomToFalse();
                                                        final snackBar = SnackBar(
                                                          content: const Text('Zooming deactivated'),
                                                          action: SnackBarAction(
                                                            label: 'Undo',
                                                            onPressed: () {},
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      }else if(panAndZoom.zooming==false){
                                                        panAndZoom.setZoomToTrue();
                                                        zoomNotifier.setZoomToTrue();
                                                        final snackBar = SnackBar(
                                                          content: const Text('Zooming activated'),
                                                          action: SnackBarAction(
                                                            label: 'Undo',
                                                            onPressed: () {},
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      }
                                                    },
                                                    child:AnimatedBuilder(
                                                      animation: zoomNotifier, builder: (BuildContext context, Widget? child)
                                                    {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          color: zoomNotifier.zooming?Colors.black:Colors.white,
                                                          borderRadius: BorderRadius.circular(20),
                                                          border: Border.all(
                                                              color: Colors.black,
                                                              width: 2
                                                          ),
                                                        ),
                                                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                        alignment: Alignment.center,
                                                        child: Text("Zooming",style: TextStyle(color:zoomNotifier.zooming?Colors.white:Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                                                      );
                                                    },
                                                    )


                                                ),
                                                InkWell(
                                                    onTap: () async{
                                                      //Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> const MyColouringPage()));
                                                      await takePicture();
                                                      /*selectingPointsNotifier.setSelectingPointsToTrue();
                                          customPaintNotifier.setSelectingPointsToTrue();
                                          colouringNotifier.setColouringToTrue();
                                          customPaintNotifier.setColouringToTrue();*/

                                                      /*if(customPaintNotifier.colouring==true){
                                            customPaintNotifier.setColouringToFalse();
                                            colouringNotifier.setColouringToFalse();
                                            final snackBar = SnackBar(
                                              content: const Text('Colouring deactivated'),
                                              action: SnackBarAction(
                                                label: 'Undo',
                                                onPressed: () {},
                                              ),
                                            );
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          }else if(customPaintNotifier.colouring==false){
                                            customPaintNotifier.setColouringToTrue();
                                            colouringNotifier.setColouringToTrue();
                                            final snackBar = SnackBar(
                                              content: const Text('Colouring activated'),
                                              action: SnackBarAction(
                                                label: 'Undo',
                                                onPressed: () {},
                                              ),
                                            );
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          }*/
                                                    },
                                                    child: AnimatedBuilder(
                                                      animation: colouringNotifier,
                                                      builder: (BuildContext context, Widget? child) {
                                                        return Container(
                                                          decoration: BoxDecoration(
                                                            color:colouringNotifier.colouring?Colors.black:Colors.white,
                                                            borderRadius: BorderRadius.circular(20),
                                                            border: Border.all(
                                                                color: Colors.black,
                                                                width: 2
                                                            ),
                                                          ),
                                                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                          alignment: Alignment.center,
                                                          child: Text("Colouring",style: TextStyle(color:colouringNotifier.colouring?Colors.white:Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                                                        );
                                                      },
                                                    )
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                    }
                                )
                            )
                        )
                      ]
                  )
              )
            ]
        ),
      ),
    );
  }
}
