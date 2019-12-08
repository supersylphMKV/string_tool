import 'dart:ffi';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:text_scan/stringCalculation.dart';

class CameraInput extends StatefulWidget {
  @override
  _CameraInputState createState() => _CameraInputState();
}

class _CameraInputState extends State<CameraInput> {
  CameraController controller;
  Size mediaSize;
  List<Widget> textLabels = [
    Container(
      margin: EdgeInsets.only(top: 500, left: 20),
      child: Text(''),
    )
  ];
  
  Future _initCameraController(CameraDescription cameraDescription)async{
    if(controller != null){
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener((){
      if(mounted){

      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }

    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState(){
    super.initState();

    availableCameras().then((cameras){
      if(cameras.length > 0){
        _initCameraController(cameras[0]).then((v){
          
        });
      } else {
        print('No Camera available');
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.mediaSize = MediaQuery.of(context).size;
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }
    return buildBody();
  }

  Widget buildBody(){
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        AspectRatio(
          aspectRatio:
          controller.value.aspectRatio,
          child: CameraPreview(controller)
        ),
        AspectRatio(
          aspectRatio:
          controller.value.aspectRatio,
          child: Stack(
            fit: StackFit.expand,
            children: textLabels
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.camera),
            onPressed: ()async{
              List<Widget> lbls = [];
              Directory dirPath = await getTemporaryDirectory();
              String path = join(dirPath.path, 'test.png');
              File imageFile = File(path);
              if(await imageFile.exists()){
                await imageFile.delete();
              }
              await controller.takePicture(path);
              FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
              TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
              VisionText visionText = await textRecognizer.processImage(visionImage);
              
              for(TextBlock block in visionText.blocks){
                StringResult text = await readText(block.text);
                double top = block.boundingBox.top * (mediaSize.height/controller.value.previewSize.width);
                double left = block.boundingBox.left * (mediaSize.width/controller.value.previewSize.height);
                //print(block.boundingBox);
                //print(text.result);
                //print(top);
                //print(left);
                
                lbls.add(Container(
                  margin: EdgeInsets.only(top: top, left: left),
                  child: Text(text.result,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.white.withAlpha(100)
                    ),
                  ),
                ));
              }
              setState(() {
                textLabels = lbls;
                //print(textLabels.length);
              });
              textRecognizer.close();
              await imageFile.delete();
            },
          ),
          bottomNavigationBar: SizedBox(height: 48,),
        )
      ],
    );
  }
}