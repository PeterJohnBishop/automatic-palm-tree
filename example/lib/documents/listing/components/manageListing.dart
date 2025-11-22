import 'package:example/documents/listing/ListingDocumentService.dart';
import 'package:example/documents/listing/components/ListingCover.dart';
import 'package:example/documents/listing/components/ListingDetails.dart';
import 'package:example/documents/listing/components/ListingImages.dart';
import 'package:flutter/material.dart';
class EditListing extends StatefulWidget {
  const EditListing({super.key});

  @override
  State<EditListing> createState() => _EditListingState();
}

class _EditListingState extends State<EditListing> {
  late ListingDocument listing;
  late String _agent = "";
  late String _address1 = "";
  late String _address2 = "";
  late double _price = 0.0;
  late String _status = "";
  late double _beds = 0.0;
  late double _baths = 0.0;
  late double _sqft = 0.0;
  late String _description = "";
  late String _cover = "";
  late List<String> _assets = [];


  void _saveListing(String selectedCover) {
    setState(() {
      listing = ListingDocument(
        id: "", 
        agent: _agent, 
        address1: _address1, 
        address2: _address2, 
        price: _price, 
        status: _status, 
        beds: _beds, 
        baths: _baths, 
        sqft: _sqft, 
        liked: [], 
        loved: [], 
        comments: [], 
        description: _description, 
        cover: _cover, 
        assets: _assets, 
        dateCreated: DateTime.now(), 
        dateUpdated:  DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: ListingCover(width: width, height: height),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: ListingImages(width: width, height: height),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: ListingDetails(width: width, height: height),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
