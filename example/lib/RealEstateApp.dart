import 'package:example/about.dart';
import 'package:example/buyers.dart';
import 'package:example/components/MainDrawer.dart';
import 'package:example/components/NavTextButton.dart';
import 'package:example/contact.dart';
import 'package:example/home.dart';
import 'package:example/pages/authSwitcher.dart';
import 'package:example/properties.dart';
import 'package:example/sellers.dart';
import 'package:flutter/material.dart';

class RealEstateApp extends StatefulWidget {
  const RealEstateApp({super.key});

  @override
  State<RealEstateApp> createState() => _RealEstateAppState();
}

class _RealEstateAppState extends State<RealEstateApp> {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();
  int _selected = 0;
  List<String> pages = [
    "home",
    "properties",
    "buyers",
    "sellers",
    "about",
    "contact",
    "agents"
  ];

  void _goTo(int index) {
    setState(() => _selected = index);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navKey.currentState?.pushReplacementNamed(
        index == 0
            ? '/home'
            : index == 1
            ? '/properties'
            : index == 2
            ? '/buyers'
            : index == 3
            ? '/sellers'
            : index == 4
            ? '/about'
            : index == 5 
            ? '/contact'
            : '/agents',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final double containerWidth = (width * 0.95).clamp(300, 1200);
        final double containerHeight = (height * 0.95).clamp(350, 1440);
        final bool isWide = width > height;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: width < 600,
            backgroundColor: Colors.white,
            title: const Text('PETER J BISHOP'),
            leading: isWide
                ? null
                : Builder(
                    builder: (context) {
                      return IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      );
                    },
                  ),
            actions: isWide
                ? List.generate(pages.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: NavTextButton(
                        index: index,
                        label: pages[index],
                        isSelected: _selected == index,
                        onPressed: () {
                          _goTo(index);
                        },
                      ),
                    );
                  })
                : [],
          ),
          drawer: MainDrawer(
            pages: pages,
            onItemSelected: (int index) {
              _goTo(index);
            },
          ),
          body: Stack(
            children: [
              Navigator(
                key: _navKey,
                initialRoute: '/home',
                onGenerateRoute: (settings) {
                  late Widget page;

                  switch (settings.name) {
                    case '/home':
                      page = HomePage();
                      break;
                    case '/properties':
                      page = PropertiesPage();
                      break;
                    case '/buyers':
                      page = BuyersPage();
                      break;
                    case '/sellers':
                      page = SellersPage();
                      break;
                    case '/about':
                      page = AboutPage();
                      break;
                    case '/contact':
                      page = ContactPage();
                      break;
                    case '/agents':
                      page = AuthSwitcher();
                      break;

                    default:
                      page = HomePage();
                  }

                  return MaterialPageRoute(builder: (_) => page);
                },
              ),

              Positioned(
                top: 40,
                right: 20,
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.black45,
                  child: Text(
                    'Overlay Widget',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
