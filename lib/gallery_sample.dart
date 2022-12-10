import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
// @dart=2.9
void main() {

  runApp(SamplePage());
}

class SamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gallery Image Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  // final title;

  const MyHomePage({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Tap to show image"),
              GalleryImage(
                numOfShowImages: 5,
                imageUrls: [

                  "https://firebasestorage.googleapis.com/v0/b/team-project-398aa.appspot.com/o/albums%2FJeju%2Ffiles%2Fimage_picker369383661221344585.jpg%2Ffile?alt=media&token=83cbecc3-ee33-41b1-b46c-daccf8fd2aeb",

                  "https://firebasestorage.googleapis.com/v0/b/team-project-398aa.appspot.com/o/albums%2FJeju%2Ffiles%2Fimage_picker7290132427671111578.jpg%2Ffile?alt=media&token=cd8fbf7a-e0de-43fa-aea5-0afb14c3a8b8",
                  "https://scx2.b-cdn.net/gfx/news/hires/2019/2-nature.jpg",
                  "https://isha.sadhguru.org/blog/wp-content/uploads/2016/05/natures-temples.jpg",
                  "https://upload.wikimedia.org/wikipedia/commons/7/77/Big_Nature_%28155420955%29.jpeg",
                  "https://s23574.pcdn.co/wp-content/uploads/Singular-1140x703.jpg",
                  "https://www.expatica.com/app/uploads/sites/9/2017/06/Lake-Oeschinen-1200x675.jpg"
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}