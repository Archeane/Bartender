import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:home_bartender/screens/mybar_screen.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushNamed(
      MyBarScreen.routeName,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Add ingredients you have",
          image: _buildImage('mybar-guide-1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Spirits",
          body:
              "Spirits are hard alcohol made by distillation, usually as the base\nEssential Spirits: Vodka, Gin, Rum, Whiskey, Tequila",
          image: _buildImage('spirit.jpeg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Liqueurs",
          body: "Liqueurs are alcohols that adds flavour on top of Spirits (usually sweet)\nEssentials: Triple Sec, Ginger Beer, Maraschino, Cointreau, St-Germain", 
          image: _buildImage('liqueur3.jpg'),
        ),
        PageViewModel(
          title: "Mixers",
          bodyWidget: Wrap(children: [
              const Text("These are non-alcoholic ingredients that will help dilute the drink and add some extra nice flavors.", 
              style: bodyStyle, textAlign: TextAlign.center,),
              Container(
                child:_buildImage('mixer.png'),
                padding: const EdgeInsets.symmetric(vertical: 1),
              ),
              const Text("You can get: \n1. Simple Syrup (Can be homemade with just sugar and water)\n2. Any type of Juice(orange, pineapple)\n3. Soda like Coke or Club soda", style: bodyStyle)
            ]),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 4,
            bodyAlignment: Alignment(0, -0.5),
            // imageAlignment: Alignment.topCenter,
          ),
        ),
        PageViewModel(
          title: "Bitters",
          body:
              "Bitters are strongly flavoured alcohol ranging from citrusy, spicy to, well, bitter. Think of them like seasoning - in small doeses, a way to flavor a recipe\n\n Some classics are Angostura, Orange, Peychaud's Bitters",
          image: _buildImage('bitters.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Condiments",
          body: "Finishers that perfects your cocktails! Essentials: Lemon, Lime, Sugar & Mint leaves",
          image: _buildImage('c.jpg'),
          footer: ElevatedButton(
            onPressed: () => _onIntroEnd(context),
            child: const Text(
              "Let's get Started!",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Title of last page - reversed",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Click on ", style: bodyStyle),
              Icon(Icons.edit),
              Text(" to edit a post", style: bodyStyle),
            ],
          ),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          image: _buildImage('liqueur3.jpg'),
          reverse: true,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}