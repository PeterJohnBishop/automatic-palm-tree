import 'package:example/models/ListingDocumentService.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  var _isHovering = false;
  List<ListingDocument> landingData = [
    ListingDocument(
      id: "0",
      agent: "Peter Bishop",
      address1: "4378 Sandalwood Dr.",
      address2: "St. Petersberg, FL 90837",
      price: "1100000.0",
      status: "Active",
      beds: "4",
      baths: "2.5",
      sqft: "3472",
      liked: [],
      loved: [],
      comments: [],
      description:
          "In a quiet Florida cul-de-sac lined with palm trees and tidy lawns, this standard suburban home sits beneath a bright, sun-washed sky, its stucco exterior painted a warm sandy beige that blends naturally with the coastal landscape. A red-tile roof slopes gently over spacious eaves, shading the wide front windows that look out onto a small, neatly trimmed yard bordered by hibiscus bushes in constant bloom. Inside, cool tiled floors run throughout the open living space, where ceiling fans hum softly against the humid afternoon air. Out back, a screened-in lanai leads to a modest backyard dotted with citrus trees—usually buzzing with the chatter of neighbors grilling, kids riding bikes, and the distant call of seabirds drifting in from the coast just a few miles away.",
      cover: "/home1/cover.webp",
      assets: [
        "/home1/1.webp",
        "/home1/2.webp",
        "/home1/3.webp",
        "/home1/4.webp",
        "/home1/5.webp",
        "/home1/6.webp",
        "/home1/7.webp",
        "/home1/8.webp",
        "/home1/9.webp",
        "/home1/10.webp",
      ],
      dateCreated: DateTime.now(),
      dateUpdated: DateTime.now(),
    ),
    ListingDocument(
      id: "0",
      agent: "Peter Bishop",
      address1: "901 Uber St.",
      address2: "Springfield, OH 12054",
      price: "380000.00",
      status: "Active",
      beds: "4",
      baths: "5.5",
      sqft: "4589",
      liked: [],
      loved: [],
      comments: [],
      description:
          "In a sleek new Florida development bordered by wetlands and winding bike paths, this modern suburban home stands out with its clean lines and minimalist architecture. The exterior blends smooth white stucco with charcoal-gray metal accents, while large floor-to-ceiling windows reflect the shimmering palm fronds and endless blue sky. Inside, the open-concept layout is anchored by polished concrete floors, recessed lighting, and a floating staircase that leads to a bright lofted second level. The kitchen features matte-black cabinetry and quartz countertops, seamlessly flowing into a living space framed by sliding glass walls that open to a covered patio. Out back, a compact saltwater plunge pool glows softly in the evening heat, surrounded by native grasses that sway in the warm coastal breeze drifting in from nearby lakes and preserves.",
      cover: "/home2/cover.webp",
      assets: [
        "/home2/1.webp",
        "/home2/2.webp",
        "/home2/3.webp",
        "/home2/4.webp",
        "/home2/5.webp",
        "/home2/6.webp",
        "/home2/7.webp",
        "/home2/8.webp",
        "/home2/9.webp",
      ],
      dateCreated: DateTime.now(),
      dateUpdated: DateTime.now(),
    ),
    ListingDocument(
      id: "0",
      agent: "Peter Bishop",
      address1: "901 Uber St.",
      address2: "Springfield, OH 12054",
      price: "380000.00",
      status: "Active",
      beds: "4",
      baths: "5.5",
      sqft: "4589",
      liked: [],
      loved: [],
      comments: [],
      description:
          "In a sleek new Florida development bordered by wetlands and winding bike paths, this modern suburban home stands out with its clean lines and minimalist architecture. The exterior blends smooth white stucco with charcoal-gray metal accents, while large floor-to-ceiling windows reflect the shimmering palm fronds and endless blue sky. Inside, the open-concept layout is anchored by polished concrete floors, recessed lighting, and a floating staircase that leads to a bright lofted second level. The kitchen features matte-black cabinetry and quartz countertops, seamlessly flowing into a living space framed by sliding glass walls that open to a covered patio. Out back, a compact saltwater plunge pool glows softly in the evening heat, surrounded by native grasses that sway in the warm coastal breeze drifting in from nearby lakes and preserves.",
      cover: "/home2/cover.webp",
      assets: [
        "/home2/1.webp",
        "/home2/2.webp",
        "/home2/3.webp",
        "/home2/4.webp",
        "/home2/5.webp",
        "/home2/6.webp",
        "/home2/7.webp",
        "/home2/8.webp",
        "/home2/9.webp",
      ],
      dateCreated: DateTime.now(),
      dateUpdated: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Column(
            children: [
              Row(
                children: [
                  MouseRegion(
                    onEnter: (_) => setState(() => _isHovering = true),
                    onExit: (_) => setState(() => _isHovering = false),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: _isHovering
                            ? Colors.black
                            : Colors.grey,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 32,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/auth');
                      },
                      child: Text("Login"),
                    ),
                  ),
                ],
              ),
              Expanded(
                // ← This gives ListView real height
                child: ListView.builder(
                  itemCount: landingData.length,
                  itemBuilder: (context, index) {
                    final listing = landingData[index];

                    return SizedBox(
                      height: height * .5, // ← REAL size limit
                      width: width * .3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                listing.cover,
                                height: height * 0.4,
                                width: width * 0.3,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16),
                            SizedBox(
                              height: height * .5, // ← REAL size limit
                              width: width * .3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 12),
                                  Text(
                                    listing.address1,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    listing.address2,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "\$${listing.price}",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  Row(
                                    children: [
                                      Icon(
                                        Icons.bed,
                                        size: 18,
                                        color: Colors.grey[700],
                                      ),
                                      const SizedBox(width: 4),
                                      Text("${listing.beds} Beds"),

                                      const SizedBox(width: 16),
                                      Icon(
                                        Icons.bathtub,
                                        size: 18,
                                        color: Colors.grey[700],
                                      ),
                                      const SizedBox(width: 4),
                                      Text("${listing.baths} Baths"),

                                      const SizedBox(width: 16),
                                      Icon(
                                        Icons.square_foot,
                                        size: 18,
                                        color: Colors.grey[700],
                                      ),
                                      const SizedBox(width: 4),
                                      Text("${listing.sqft} sqft"),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  Expanded(
                                    child: Text(
                                      listing.description,
                                      style: const TextStyle(fontSize: 15),
                                      overflow: TextOverflow.fade,
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
