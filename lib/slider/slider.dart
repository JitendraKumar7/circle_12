import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var items = ['1', '2', '3', '4', '5', '6'];
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CarouselSlider(
              items: items
                  .map((e) => Image.asset(
                        'assets/slider/$e.png',
                        height: size.height,
                        width: size.width,
                        fit: BoxFit.fill,
                      ))
                  .toList(),
              options: CarouselOptions(
                height: size.height,
                viewportFraction: 1,
                autoPlay: true,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
              ),
            ),
            Align(
              alignment: Alignment(0.9, 0.95),
              child: ElevatedButton(
                onPressed: () {
                  //Navigator.pushNamed(context, LOGIN);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text('Skip'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
