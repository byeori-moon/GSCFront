import 'package:camera_pj/screen/camera_screen.dart';
import 'package:camera_pj/screen/register_capture_screen.dart';
import 'package:flutter/material.dart';

class BeforeDartCamera extends StatefulWidget {
  const BeforeDartCamera({super.key});

  @override
  State<BeforeDartCamera> createState() => _BeforeDartCameraState();
}

class _BeforeDartCameraState extends State<BeforeDartCamera> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFDAF0FF),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9, // 화면의 가로 90%에 해당하는 너비
            height: MediaQuery.of(context).size.height * 0.85, // 화면의 세로 90%에 해당하는 높이
            decoration:  ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
            ),
            child: Column(
              children: [


                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8*0.03
                ),
              Center(
                child:Row(

                  children: [
                    // 이미지 위젯
                    Image.asset(
                      'asset/img/penguin_detective.png', // 이미지 파일 경로
                      width: MediaQuery.of(context).size.width * 0.3, // 화면의 가로 90%에 해당하는 너비
                      height: MediaQuery.of(context).size.height * 0.8*0.2,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8*0.2,
                      child: Text(
                        'PROTECT\nYOUR SPACE',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF97ACB8),
                          fontSize: 35,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'OHSQUARE'
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8*0.03
                ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8*0.35,
                  child: Text(
                      'When you capture your space or object:\n\n1) The AI identifies fire risks.\n2) The AI analyzes the risk.\n3) The AI evaluates the risk.\n\nNOTE: AI results will be saved in your space.\n\n*example image*',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'OHSQUAREAIR',
                        fontWeight: FontWeight.w300,
                      ),
                  ),
                ),
                SizedBox(

                  child: Image.asset(
                    'asset/img/example_img.png', // 이미지 파일 경로
                    width: MediaQuery.of(context).size.width * 0.5, // 화면의 가로 90%에 해당하는 너비
                    fit: BoxFit.contain, // 이미지를 적절히 화면에 맞게 조절
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8*0.03
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        CameraView()
                    ));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8 * 0.1,
                    width: MediaQuery.of(context).size.width * 0.8, // 화면의 가로 90%에 해당하는 너비
                    decoration: ShapeDecoration(
                      color: Color(0xFF97ACB8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Take a Picture',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFFEFDF8),
                            fontSize: 18,
                            fontFamily: 'OHSQUARE',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ) // 원하는 내용을 추가하세요
          ),
        ),
      ),
    );
  }
}
