import 'package:flutter/material.dart';


class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How to use our app?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '   Disoroath helps you classify and diagnose throat photos using machine learning. It can assist you whether you take the photos yourself or with the help of someone else, either by capturing new photos or selecting them from your gallery. To aid in capturing the photo, you can enable the mouth grid. When taking a photo on your own, you can position yourself in front of a mirror with the phone upside down and use the rear camera, as shown in Figure 1.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Image.asset("images/howto.jpg",scale: 1,),

              Text(
                'User Terms and Conditions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '   By sending photos through this application, you are deemed to have automatically accepted the terms and conditions. This application processes the photos you send through machine learning and provides a result. It does not store your photos or use them for training the machine learning model unless you explicitly authorize it. The photos you see in your own reports are sourced from your device''s gallery.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}