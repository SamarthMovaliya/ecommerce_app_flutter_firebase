import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../models/resources.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    print(currentPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('logSignPage');
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 12,
            child: Center(
              child: CarouselSlider(
                  carouselController: carouselController,
                  items: viewPage
                      .map(
                        (e) => Column(
                          children: [
                            const Spacer(),
                            Expanded(
                              flex: 4,
                              child: Transform.scale(
                                scale: 0.9,
                                child: Image.asset(
                                  e['image'],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    e['Title'],
                                    style: const TextStyle(
                                      letterSpacing: 1.1,
                                      wordSpacing: 2,
                                      height: 1.4,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  e['desc'],
                                  style: const TextStyle(
                                    wordSpacing: 2,
                                    height: 1.4,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                  options: CarouselOptions(
                    height: 800,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1,
                    initialPage: currentPage,
                    enableInfiniteScroll: true,
                    reverse: false,
                    pauseAutoPlayOnManualNavigate: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    onPageChanged: (val, _) async {
                      setState(() {
                        currentPage = val;
                      });
                      if (currentPage == 2) {
                        await Future.delayed(
                          const Duration(seconds: 2),
                          () {
                            return Navigator.pushReplacementNamed(
                              context,
                              'logSignPage',
                            );
                          },
                        );
                      }
                    },
                    scrollDirection: Axis.horizontal,
                  )),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: viewPage
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              setState(() {
                                carouselController.animateToPage(e,
                                    duration: const Duration(seconds: 0),
                                    curve: Curves.decelerate);
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  (currentPage == viewPage.indexOf(e))
                                      ? Colors.red
                                      : Colors.grey,
                              radius:
                                  (currentPage == viewPage.indexOf(e)) ? 6 : 3,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (currentPage < 2) {
                        currentPage++;
                      } else {
                        Navigator.pushReplacementNamed(context, 'logSignPage');
                        currentPage == 0;
                      }
                    });
                  },
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.red,
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
