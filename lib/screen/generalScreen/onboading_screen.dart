import 'package:calculator_app/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:lottie/lottie.dart';

import '../calculator/main_screen.dart';
import '../calculator/scientific_calculator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                autoPlay: false,
                autoPlayInterval: const Duration(seconds: 4),
                enlargeCenterPage: true,
                // aspectRatio: 6 / 10,
                aspectRatio: 6 / 10,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index; // Update the current index
                  });
                },
              ),
              items: [
                OnboardingPage(
                  sizedBoxHeightAbove: 2.w,
                  sizedBoxHeight: 15.w,
                  imagepath: 'assets/lottie/animation_ln1na6wb.json',
                  title: StringUtils.titleOneOnboarding,
                  description: StringUtils.descriptionOneOnboarding,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/appScreenshot.png',
                      height: Get.height / 2,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 5.w,
                    ),
                    Text(
                      StringUtils.titleTwoOnboarding,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.w),
                    Text(
                      StringUtils.descriptionTwoOnboarding,
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                OnboardingPage(
                  imagepath: 'assets/lottie/animation_ln1pdz3d.json',
                  sizedBoxHeight: 5.w,
                  title: StringUtils.titleThreeOnboarding,
                  description: StringUtils.titleThreeOnboarding,
                ),
              ],
            ),
          ),
          CustomDotIndicator(
            itemCount: 3,
            currentIndex: _currentIndex,
          ),
          Center(
            child: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                return TextButton(
                  onPressed: () {
                    if (_currentIndex == 0 || _currentIndex == 1) {
                      setState(() {
                        _currentIndex++;
                      });
                      _carouselController.nextPage();
                    } else {
                      if (MediaQuery.of(context).orientation ==
                          Orientation.portrait) {
                        Get.offAll(() => const MainScreen());
                      } else {
                        Get.offAll(() => const ScientificCalculator());
                      }
                    }
                  },
                  child: Text(
                    _currentIndex == 0 || _currentIndex == 1 ? "Skip" : 'Done',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String? imagepath;
  final double? sizedBoxHeight;
  final double? sizedBoxHeightAbove;

  const OnboardingPage(
      {super.key,
      required this.title,
      required this.description,
      this.imagepath,
      this.sizedBoxHeight,
      this.sizedBoxHeightAbove});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: sizedBoxHeightAbove,
        ),
        Lottie.asset(
          imagepath ?? 'assets/lottie/animation_ln1mzksd.json',
          fit: BoxFit.cover,
        ),
        SizedBox(height: sizedBoxHeight ?? 1.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          description,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class CustomDotIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const CustomDotIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return Container(
          margin: const EdgeInsets.all(4.0),
          width: (index == currentIndex) ? 29 : 14,
          height: 6.0,
          decoration: BoxDecoration(
            color: (index == currentIndex) ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      }),
    );
  }
}
