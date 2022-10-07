import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:thought_bin/Intro/IntroScreen1.dart';
import 'package:thought_bin/ReUse.dart';

class IntroScreenWidgets extends StatelessWidget {
  final _controller = PageController();

  IntroScreenWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: _controller,
          children: const [
            IntroScreen1(),
            IntroScreen2(),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: SmoothPageIndicator(
                  effect: WormEffect(activeDotColor: ColorClass().themeColor2),
                  controller: _controller,
                  count: 2,
                  onDotClicked: (index) => _controller.animateToPage(index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.bounceOut),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            )
          ],
        ),
      ],
    ));
  }
}
