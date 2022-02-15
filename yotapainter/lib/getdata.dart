import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yotapainter/custom_paint.dart';

class GetData extends StatefulWidget {
  const GetData({Key? key}) : super(key: key);

  @override
  _GetDataState createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {
  late double width,height;
  TextEditingController widthController=TextEditingController(),heightController=TextEditingController();

  @override
  void dispose() {
    widthController.dispose();
    heightController.dispose();
    // TODO: implement dispose
    super.dispose();
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
        margin: EdgeInsets.fromLTRB(width*0.1, height*0.1,width*0.1, height*0.1),
        child: Column(
          children: [
            Material(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                margin: const EdgeInsets.all(15),
                child: TextFormField(

                  controller: widthController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),
                  decoration: const InputDecoration(
                    labelText: "Width *"
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Material(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                margin: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: heightController,

                  onFieldSubmitted: (value){
                    double numberOfSquaresX=3,numberOfSquaresY=3;
                    String width=widthController.text,height=value;
                    if(width.isEmpty){
                      numberOfSquaresX=3;
                    }else{

                      if(width.contains("+")){
                        Fluttertoast.showToast(
                            msg: "This is Center Short Toast",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }

                    }
                    if(height.isEmpty){
                      numberOfSquaresY=3;
                    }else{
                      numberOfSquaresY=double.parse(height);
                    }
                    Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>  CustomPaintPage(numberofsquares_y: numberOfSquaresY, numberofsquares_x: numberOfSquaresX,name: "",list: [],)));
                  },
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                  ),

                  decoration: const InputDecoration(
                      labelText: "Height *"
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Container(margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),child: const Text("If you don't enter any values the defaults will be three.",style: TextStyle(fontSize: 15,color: Colors.black,decoration: TextDecoration.none))),
            Container(margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),child: const Text("In the canvas there will be more squares than you specified don't worry it is not an error it is done on purpose.",style: TextStyle(fontSize: 15,color: Colors.black,decoration: TextDecoration.none))),
            ElevatedButton(
                onPressed: (){

                  double numberOfSquaresX=3,numberOfSquaresY=3;
                  String width=widthController.text,height=heightController.text;
                  if(width.isEmpty){
                    numberOfSquaresX=3;
                  }else{
                    numberOfSquaresX=double.parse(width);
                  }
                  if(height.isEmpty){
                    numberOfSquaresY=3;
                  }else{
                    numberOfSquaresY=double.parse(height);
                  }
                  Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>  CustomPaintPage(numberofsquares_y: numberOfSquaresY, numberofsquares_x: numberOfSquaresX,list: [],name: "",)));
                },
                child: const Text(
                  "Begin"
                ))
          ],
        ),
      ),
    );
  }
}
