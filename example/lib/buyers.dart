import 'package:example/components/imageSizer.dart';
import 'package:flutter/material.dart';

class BuyersPage extends StatefulWidget {
  const BuyersPage({super.key});

  @override
  State<BuyersPage> createState() => _BuyersPageState();
}

class _BuyersPageState extends State<BuyersPage> {
  final Map<String, bool> _orientationCache = {};
  final Map<int, bool> _hovered = {};

  @override
  void initState() {
    super.initState();
    _preloadOrientations();
  }

  void _preloadOrientations() async {
    for (final hood in neighborhoods) {
      if (!_orientationCache.containsKey(hood["url"])) {
        final size = await getImageSize(hood["url"]);
        _orientationCache[hood["url"]] = size.width > size.height;
        if (mounted) setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        var isWide = width > height;
        return Center(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: neighborhoods.length,
              itemBuilder: (context, index) {
                final hood = neighborhoods[index];
                final url = neighborhoods[index]["url"];
                final landscape = _orientationCache[url];

                return Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: MouseRegion(
                    onEnter: (_) => setState(() => _hovered[index] = true),
                    onExit: (_) => setState(() => _hovered[index] = false),
                    child: isWide
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: landscape == null
                                    ? const SizedBox(
                                        height: 200,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Image.network(
                                          url,
                                          fit: landscape
                                              ? BoxFit.fitWidth
                                              : BoxFit.fitHeight,
                                          height: landscape ? 300 : 900,
                                          width: landscape ? 600 : 600,
                                          errorBuilder: (_, __, ___) {
                                            return Container(
                                              height: 200,
                                              color: Colors.grey[300],
                                              child: const Center(
                                                child: Icon(
                                                  Icons.broken_image,
                                                  size: 50,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                              ),

                              SizedBox(width: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width: 300,
                                        decoration: BoxDecoration(),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              hood["name"],
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Population: ${hood["population"]}",
                                            ),
                                            Text(
                                              "Median price: \$${hood["median home price"]}",
                                            ),
                                            SizedBox(height: 16),
                                            Text(hood["description"]),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: landscape == null
                                    ? const SizedBox(
                                        height: 200,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : Image.network(
                                        url,
                                        fit: landscape
                                            ? BoxFit.fitWidth
                                            : BoxFit.fitHeight,
                                        height: landscape ? 300 : 900,
                                        width: landscape ? 600 : 600,
                                        errorBuilder: (_, __, ___) {
                                          return Container(
                                            height: 200,
                                            color: Colors.grey[300],
                                            child: const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                size: 50,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                              SizedBox(width: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width: 300,
                                        decoration: BoxDecoration(),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              hood["name"],
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Population: ${hood["population"]}",
                                            ),
                                            Text(
                                              "Median price: \$${hood["median home price"]}",
                                            ),
                                            SizedBox(height: 8),
                                            Text(hood["description"]),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

const List<Map<String, dynamic>> neighborhoods = [
  {
    "url":
        "https://firebasestorage.googleapis.com/v0/b/automatic-palm-tree.firebasestorage.app/o/assets%2Fwash.jpg?alt=media&token=eeafe3f2-34cb-407a-8c22-d0e8a3f8e156",
    "name": "Washington Park",
    "population": 7509,
    "median home price": 816840,
    "description":
        "Washington Park is a leafy, park-centric neighborhood anchored by 155 acres of green space, lakes, trails, and historic homes — making it a favorite for families and active residents who enjoy outdoor recreation and a close-knit community feel.",
  },
  {
    "url":
        "https://firebasestorage.googleapis.com/v0/b/automatic-palm-tree.firebasestorage.app/o/assets%2Ffive.jpg?alt=media&token=c45231c3-4516-4014-bcb0-7ee88e2fb0d7",
    "name": "Five Points",
    "population": 19079,
    "median home price": 555882,
    "description":
        "Five Points offers a culturally rich and diverse urban vibe, with a storied jazz heritage and evolving streets lined by historic homes and new development — ideal for those who appreciate a dynamic neighborhood close to downtown with a strong sense of character.",
  },
  {
    "url":
        "https://firebasestorage.googleapis.com/v0/b/automatic-palm-tree.firebasestorage.app/o/assets%2Flodo.jpg?alt=media&token=1bc96a1a-7d69-4d61-8c78-0b6d14a3fc9a",
    "name": "LoDo",
    "population": 8519,
    "median home price": 441900,
    "description":
        "LoDo (Lower Downtown) is a bustling downtown-adjacent neighborhood filled with historic buildings, nightlife, restaurants, and convenient transit, making it a go-to for young professionals and anyone wanting walkable city living.",
  },
  {
    "url":
        "https://firebasestorage.googleapis.com/v0/b/automatic-palm-tree.firebasestorage.app/o/assets%2Fjeff.jpg?alt=media&token=56ff65e6-e947-4864-aa5c-a94d2e5a1b2e",
    "name": "Jefferson Park",
    "population": 3379,
    "median home price": 539467,
    "description":
        "Jefferson Park is a smaller, residential neighborhood that offers a more relaxed, community-oriented feel while still being close to urban amenities — a good balance for those wanting a quieter home base without losing access to city life.",
  },
  {
    "url":
        "https://firebasestorage.googleapis.com/v0/b/automatic-palm-tree.firebasestorage.app/o/assets%2Fcherry.jpg?alt=media&token=cbaa9587-326b-418c-8034-463c0da12a1d",
    "name": "Cherry Creek",
    "population": 6954,
    "median home price": 782740,
    "description":
        "Cherry Creek is an upscale and walkable neighborhood with luxury shopping, high-end dining, and elegant housing; it appeals to residents seeking refined, convenient urban-suburban living with a comfortable lifestyle and close amenities.",
  },
  {
    "url":
        "https://firebasestorage.googleapis.com/v0/b/automatic-palm-tree.firebasestorage.app/o/assets%2Fbaker.jpg?alt=media&token=6829f6a9-181f-4f08-acb3-70038c919238",
    "name": "Baker",
    "population": 6749,
    "median home price": 433440,
    "description":
        "Baker is a central Denver neighborhood with a mix of residential charm and urban access — offering historic homes, an eclectic atmosphere, and proximity to downtown, making it appealing to those who value convenience and diversity.",
  },
  {
    "url":
        "https://firebasestorage.googleapis.com/v0/b/automatic-palm-tree.firebasestorage.app/o/assets%2Funiv.jpg?alt=media&token=3af55183-4fc4-4b44-a9a0-a216435b0a94",
    "name": "University (area)",
    "population": 9938,
    "median home price": 445780,
    "description":
        "The University area combines a mix of historic and more modest housing with convenient access to amenities and transit — suited for students, young professionals, or anyone wanting practical city-adjacent living without premium pricing.",
  },
  {
    "url":
        "https://firebasestorage.googleapis.com/v0/b/automatic-palm-tree.firebasestorage.app/o/assets%2Fhigh.jpg?alt=media&token=151b0f5c-19e6-4b17-ae50-6c1ac910cbfd",
    "name": "Highland (LoHi / West Highland)",
    "population": 10549,
    "median home price": 538020,
    "description":
        "Highland — including LoHi — blends walkable streets, boutique shops, trendy restaurants and bars, and a mix of historic homes and modern developments, making it ideal for urban dwellers who want a vibrant, social neighborhood with character.",
  },
  {
    "url":
        "https://firebasestorage.googleapis.com/v0/b/automatic-palm-tree.firebasestorage.app/o/assets%2Frino.jpg?alt=media&token=7093172d-e6bb-4d37-adc6-7d0f6d4cf203",
    "name": "RiNo (River North Art District)",
    "population": 8528,
    "median home price": 720000,
    "description":
        "RiNo is Denver’s creative hub — filled with art galleries, murals, breweries, nightlife, and renovated warehouses turned into modern lofts — perfect for artists, young professionals, and anyone drawn to a lively, artistic urban scene with easy access to downtown.",
  },
  {
    "url":
        "https://firebasestorage.googleapis.com/v0/b/automatic-palm-tree.firebasestorage.app/o/assets%2Fpark.jpg?alt=media&token=417cd2d8-82ef-45e8-ba08-0d5b0bfe0503",
    "name": "Park Hill",
    "population": 27000,
    "median home price": 735000,
    "description":
        "Park Hill is a long-established, family-friendly neighborhood known for its tree-lined streets, varied architecture (bungalows, Tudors, ranches), strong community feel, and easy access to parks and downtown — a good fit for families or anyone seeking stability and character.",
  },
];
