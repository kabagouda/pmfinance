import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pmfinance/src/utils/size_utils.dart';

import '../gen/assets.gen.dart';
import 'components/base_widget.dart';
import 'home_page.dart';
import 'utils/app_buttons.dart';
import 'utils/app_colors.dart';
import 'utils/app_text_styles.dart';

class OnboardingPage extends StatefulWidget {
  static const route = '/';

  /// Static method to return the widget as a PageRoute
  static Route go() => MaterialPageRoute<void>(builder: (_) => const OnboardingPage());
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  CarouselController buttonCarouselController = CarouselController();
  int _current = 0;
  List<OnboardingSliderModel> listOfImageAndDescription = [
    OnboardingSliderModel(
        title: 'Terrains à Vendre',
        image: Assets.images.terrain.path,
        description:
            "Découvrez notre sélection de terrains disponibles à la vente. Trouvez l'endroit idéal pour construire votre maison de rêve."),
    OnboardingSliderModel(
        title: 'Immobilier à Vendre',
        image: Assets.images.immobilier.path,
        description:
            "Parcourez notre sélection de terrains prêts à être construits. Profitez de cette opportunité pour réaliser votre projet immobilier."),
    OnboardingSliderModel(
        title: 'Agent Immobilier',
        image: Assets.images.agent.path,
        description:
            "Faites appel à nos agents immobiliers expérimentés pour vous accompagner dans l'achat ou la vente de votre propriété."),
  ];
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      showTitle: false,
      withVerticalPadding: false,
      usePoppins: true,
      onSkip: () {
        context.goNamed(HomePage.route);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            carouselController: buttonCarouselController,
            options: CarouselOptions(
                height: getVerticalSize(609),
                viewportFraction: 1.0,
                autoPlay: false,
                onPageChanged: (index, reason) => {
                      setState(() {
                        _current = index;
                      })
                    }),
            items: listOfImageAndDescription.map((element) {
              return Builder(
                builder: (BuildContext context) {
                  return Column(
                    children: [
                      SizedBox(
                          width: getHorizontalSize(454),
                          height: getVerticalSize(401),
                          child: Image.asset(element.image)),
                      SizedBox(
                        height: getVerticalSize(12),
                      ),
                      Text(element.title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.title(fontSize: getFontSize(28), usePoppins: true)),
                      SizedBox(
                        height: getVerticalSize(6),
                      ),
                      SizedBox(
                        child: Text(element.description,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body(
                                color: AppColors.black, fontSize: getFontSize(18), usePoppins: true)),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(
            height: getVerticalSize(20),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: indicators(listOfImageAndDescription.length, _current)),
          SizedBox(
            height: getVerticalSize(40),
          ),
          Align(
            alignment: Alignment.center,
            child: AppButtons.textButton(
                text: _current < listOfImageAndDescription.length - 1 ? 'Suivant' : 'Commencer',
                textStyle: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: getFontSize(14),
                  ),
                ),
                actions: const FaIcon(FontAwesomeIcons.chevronRight, color: Colors.black, size: 8),
                onPressed: () {
                  setState(() {
                    if (_current < listOfImageAndDescription.length - 1) {
                      buttonCarouselController.nextPage();
                    } else {
                      context.goNamed(HomePage.route);
                    }
                  });
                }),
          )
        ],
      ),
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: const EdgeInsets.all(3),
        width: currentIndex == index ? 20 : 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.blue : Colors.black26,
            borderRadius: currentIndex == index ? BorderRadius.circular(30) : null,
            shape: currentIndex == index ? BoxShape.rectangle : BoxShape.circle),
      );
    });
  }
}

class OnboardingSliderModel {
  final String title;
  final String description;
  final String image;
  void Function()? onNextButtonPressed;
  bool? defautText;
  OnboardingSliderModel(
      {required this.title,
      required this.description,
      required this.image,
      // required this.onNextButtonPressed,
      this.onNextButtonPressed,
      this.defautText = true});
}
