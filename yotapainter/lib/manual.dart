import 'package:flutter/material.dart';

import 'Painters/antiarcpainter.dart';
import 'Painters/arcpainter.dart';
import 'Painters/dotpainter.dart';
import 'Painters/linepainter.dart';
import 'Painters/pluspainter.dart';


class ManualPage extends StatelessWidget {
  late double width,height;

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
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                      Material(color: Colors.white,child: Icon(Icons.color_lens)),
                      SizedBox(width: 5,),
                      Material(color: Colors.white,child: Icon(Icons.arrow_forward)),
                      Text(" Pick color",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.none,fontFamily: "serif")),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
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
                    const SizedBox(width: 5,),
                    const Material(color: Colors.white,child: Icon(Icons.arrow_forward)),
                    const Text(" Centers",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.none,fontFamily: "serif")),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(" Shows centers of the squares off or on",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.none,fontFamily: "serif")),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
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
                    const SizedBox(width: 5,),
                    const Material(color: Colors.white,child: Icon(Icons.arrow_forward)),
                    const Text(" Intersections",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.none,fontFamily: "serif")),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(" Shows intersections of the lines off or on",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.none,fontFamily: "serif")),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
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
                    const SizedBox(width: 5,),
                    const Material(color: Colors.white,child: Icon(Icons.arrow_forward)),
                    const Text(" Line",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.none,fontFamily: "serif")),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(" Enable you to select two points from the canvas to draw a line",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.none,fontFamily: "serif")),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
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
                    const SizedBox(width: 5,),
                    const Material(color: Colors.white,child: Icon(Icons.arrow_forward)),
                    const Text(" Upper curve",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.none,fontFamily: "serif")),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(" Enable you to select two points from the canvas to draw a curve from the upper side",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.none,fontFamily: "serif")),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
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
                    const SizedBox(width: 5,),
                    const Material(color: Colors.white,child: Icon(Icons.arrow_forward)),
                    const Text(" Lower curve",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.none,fontFamily: "serif")),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(" Enable you to select two points from the canvas to draw a curve from the lower side",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.none,fontFamily: "serif")),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
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
                      child: const Text("Grid",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: "serif"),),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(" Shows the grid system off and on",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.none,fontFamily: "serif")),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
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
                      child: const Text("Undo",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: "serif"),),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(" Removes the last move you have made",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.none,fontFamily: "serif")),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
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
                      child: const Text("Clear",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: "serif"),),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(" Clear all the the canvas",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.none,fontFamily: "serif")),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
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
                      child: const Text("Export",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: "serif"),),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(" Saves your painting in the external memory",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.none,fontFamily: "serif")),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
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
                      child: const Text("Panning",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: "serif"),),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(" Enable or disable panning, panning means that you can move the screen when zooming in",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.none,fontFamily: "serif")),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
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
                      child: const Text("Zooming",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: "serif"),),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(" Enables or disable zooming",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.none,fontFamily: "serif")),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
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
                      child: const Text("Colouring",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: "serif"),),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(" Enables or disable colouring mode",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.none,fontFamily: "serif")),
              ),
              const Divider(),
            ],
          ),
        ),
      );
  }
}