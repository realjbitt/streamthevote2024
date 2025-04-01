import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import '../utilities/constants.dart' as c;
import '../models/storage.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ScrollController _scrollController = ScrollController();
  final List<String> images = List.generate(20, (index) => 'images/flag.jpg');
  final List<String> texts = List.generate(20, (index) => 'Item ${index + 1}');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _controller.forward();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {}); // Trigger rebuild for parallax effect
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TranslucentCover(
      child: Stack(
        children: <Widget>[
          // Gradient Background with Parallax Effect
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.red[900]!,
                    Colors.white,
                    Colors.indigo[900]!,
                  ],
                  stops: [
                    0.0,
                    _scrollController.hasClients ? _scrollController.offset / 200 : 0.0,
                    1.0,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width > 950 ? 950 : MediaQuery.of(context).size.width,
              child: ListView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(180),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.5),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GifView.asset(
                                    'images/stv_animate.gif',
                                    height: 200,
                                    width: 200,
                                    frameRate: 10, // default is 15 FPS
                                  ),
                                  // Transform.rotate(
                                  //   angle: 270 * 3.14159 / 180,
                                  //   child: const Icon(
                                  //     Icons.arrow_downward_outlined,
                                  //     size: 40,
                                  //   ),
                                  // ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Transform.rotate(
                                        angle: 270 * 3.14159 / 180,
                                        child: const Icon(
                                          Icons.arrow_downward_outlined,
                                          size: 40,
                                        ),
                                      ),
                                      const Text(
                                        ' Find\nDrop\nBoxes ',
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black),
                                        textAlign: TextAlign.center,
                                      ),
                                      // const Text(
                                      //   'Click "Drop Boxes" above,\nor swipe right.',
                                      //   style: TextStyle(fontSize: 12, color: Colors.black),
                                      //   textAlign: TextAlign.center,
                                      // ),
                                    ],
                                  ),
                                  // const SizedBox(
                                  //   width: 100,
                                  // ),
                                  // TextButton(onPressed: onPressed, child: child)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(180),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'A significant portion of Americans are genuinely concerned about election integrity. Stream the Vote 2024 is a website designed to empower citizens by providing a platform for gathering and sharing video evidence directly from ballot drop box locations.',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(180),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Help Get Drop Box Video Evidence',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(180),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                'Join in a citizen-led effort to video record and livestream drop box activities. Simply your presence at a drop box can help deter illicit activities in the upcoming election.',
                                style: TextStyle(fontSize: 12, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Text(
                                'Individuals are responsible for following local, state, and federal laws and regulations. No matter what, be safe.',
                                style: TextStyle(fontSize: 12, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(180),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'You Can Do More Than Vote! You Can Be a Part of the Solution',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(180),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'While exact numbers vary, discussions and polls, like one from Rasmussen, suggest that up to 60% of the adult population might harbor concerns about election integrity. This initiative aims to foster transparency, ensuring that the electoral process remains under the vigilant eye of the public, thereby reinforcing trust in the system.',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(180),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Want to help?\nReach us on X\nor by email!',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(180),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Send:\n- Drop box addresses\n- Livestream links\n- Recording links',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(180),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "@streamthevote24 on X\nor\ncontact@streamthevote2024.com",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.blue[900],
                                  decoration: TextDecoration.underline,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(180),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Privacy Policy:\nWe do not use, share, or sell your data.\n\nNotice:\nEach individual is responsible for following applicable local, state, and federal laws and regulations regarding ballot drop boxes, polling locations, and all other locations. Stream The Vote 2024 simply denotes locations and provides associated web and video links. Stream The Vote 2024 is not responsible for any actions taken.\n\n${c.backgroundImageCredits}',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const LicenseContainer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TranslucentCover extends StatelessWidget {
  final Widget child;
  final double initialBlur;
  final double opacity;
  final Color overlayColor;

  const TranslucentCover({
    super.key,
    required this.child,
    this.initialBlur = 5.0,
    this.opacity = 0.5,
    this.overlayColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<Storage>(context);

    if (!appState.showCover) {
      return child;
    }

    return ChangeNotifierProvider.value(
      value: appState,
      child: _TranslucentCoverStateful(
        initialBlur: initialBlur,
        opacity: opacity,
        overlayColor: overlayColor,
        child: child,
      ),
    );
  }
}

class _TranslucentCoverStateful extends StatefulWidget {
  final Widget child;
  final double initialBlur;
  final double opacity;
  final Color overlayColor;

  const _TranslucentCoverStateful({
    required this.child,
    required this.initialBlur,
    required this.opacity,
    required this.overlayColor,
  });

  @override
  _TranslucentCoverState createState() => _TranslucentCoverState();
}

class _TranslucentCoverState extends State<_TranslucentCoverStateful> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _blurAnimation;
  late Animation<double> _textOpacityAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: widget.opacity, end: 0.0).animate(_controller);
    _blurAnimation = Tween<double>(begin: widget.initialBlur, end: 0.0).animate(_controller);
    _textOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller); // Animation for text
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleVisibility() {
    if (_isVisible) {
      _controller.forward().then((_) {
        setState(() {
          _isVisible = false;
        });
        Provider.of<Storage>(context, listen: false).hideCover();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleVisibility,
      child: Stack(
        children: <Widget>[
          widget.child,
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return _isVisible && _opacityAnimation.value > 0.0
                  ? Positioned.fill(
                      child: Stack(
                        children: [
                          BackdropFilter(
                            filter: ui.ImageFilter.blur(
                              sigmaX: _blurAnimation.value,
                              sigmaY: _blurAnimation.value,
                            ),
                            child: Container(
                              // This Container might seem redundant but is often necessary for BackdropFilter to work correctly
                              color: Colors.transparent, // Ensure the container doesn't add its own color
                            ),
                          ),
                          Center(
                            child: Opacity(
                              opacity: _textOpacityAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(20.0),
                                child: const Text(
                                  'Welcome to\nStream The Vote 2024!\n\nBy using this site, you agree that it is your responsibility to follow all local, state, and federal laws and regulations regarding drop boxes, polling places, and all other locations.\n\nMost importantly, be safe.\n\nClick anywhere to agree.',
                                  style: TextStyle(fontSize: 12, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container();
            },
          ),
        ],
      ),
    );
  }
}

class LicenseContainer extends StatefulWidget {
  const LicenseContainer({super.key});

  @override
  State<LicenseContainer> createState() => _LicenseContainerState();
}

class _LicenseContainerState extends State<LicenseContainer> {
  bool _isExpanded = false;

  // Example license information - you can replace this with your actual license text
  final String licenseInfo = c.licenseInfo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(180),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Click to see license information',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  licenseInfo,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
