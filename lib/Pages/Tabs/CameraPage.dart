import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gokhan/Pages/PhotoSend.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image/image.dart' as img;
import 'package:perfect_volume_control/perfect_volume_control.dart';



class CameraPage extends StatefulWidget {
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late List<CameraDescription> cameras;
  CameraController? cameraController;
  late     StreamSubscription<double>? _subscription;
  double _currentVolume = 0.0;
  var visible = false;
  var  isDark ;
  bool isFlashOn = false;

  late File imageFile;

  Future<File> _pickImageFromGallery() async {
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        imageFile = File(pickedImage.path);
      }
    });
    return imageFile;
  }


  Future<void> rotateAndSaveImage(String imagePath) async {
    final img.Image? image = img.decodeImage(await File(imagePath).readAsBytes());
    if (image != null) {
      final String rotatedImagePath = imagePath; // Overwrite the original image
      await GallerySaver.saveImage(rotatedImagePath);
      print("Rotated picture saved to $rotatedImagePath");
    }
  }

  int direction = 0;

  void startCamera(int direction) async {
    cameras = await availableCameras();

    cameraController = CameraController(
      cameras[direction],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }

      cameraController!.setFocusMode(FocusMode.auto);

      setState(() {}); //To refresh widget
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();

  }

  @override
  void initState() {
    startCamera(direction);
    _subscription = PerfectVolumeControl.stream.listen((value) {

      capturePhoto();

    });

  }

  Future<void> capturePhoto() async {
    if (cameraController!.value.isInitialized) {
      try {
        // Ensure flash is off before capturing a photo
        cameraController!.setFlashMode(FlashMode.off);

        final image = await cameraController!.takePicture();
        final String imagePath = image.path;
        await rotateAndSaveImage(imagePath);
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoSend(imageFile: File(imagePath)),
            ),
          );
        });
      } catch (e) {
        print('Error taking picture: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    isDark = MediaQuery.of(context).platformBrightness==Brightness.dark;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    if (cameraController!.value.isInitialized) {
      return Scaffold(
        body: GestureDetector(
          onDoubleTap: (){
            setState(() {
              direction = direction == 0 ? 1 : 0;
              startCamera(direction);
            });
          },
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: width,
                  height: height,
                  child: CameraPreview(cameraController!),
                ),
              ),
              visible
                  ? Center(
                child: Image.asset(
                  'images/mt2.png',
                  width: width / 3,
                  height: height / 3,
                ),
              )
                  : SizedBox(),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left:width/20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              visible = !visible;
                            });
                          },
                          child: button(Icons.add_photo_alternate_outlined,  width),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(left: width/15),
                          child: GestureDetector(
                            onLongPress: (){

                            },
                            onTap: capturePhoto,
                            child: button(Icons.camera_alt_outlined,   width),
                          ),
                        ),


                      ],
                    ),
                  )
                ],
              ),


            ],
          ),
        ),floatingActionButton: Padding(
          padding:  EdgeInsets.only(right: width/20.0,bottom: width/55),
          child: SpeedDial(
          animatedIcon:AnimatedIcons.menu_close,
          icon:Icons.arrow_upward,
          backgroundColor: isDark? Colors.white24:Colors.deepPurpleAccent,

          buttonSize: width/6,

          //animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
                onTap: () {
                  setState(() {
                    isFlashOn = !isFlashOn; // Flash durumunu tersine çevir

                    if (isFlashOn) {
                      cameraController!.setFlashMode(FlashMode.torch); // Flash'ı aç
                    } else {
                      cameraController!.setFlashMode(FlashMode.off); // Flash'ı kapat
                    }
                  });
                },
                child: Icon(
                  isFlashOn ? Icons.flash_on : Icons.flash_off, // Flash durumuna göre farklı bir ikon kullan
                ),
                backgroundColor: isDark? Colors.white24:Colors.yellowAccent,
                label: "open flash"
            )


            , SpeedDialChild(
                onTap: (){
                  _pickImageFromGallery().then((value) {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            PhotoSend(imageFile: value)),
                      );
                    });
                  }
                  );},
                backgroundColor: isDark? Colors.white24:Colors.yellowAccent,
              child:Icon(Icons.add_circle)
                ,label: "select photo"
            ),
            SpeedDialChild(
              onTap: () {
                setState(() {
                  direction = direction == 0 ? 1 : 0;
                  startCamera(direction);
                });
              },
              child: Icon(Icons.flip_camera_ios_outlined),
                label: "change camera",

              backgroundColor: isDark? Colors.white24:Colors.yellowAccent,

            )
          ],
      ),
        ),


);
    } else {
      return const SizedBox();
    }
  }

  Widget button(IconData icon, var width) {
    return Align(

      child: Container(
        margin: const EdgeInsets.only(
          left: 20,
          bottom: 20,
          right: 20,
        ),
        height: width / 6,
        width: width / 6,
        decoration:  BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.white24:Colors.deepPurpleAccent,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.white24:Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
