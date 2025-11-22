import 'package:example/documents/listing/ListingDocumentService.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  List<ListingDocument> landingData = [
    ListingDocument(
      id: "0", 
      agent: agent, 
      address1: address1, 
      address2: address2, 
      price: price, 
      status: status, 
      beds: beds, 
      baths: baths, 
      sqft: sqft, 
      liked: liked, 
      loved: loved, 
      comments: comments, 
      description: description, 
      cover: cover, 
      assets: assets, 
      dateCreated: dateCreated, 
      dateUpdated: dateUpdated)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return SizedBox(
          height: height,
          width: width,
          child: Image.network(src),
        ),
      },
      ),
    );
  }
}