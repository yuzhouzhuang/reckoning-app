//import 'dart:io';
//
//import 'package:flutter/material.dart';
//import 'package:firebase_ml_vision/firebase_ml_vision.dart';
//import 'package:flutterApp/arguments/event_page_argument.dart';
//import 'package:flutterApp/theme.dart';
//import 'package:flutterApp/widgets/widgets.dart';
//
//class InvitePage extends StatefulWidget {
//  static const routeName = '/invitePage';
//
//  @override
//  _InvitePageState createState() => _InvitePageState();
//}
//
//class _InvitePageState extends State<InvitePage> {
//  File image;
//
//
////  @override
////  initState() {
////    super.initState();
////    asyncInitState().then((result) {
////      print("result: $result");
////      setState(() {});
////    });
////  }
//
//  void asyncOCR() async {
//    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
//    final TextRecognizer textRecognizer =
//        FirebaseVision.instance.textRecognizer();
//    final VisionText visionText =
//        await textRecognizer.processImage(visionImage);
//    String text = visionText.text;
////    print(text);
//    for (TextBlock block in visionText.blocks) {
//      print('***');
//      final Rect boundingBox = block.boundingBox;
//      final List<Offset> cornerPoints = block.cornerPoints;
//      final String text = block.text;
//      final List<RecognizedLanguage> languages = block.recognizedLanguages;
//
////      print(text);
//      for (TextLine line in block.lines) {
//        // Same getters as TextBlock
//        print('******');
//        final Rect boundingBox = line.boundingBox;
//        final List<Offset> cornerPoints = line.cornerPoints;
//        final String text = line.text;
//        final List<RecognizedLanguage> languages = line.recognizedLanguages;
//        print(text);
//        for (TextElement element in line.elements) {
//          // Same getters as TextBlock
////          print('*********');
////          final Rect boundingBox = element.boundingBox;
////          final List<Offset> cornerPoints = element.cornerPoints;
////          final String text = element.text;
////          final List<RecognizedLanguage> languages = element.recognizedLanguages;
////          print(text);
//        }
//      }
//    }
//    textRecognizer.close();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final EventPageArgument args = ModalRoute.of(context).settings.arguments;
//    image = args.image;
//
//    return Scaffold(
//      backgroundColor: Colors.white,
//      appBar: AppBar(
//        leading: IconButton(
//          icon: Container(
//            padding: const EdgeInsets.all(10),
//            decoration: BoxDecoration(
//              borderRadius: const BorderRadius.all(Radius.circular(20)),
//              color: MyColors.primaryColorLight.withAlpha(20),
//            ),
//            child: Icon(
//              Icons.arrow_back_ios,
//              color: MyColors.primaryColor,
//              size: 16,
//            ),
//          ),
//          onPressed: () => Navigator.of(context).pop(),
//        ),
//        title: Text(
//          'Invite ',
//          style: TextStyle(color: Colors.black),
//        ),
//        elevation: 0,
//        backgroundColor: Colors.white,
//        brightness: Brightness.light,
//      ),
//      body: Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: SingleChildScrollView(
//          child: Column(
//            children: <Widget>[
//              SelectChip(),
//              SelectChip(),
//              SelectChip(),
//              SelectChip(),
//              SelectChip(),
//              SelectChip(),
//              SelectChip(),
//              SelectChip(),
//              SelectChip(),
//              Container(
//                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                constraints: const BoxConstraints(maxWidth: 500),
//                child: RaisedButton(
//                  onPressed: () {
//                    asyncOCR();
////                BlocProvider.of<AuthBloc>(context).add(AuthEventValidatePhoneNumber(smsCode: _pinPutController.text));
//                  },
//                  color: MyColors.primaryColor,
//                  shape: const RoundedRectangleBorder(
//                      borderRadius: BorderRadius.all(Radius.circular(14))),
//                  child: Container(
//                    padding:
//                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Text(
//                          'Create Event',
//                          style: TextStyle(color: Colors.white),
//                        ),
//                        Container(
//                          padding: const EdgeInsets.all(8),
//                          decoration: BoxDecoration(
//                            borderRadius:
//                                const BorderRadius.all(Radius.circular(20)),
//                            color: MyColors.primaryColorLight,
//                          ),
//                          child: Icon(
//                            Icons.arrow_forward_ios,
//                            color: Colors.white,
//                            size: 16,
//                          ),
//                        )
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
